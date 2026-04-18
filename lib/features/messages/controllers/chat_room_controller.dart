import 'dart:async';
import 'dart:developer' as dev;
import 'package:bizrato_owner/core/app_toast/app_notification.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_type.dart';
import 'package:bizrato_owner/core/services/chat_service.dart';
import 'package:bizrato_owner/features/messages/data/models/chat_models.dart';
import 'package:bizrato_owner/features/messages/data/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DateGroupUI {
  final String dateString;
  final List<ChatMessageModel> messages;
  DateGroupUI(this.dateString, this.messages);
}

class ChatRoomController extends GetxController {
  final ChatRepository _repository;
  ChatRoomController(this._repository);

  late final ConversationModel conversation;

  final messages = <ChatMessageModel>[].obs;
  final isLoading = true.obs;
  final isUploadingImage = false.obs;
  final connectionStatus = Rx<ConnectionStatus>(ConnectionStatus.disconnected);

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionSubscription;

  // ─────────────────────────────────────────────
  // Grouped messages for UI
  // ─────────────────────────────────────────────

  List<DateGroupUI> get groupedMessages {
    if (messages.isEmpty) return [];
    final groups = <String, List<ChatMessageModel>>{};
    for (final msg in messages) {
      final key = msg.dateGroup ?? _formatDate(msg.timestamp);
      groups.putIfAbsent(key, () => []).add(msg);
    }
    return groups.entries.map((e) => DateGroupUI(e.key, e.value)).toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  // ─────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    conversation = Get.arguments as ConversationModel;
    _loadHistory();
    _subscribeToService();
  }

  @override
  void onClose() {
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
    if (Get.isRegistered<ChatService>()) {
      Get.find<ChatService>().clearCurrentConversation();
    }
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────
  // Service subscriptions
  // ─────────────────────────────────────────────

  void _subscribeToService() {
    if (!Get.isRegistered<ChatService>()) return;

    final chatService = Get.find<ChatService>();

    // Tell service which conversation is active for filtering
    chatService.setCurrentConversation(conversation.id);

    // Reflect current status immediately
    connectionStatus.value = chatService.connectionStatus;

    _connectionSubscription = chatService.onConnectionStatusChanged.listen((status) {
      connectionStatus.value = status;
      dev.log('Connection: $status', name: 'ChatRoomController');
    });

    _messageSubscription = chatService.onNewMessage.listen((data) {
      // data keys: senderId, message, attachmentUrl, messageType, timestamp
      final senderId = data['senderId']?.toString() ?? '';

      // Only accept messages belonging to the open conversation.
      // senderId from addNewMessageToPage is the userId who sent it.
      if (senderId != conversation.id) {
        dev.log(
          'Ignored message from $senderId (open: ${conversation.id})',
          name: 'ChatRoomController',
        );
        return;
      }

      final msg = ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: senderId,
        text: data['message']?.toString() ?? '',
        attachmentUrl: data['attachmentUrl']?.toString(),
        timestamp: DateTime.now(),
        isFromMerchant: false, // came from user
        dateGroup: 'Today',
      );

      _addMessageIfNew(msg);
    });
  }

  // ─────────────────────────────────────────────
  // Load history
  // ─────────────────────────────────────────────

  Future<void> _loadHistory() async {
    isLoading.value = true;
    try {
      final res = await _repository.getChatHistory(conversation.id);
      if (res.success && res.data != null) {
        final dynamic raw = res.data;
        List<dynamic> list = [];

        if (raw is Map && raw.containsKey('data')) {
          list = raw['data'];
        } else if (raw is List) {
          list = raw;
        }

        messages.assignAll(
          list.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>)).toList(),
        );
        _scrollToBottom();
      }
    } catch (e) {
      dev.log('Load history error: $e', name: 'ChatRoomController');
      _showError('Failed to load chat history');
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // Send message
  // ─────────────────────────────────────────────

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    messageController.clear();

    // Optimistic UI — add immediately before server confirms
    final optimistic = ChatMessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: conversation.id,
      text: text,
      timestamp: DateTime.now(),
      isFromMerchant: true,
      dateGroup: 'Today',
    );
    messages.add(optimistic);
    _scrollToBottom();

    try {
      if (Get.isRegistered<ChatService>()) {
        await Get.find<ChatService>().sendMessage(
          toUserId: conversation.id,
          message: text,
        );
      }
    } catch (e) {
      // Remove optimistic message on failure
      messages.removeWhere((m) => m.id == optimistic.id);
      _showError('Failed to send: ${e.toString()}');
      dev.log('Send error: $e', name: 'ChatRoomController');
    }
  }

  // ─────────────────────────────────────────────
  // Send image
  // ─────────────────────────────────────────────

  Future<void> pickAndSendImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      isUploadingImage.value = true;

      final res = await _repository.uploadAttachment(picked.path);
      if (res.success && res.data != null) {
        final dynamic data = res.data;
        String? url;
        if (data is Map) {
          url = (data['url'] ?? data['data']?['url'] ?? data['FilePath'])?.toString();
        }

        if (url != null && url.isNotEmpty) {
          if (Get.isRegistered<ChatService>()) {
            await Get.find<ChatService>().sendMessage(
              toUserId: conversation.id,
              message: '',
              attachmentUrl: url,
            );
            messages.add(ChatMessageModel(
              id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
              senderId: conversation.id,
              text: '',
              attachmentUrl: url,
              timestamp: DateTime.now(),
              isFromMerchant: true,
              dateGroup: 'Today',
            ));
            _scrollToBottom();
          }
        }
      } else {
        _showError('Failed to upload image');
      }
    } catch (e) {
      _showError('Image upload error');
      dev.log('Image upload error: $e', name: 'ChatRoomController');
    } finally {
      isUploadingImage.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────

  void _addMessageIfNew(ChatMessageModel msg) {
    if (!messages.any((e) => e.id == msg.id)) {
      messages.add(msg);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 500,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String message) {
    if (Get.isRegistered<AppToastService>()) {
      Get.find<AppToastService>().show(
        AppToast(title: 'Error', message: message, type: AppToastType.error),
      );
    }
  }
}