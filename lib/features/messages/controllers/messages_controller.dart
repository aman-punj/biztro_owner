import 'dart:async';
import 'package:bizrato_owner/core/services/chat_service.dart';
import 'package:bizrato_owner/features/messages/data/models/chat_models.dart';
import 'package:bizrato_owner/features/messages/data/repositories/chat_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessagesController extends GetxController {
  final ChatRepository _repository;
  
  MessagesController(this._repository);

  final isLoading = true.obs;
  final hasError = false.obs;
  final searchQuery = ''.obs;

  final _allConversations = <ConversationModel>[].obs;
  StreamSubscription? _chatListUpdateSub;

  List<ConversationModel> get filteredConversations {
    if (searchQuery.value.isEmpty) return _allConversations;
    return _allConversations
        .where((c) => c.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadConversations();
    
    if (Get.isRegistered<ChatService>()) {
      // _chatListUpdateSub = Get.find<ChatService>().onChatListUpdate.listen(_onChatListUpdate);
    }
  }

  @override
  void onClose() {
    _chatListUpdateSub?.cancel();
    super.onClose();
  }

  void _onChatListUpdate(ChatListUpdate update) {
    final index = _allConversations.indexWhere((c) => c.id == update.userId);
    
    // Format time for the UI
    String timeStr = DateFormat.jm().format(update.time);
    
    if (index != -1) {
      final old = _allConversations[index];
      final latest = old.copyWith(
        lastMessage: update.lastMessage,
        time: timeStr,
        unreadCount: old.unreadCount + update.unreadCountDelta,
      );
      _allConversations.removeAt(index);
      _allConversations.insert(0, latest);
    } else {
      // If new conversation, refresh the list to get full details
      refreshConversations();
    }
  }

  Future<void> _loadConversations() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final response = await _repository.getChatList();
      if (response.success && response.data != null) {
        // The API returns { "success": true, "data": [...] }
        final dynamic rawData = response.data;
        List<dynamic> list = [];
        
        if (rawData is Map && rawData.containsKey('data')) {
          list = rawData['data'];
        } else if (rawData is List) {
          list = rawData;
        }
        
        _allConversations.assignAll(
          list.map((e) => ConversationModel.fromJson(e as Map<String, dynamic>)).toList()
        );
      } else {
        hasError.value = true;
      }
    } catch (e) {
      print('Error loading conversations: $e');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) => searchQuery.value = query;

  Future<void> refreshConversations() => _loadConversations();
  
  void goToChatRoom(ConversationModel model) {
    // Navigate to ChatRoom. Reset unread counts locally.
    final index = _allConversations.indexWhere((c) => c.id == model.id);
    if (index != -1 && _allConversations[index].unreadCount > 0) {
      _allConversations[index] = _allConversations[index].copyWith(unreadCount: 0);
    }
    Get.toNamed(AppRoutes.chatRoom, arguments: model);
  }
}
