import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

enum ConnectionStatus { connecting, connected, disconnected, error }

class ChatService extends GetxService {
  WebSocketChannel? _webSocket;
  int _reconnectAttempts = 0;
  static const _maxReconnectAttempts = 5;
  Timer? _reconnectTimer;
  Timer? _keepAliveTimer;

  String _merchantId = '';
  String? _connectionToken;
  int _invokeId = 0;

  String? _currentConversationId;

  // Streams
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onNewMessage => _messageController.stream;

  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onNotification => _notificationController.stream;

  final _connectionStatusController = StreamController<ConnectionStatus>.broadcast();
  Stream<ConnectionStatus> get onConnectionStatusChanged => _connectionStatusController.stream;

  static const _baseUrl = 'https://merchant.bizrato.com/signalr';
  static const _hubName = 'chatHub'; // lowercase — SignalR 2 maps hub names to lowercase
  static const _connectionData = '[{"name":"chatHub"}]';

  // ─────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────

  Future<ChatService> init({required String merchantId}) async {
    _merchantId = "SI01266676";
    await _connect();
    return this;
  }

  void setCurrentConversation(String conversationId) {
    _currentConversationId = conversationId;
    dev.log('Current conversation: $conversationId', name: 'ChatService');
  }

  void clearCurrentConversation() => _currentConversationId = null;

  bool get isConnected => _webSocket != null;

  ConnectionStatus get connectionStatus =>
      isConnected ? ConnectionStatus.connected : ConnectionStatus.disconnected;

  // ─────────────────────────────────────────────
  // Connection
  // ─────────────────────────────────────────────

  Future<void> _connect() async {
    if (_webSocket != null) return;

    _emitStatus(ConnectionStatus.connecting);

    try {
      // Step 1: Negotiate — get ConnectionToken
      dev.log('Negotiating...', name: 'ChatService');
      final negotiateUrl =
          '$_baseUrl/negotiate'
          '?clientProtocol=2.1'
          '&connectionData=${Uri.encodeComponent(_connectionData)}';

      final negotiateRes = await http
          .get(Uri.parse(negotiateUrl))
          .timeout(const Duration(seconds: 10));

      if (negotiateRes.statusCode != 200) {
        throw Exception('Negotiate failed: ${negotiateRes.statusCode}');
      }

      final negotiateData = jsonDecode(negotiateRes.body) as Map<String, dynamic>;
      _connectionToken = negotiateData['ConnectionToken']?.toString();

      if (_connectionToken == null || _connectionToken!.isEmpty) {
        throw Exception('No ConnectionToken received');
      }
      dev.log('Token received', name: 'ChatService');

      // Step 2: Connect via WebSocket
      final wsBase = _baseUrl
          .replaceFirst('https://', 'wss://')
          .replaceFirst('http://', 'ws://');

      final connectUrl =
          '$wsBase/connect'
          '?transport=webSockets'
          '&clientProtocol=2.1'
          '&connectionToken=${Uri.encodeComponent(_connectionToken!)}'
          '&connectionData=${Uri.encodeComponent(_connectionData)}';

      dev.log('Connecting WS...', name: 'ChatService');
      _webSocket = WebSocketChannel.connect(Uri.parse(connectUrl));

      _webSocket!.stream.listen(
        _handleMessage,
        onError: (e) {
          dev.log('WS error: $e', name: 'ChatService');
          _onDisconnected();
        },
        onDone: () {
          dev.log('WS closed', name: 'ChatService');
          _onDisconnected();
        },
      );

      // Step 3: /start — activates the connection (required by SignalR 2)
      final startUrl =
          '$_baseUrl/start'
          '?transport=webSockets'
          '&clientProtocol=2.1'
          '&connectionToken=${Uri.encodeComponent(_connectionToken!)}'
          '&connectionData=${Uri.encodeComponent(_connectionData)}';

      final startRes = await http
          .get(Uri.parse(startUrl))
          .timeout(const Duration(seconds: 10));

      dev.log('Start response: ${startRes.body}', name: 'ChatService');

      _reconnectAttempts = 0;
      _emitStatus(ConnectionStatus.connected);
      dev.log('SignalR connected ✅', name: 'ChatService');

      // Step 4: Join merchant group so server can push messages to us
      if (_merchantId.isNotEmpty) {
        await _joinGroup(_merchantId);
      }

      _startKeepAlive();
    } catch (e, st) {
      dev.log('Connect failed: $e\n$st', name: 'ChatService');
      _webSocket = null;
      _emitStatus(ConnectionStatus.error);
      _scheduleReconnect();
    }
  }

  void _onDisconnected() {
    _webSocket = null;
    _keepAliveTimer?.cancel();
    _emitStatus(ConnectionStatus.disconnected);
    _scheduleReconnect();
  }

  // ─────────────────────────────────────────────
  // Message handling
  // ─────────────────────────────────────────────

