// chat_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:get/get.dart';

class ChatService extends GetxService {
  WebSocket? _socket;
  bool _isConnected = false;
  int _invokeId = 0;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onNewMessage => _messageController.stream;

  static const _baseUrl = 'https://merchant.bizrato.com/signalr';
  static const _hubName = 'ChatHub';

  Future<ChatService> init() async {
    await _connect();
    return this;
  }

  Future<void> _connect() async {
    try {
      // Step 1: Negotiate
      final negotiateUri = Uri.parse(
        '$_baseUrl/negotiate?clientProtocol=1.5&connectionData=${Uri.encodeComponent('[{"name":"$_hubName"}]')}',
      );
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(negotiateUri);
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      httpClient.close();

      final negotiateData = jsonDecode(body) as Map<String, dynamic>;
      final token = negotiateData['ConnectionToken'] as String;

      // Step 2: Connect via WebSocket
      final wsUrl =
          '${_baseUrl.replaceFirst('https://', 'wss://')}/connect'
          '?transport=webSockets'
          '&clientProtocol=1.5'
          '&connectionToken=${Uri.encodeComponent(token)}'
          '&connectionData=${Uri.encodeComponent('[{"name":"$_hubName"}]')}';

      _socket = await WebSocket.connect(wsUrl);
      dev.log('SignalR WS connected', name: 'ChatService');

      // Step 3: /start — activates the connection (required by SignalR 2)
      final startClient = HttpClient();
      final startReq = await startClient.getUrl(Uri.parse(
        '$_baseUrl/start'
            '?transport=webSockets'
            '&clientProtocol=1.5'
            '&connectionToken=${Uri.encodeComponent(token)}'
            '&connectionData=${Uri.encodeComponent('[{"name":"$_hubName"}]')}',
      ));
      final startRes = await startReq.close();
      final startBody = await startRes.transform(utf8.decoder).join();
      startClient.close();
      dev.log('SignalR start response: $startBody', name: 'ChatService');

      _isConnected = true;

      // Step 4: Listen for messages
      _socket!.listen(
        _onMessage,
        onDone: () {
          _isConnected = false;
          dev.log('SignalR disconnected', name: 'ChatService');
          Future.delayed(const Duration(seconds: 3), _connect);
        },
        onError: (e) {
          _isConnected = false;
          dev.log('SignalR error: $e', name: 'ChatService');
        },
      );
    } catch (e) {
      dev.log('SignalR connect failed: $e', name: 'ChatService');
      Future.delayed(const Duration(seconds: 5), _connect);
    }
  }
  void _onMessage(dynamic raw) {
    if (raw == null || raw.toString().isEmpty) return;
    try {
      final data = jsonDecode(raw.toString()) as Map<String, dynamic>;

      // SignalR 2 message format: {"M": [{"H": "ChatHub", "M": "SendMessage", "A": [...]}]}
      final messages = data['M'] as List<dynamic>?;
      if (messages == null) return;

      for (final msg in messages) {
        final m = msg as Map<String, dynamic>;
        if (m['M'] == 'SendMessage') {
          final args = m['A'] as List<dynamic>;
          _messageController.add({
            'toUserId':       args[0],
            'fromMerchantId': args[1],
            'message':        args[2],
            'sentBy':         args[3],
          });
        }
      }
    } catch (e) {
      dev.log('Parse error: $e', name: 'ChatService');
    }
  }

  // Invoke SendFromUser(userId, merchantId, message, sentBy)
  Future<void> sendFromUser(
      String userId,
      String merchantId,
      String message,
      String sentBy,
      ) async {
    if (!_isConnected || _socket == null) {
      await _connect();
    }
    final payload = jsonEncode({
      'H': _hubName,
      'M': 'SendFromUser',
      'A': [userId, merchantId, message, sentBy],
      'I': _invokeId++,
    });
    _socket!.add(payload);
  }

  void stopConnection() {
    _socket?.close();
    _socket = null;
    _isConnected = false;
  }

  @override
  void onClose() {
    stopConnection();
    _messageController.close();
    super.onClose();
  }
}