import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:bizrato_owner/core/services/notification_service.dart';
import 'package:bizrato_owner/features/messages/data/models/chat_models.dart';
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

  String _businessId = '';
  String? _connectionToken;
  int _invokeId = 0;
  final Map<String, DateTime> _recentIncomingSignatures = <String, DateTime>{};
  static const Duration _duplicateWindow = Duration(seconds: 2);

  String? _currentConversationId;

  // Streams
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onNewMessage => _messageController.stream;

  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onNotification => _notificationController.stream;

  final _connectionStatusController = StreamController<ConnectionStatus>.broadcast();
  Stream<ConnectionStatus> get onConnectionStatusChanged => _connectionStatusController.stream;

  static const _baseUrl = 'https://merchant.bizrato.com/signalr';
  // static const _hubName = 'chatHub';
  static const _connectionData = '[{"name":"chatHub"}]';

  Future<ChatService> init({required String businessId}) async {
    _businessId = businessId;
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
      if (_businessId.isNotEmpty) {
        await _joinGroup(_businessId);
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
    final senderId     = args.isNotEmpty ? args[0]?.toString() ?? '' : '';
    final messageText  = args.length > 1 ? args[1]?.toString() ?? '' : '';
    final attachment   = args.length > 2 ? args[2]?.toString() ?? '' : '';
    final messageType  = args.length > 3 ? args[3]?.toString() ?? 'text' : 'text';

    _emitIncomingMessage(
      senderId: senderId,
      message: messageText,
      attachmentUrl: attachment,
      messageType: messageType,
    );
  }

  // Server sends: receiveNotification(title, message, senderId)
  void _handleNotification(List<dynamic> args) {
    final title = args.isNotEmpty ? args[0]?.toString() ?? '' : '';
    final message = args.length > 1 ? args[1]?.toString() ?? '' : '';
    final senderId = args.length > 2 ? args[2]?.toString() ?? '' : '';
    final isImage = ChatMediaUrl.isImagePath(message);

    _emitIncomingMessage(
      senderId: senderId,
      message: isImage ? '' : message,
      attachmentUrl: isImage ? message : '',
      messageType: isImage ? 'image' : 'text',
      title: title,
      notificationMessage: message,
    );
  }

  void _emitIncomingMessage({
    required String senderId,
    required String message,
    required String attachmentUrl,
    required String messageType,
    String title = '',
    String notificationMessage = '',
  }) {
    final normalizedAttachment = ChatMediaUrl.normalize(attachmentUrl);
    final isImage = normalizedAttachment.isNotEmpty ||
        messageType.toLowerCase() == 'image' ||
        ChatMediaUrl.isImagePath(message);
    final displayMessage = notificationMessage.isNotEmpty
        ? notificationMessage
        : (message.isNotEmpty ? message : 'Image');

    if (_isDuplicateIncoming(
      senderId: senderId,
      message: isImage ? '' : message,
      attachmentUrl: isImage ? normalizedAttachment : '',
      messageType: isImage ? 'image' : messageType,
      displayMessage: displayMessage,
    )) {
      dev.log('Skipped duplicate incoming event for sender: $senderId', name: 'ChatService');
      return;
    }

    final msg = {
      'senderId': senderId,
      'message': isImage ? '' : message,
      'attachmentUrl': isImage ? normalizedAttachment : '',
      'messageType': isImage ? 'image' : messageType,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (_currentConversationId == senderId) {
      if (!_messageController.isClosed) {
        _messageController.add(msg);
        dev.log('Message streamed from: $senderId', name: 'ChatService');
      }
      return;
    }

    final notification = {
      'title': title,
      'message': displayMessage,
      'senderId': senderId,
      'attachmentUrl': isImage ? normalizedAttachment : '',
      'messageType': isImage ? 'image' : messageType,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (!_notificationController.isClosed) {
      _notificationController.add(notification);
    }

    if (Get.isRegistered<NotificationService>()) {
      unawaited(Get.find<NotificationService>().showChatNotification(
        title: _notificationTitle(title),
        message: isImage ? 'Image' : displayMessage,
        senderId: senderId,
        attachmentUrl: isImage ? normalizedAttachment : '',
      ));
    }
  }

  String _notificationTitle(String title) {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty || int.tryParse(normalizedTitle) != null) {
      return 'New message';
    }

    return normalizedTitle;
  }

  bool _isDuplicateIncoming({
    required String senderId,
    required String message,
    required String attachmentUrl,
    required String messageType,
    required String displayMessage,
  }) {
    final now = DateTime.now();
    _recentIncomingSignatures.removeWhere(
      (_, time) => now.difference(time) > _duplicateWindow,
    );

    final normalizedText = message.trim().toLowerCase();
    final normalizedAttachment = attachmentUrl.trim().toLowerCase();
    final normalizedDisplay = displayMessage.trim().toLowerCase();
    final signature =
        '$senderId|$messageType|$normalizedText|$normalizedAttachment|$normalizedDisplay';

    final lastSeen = _recentIncomingSignatures[signature];
    if (lastSeen != null && now.difference(lastSeen) <= _duplicateWindow) {
      return true;
    }

    _recentIncomingSignatures[signature] = now;
    return false;
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

    final outboundMessage = attachmentUrl.trim().isNotEmpty ? attachmentUrl : message;
    await _invoke('SendMessage', [toUserId, _businessId, outboundMessage, 'Merchant']);
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