  void _handleMessage(dynamic raw) {
    if (raw == null || raw.toString().isEmpty) return;
    try {
      final data = jsonDecode(raw.toString()) as Map<String, dynamic>;
      dev.log('RAW: ${raw.toString()}', name: 'ChatService');
      // SignalR 2 wraps hub callbacks inside M: [ {H, M, A}, ... ]
      final messageList = data['M'] as List<dynamic>?;
      if (messageList == null || messageList.isEmpty) return; // keep-alive / ack

      for (final item in messageList) {
        final m = item as Map<String, dynamic>;
        final method = m['M']?.toString() ?? '';
        final args = m['A'] as List<dynamic>? ?? [];

        dev.log('Hub callback: $method args: $args', name: 'ChatService');

        switch (method) {
          case 'addNewMessageToPage':
            _handleNewMessage(args);
            break;
          case 'receiveNotification':
            _handleNotification(args);
            break;
        }
      }
    } catch (e) {
      dev.log('Parse error: $e', name: 'ChatService');
    }
  }

  // Server sends: addNewMessageToPage(senderId, message, attachment, type)
  void _handleNewMessage(List<dynamic> args) {
    final senderId     = args.length > 0 ? args[0]?.toString() ?? '' : '';
    final messageText  = args.length > 1 ? args[1]?.toString() ?? '' : '';
    final attachment   = args.length > 2 ? args[2]?.toString() ?? '' : '';
    final messageType  = args.length > 3 ? args[3]?.toString() ?? 'text' : 'text';

    final msg = {
      'senderId':      senderId,
      'message':       messageText,
      'attachmentUrl': attachment,
      'messageType':   messageType,
      'timestamp':     DateTime.now().toIso8601String(),
    };

    // If a conversation is active, only pass through messages from that user
    if (_currentConversationId == null || senderId == _currentConversationId) {
      if (!_messageController.isClosed) {
        _messageController.add(msg);
        dev.log('Message streamed from: $senderId', name: 'ChatService');
      }
    } else {
      dev.log(
        'Filtered (expected: $_currentConversationId, got: $senderId)',
        name: 'ChatService',
      );
    }
  }

  // Server sends: receiveNotification(title, message, senderId)
  void _handleNotification(List<dynamic> args) {
    if (_notificationController.isClosed) return;
    _notificationController.add({
      'title':    args.length > 0 ? args[0]?.toString() ?? '' : '',
      'message':  args.length > 1 ? args[1]?.toString() ?? '' : '',
      'senderId': args.length > 2 ? args[2]?.toString() ?? '' : '',
    });
  }

  // ─────────────────────────────────────────────
  // Hub invocations
  // ─────────────────────────────────────────────

  Future<void> _joinGroup(String userId) async {
    dev.log('Joining group: $userId', name: 'ChatService');
    await _invoke('JoinGroup', [userId]);
  }

  /// Merchant → User
  /// Server: SendMessage(toUserId, fromMerchantId, message, sentBy)
  Future<void> sendMessage({
    required String toUserId,
    required String message,
    String attachmentUrl = '',
  }) async {
    if (toUserId.isEmpty) throw Exception('toUserId is empty');
    if (_webSocket == null) throw Exception('Not connected');

    await _invoke('SendMessage', [toUserId, _merchantId, message, 'Merchant']);
    dev.log('SendMessage invoked → $toUserId', name: 'ChatService');
  }

  Future<void> _invoke(String method, List<dynamic> args) async {
    if (_webSocket == null) throw Exception('WebSocket not connected');

    _invokeId++;
    final payload = jsonEncode({
      'H': 'ChatHub',
      'M': method,
      'A': args,
      'I': _invokeId,
    });

    dev.log('Invoke: $payload', name: 'ChatService');
    _webSocket!.sink.add(payload);
  }

  // ─────────────────────────────────────────────
  // Keep-alive & reconnect
  // ─────────────────────────────────────────────

  void _startKeepAlive() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      try {
        _webSocket?.sink.add('{}');
      } catch (_) {}
    });
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _emitStatus(ConnectionStatus.error);
      return;
    }
    _reconnectTimer?.cancel();
    final delay = Duration(seconds: 2 * (1 << _reconnectAttempts));
    _reconnectAttempts++;
    dev.log(
      'Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts)',
      name: 'ChatService',
    );
    _reconnectTimer = Timer(delay, _connect);
  }

  void _emitStatus(ConnectionStatus status) {
    if (!_connectionStatusController.isClosed) {
      _connectionStatusController.add(status);
    }
  }

  // ─────────────────────────────────────────────
  // Cleanup
  // ─────────────────────────────────────────────

  void stopConnection() {
    _reconnectTimer?.cancel();
    _keepAliveTimer?.cancel();
    try { _webSocket?.sink.close(); } catch (_) {}
    _webSocket = null;
    _connectionToken = null;
    _emitStatus(ConnectionStatus.disconnected);
  }

  @override
  void onClose() {
    stopConnection();
    if (!_messageController.isClosed) _messageController.close();
    if (!_notificationController.isClosed) _notificationController.close();
    if (!_connectionStatusController.isClosed) _connectionStatusController.close();
    super.onClose();
  }
}