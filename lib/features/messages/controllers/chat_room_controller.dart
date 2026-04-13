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
  
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  StreamSubscription? _messageSubscription;

  List<DateGroupUI> get groupedMessages {
    if (messages.isEmpty) return [];
    
    final groups = <String, List<ChatMessageModel>>{};
    
    for (final msg in messages) {
      final dateKey = msg.dateGroup ?? _formatDate(msg.timestamp);
      if (!groups.containsKey(dateKey)) {
        groups[dateKey] = [];
      }
      groups[dateKey]!.add(msg);
    }
    
    return groups.entries.map((e) => DateGroupUI(e.key, e.value)).toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);
    
    if (checkDate == today) {
      return 'Today';
    } else if (checkDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  void onInit() {
    super.onInit();
    conversation = Get.arguments as ConversationModel;
    _loadHistory();
    
    if (Get.isRegistered<ChatService>()) {
      _messageSubscription = Get.find<ChatService>().onNewMessage.listen((data) {
        // Map SignalR 2.x data to ChatMessageModel
        final msg = ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: data['fromMerchantId']?.toString() ?? '',
          text: data['message']?.toString() ?? '',
          timestamp: DateTime.now(),
          isFromMerchant: data['sentBy'] == 'Merchant',
          dateGroup: 'Today',
        );
        _onNewMessage(msg);
      });
    }
  }

  @override
  void onClose() {
    _messageSubscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _onNewMessage(ChatMessageModel msg) {
    // Check if message belongs to this chat
    // For merchant app, if I send a message, receiverId is the user. 
    // If user sends, senderId is the user.
    if (msg.senderId == conversation.id || msg.id.contains(conversation.id)) {
      if (!messages.any((e) => e.id == msg.id)) {
        messages.add(msg);
        _scrollToBottom();
      }
    }
  }

  Future<void> _loadHistory() async {
    isLoading.value = true;
    try {
      final res = await _repository.getChatHistory(conversation.id);
      if (res.success && res.data != null) {
        final dynamic rawData = res.data;
        List<dynamic> list = [];
        
        if (rawData is Map && rawData.containsKey('data')) {
          list = rawData['data'];
        } else if (rawData is List) {
          list = rawData;
        }

        messages.assignAll(
          list.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>)).toList()
        );
        _scrollToBottom();
      }
    } catch (e) {
      dev.log('Error loading history: $e', name: 'ChatRoomController');
      _showError('Failed to load chat history');
    } finally {
      isLoading.value = false;
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

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    try {
      if (Get.isRegistered<ChatService>()) {
        await Get.find<ChatService>().sendFromUser(
          conversation.id,
          'merchant',
          text,
          'Merchant',
        );

        // Optimistic UI
        messages.add(ChatMessageModel(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          senderId: 'merchant',
          text: text,
          timestamp: DateTime.now(),
          isFromMerchant: true,
          dateGroup: 'Today',
        ));
        _scrollToBottom();
      }
    } catch (_) {
      _showError('Failed to send message');
    }
  }

  Future<void> pickAndSendImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      
      isUploadingImage.value = true;
      
      final res = await _repository.uploadAttachment(pickedFile.path);
      if (res.success && res.data != null) {
        final dynamic data = res.data;
        String? url;
        if (data is Map) {
          url = (data['url'] ?? data['data']?['url'] ?? data['FilePath'])?.toString();
        }
        
        if (url != null && url.isNotEmpty) {
          if (Get.isRegistered<ChatService>()) {
            await Get.find<ChatService>().sendFromUser(conversation.id, 'merchant', '[Image] $url', 'Merchant');
            
            final optimisticMsg = ChatMessageModel(
              id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
              senderId: 'merchant',
              text: '',
              attachmentUrl: url,
              timestamp: DateTime.now(),
              isFromMerchant: true,
              dateGroup: 'Today',
            );
            messages.add(optimisticMsg);
            _scrollToBottom();
          }
        }
      } else {
        _showError('Failed to upload image');
      }
    } catch (_) {
      _showError('Image upload error');
    } finally {
      isUploadingImage.value = false;
    }
  }

  void _showError(String message) {
    if (Get.isRegistered<AppToastService>()) {
      Get.find<AppToastService>().show(
        AppToast(
          title: 'Error',
          message: message,
          type: AppToastType.error,
        ),
      );
    }
  }
}
