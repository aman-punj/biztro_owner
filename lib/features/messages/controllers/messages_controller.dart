import 'package:get/get.dart';

class ConversationModel {
  final String id;
  final String name;
  final String avatarInitials;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const ConversationModel({
    required this.id,
    required this.name,
    required this.avatarInitials,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

class MessagesController extends GetxController {
  final isLoading = true.obs;
  final hasError = false.obs;
  final searchQuery = ''.obs;

  final _allConversations = <ConversationModel>[].obs;

  List<ConversationModel> get filteredConversations {
    if (searchQuery.value.isEmpty) return _allConversations;
    return _allConversations
        .where(
          (c) => c.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 900));

      _allConversations.assignAll([
        const ConversationModel(
          id: '1',
          name: 'Sarah Jenkins',
          avatarInitials: 'SJ',
          lastMessage: 'Is there a private room for a birthday party?',
          time: '10:15 AM',
          unreadCount: 1,
          isOnline: true,
        ),
        const ConversationModel(
          id: '2',
          name: 'Marcus Miller',
          avatarInitials: 'MM',
          lastMessage: 'I think I left my umbrella at table 4 yesterday.',
          time: '09:42 AM',
          unreadCount: 0,
          isOnline: false,
        ),
        const ConversationModel(
          id: '3',
          name: 'Elena Rodriguez',
          avatarInitials: 'ER',
          lastMessage: 'The catering order for tonight looks perfect, thanks!',
          time: 'Yesterday',
          unreadCount: 0,
          isOnline: true,
        ),
        const ConversationModel(
          id: '4',
          name: 'Fresh Produce Co.',
          avatarInitials: 'FP',
          lastMessage: 'Your delivery is scheduled for 6:00 AM tomorrow.',
          time: 'Yesterday',
          unreadCount: 2,
        ),
        const ConversationModel(
          id: '5',
          name: 'David Chen',
          avatarInitials: 'DC',
          lastMessage: 'Can you adjust my reservation to 7:30 PM?',
          time: '24 Feb',
          unreadCount: 0,
        ),
        const ConversationModel(
          id: '6',
          name: 'Business Lunch Group',
          avatarInitials: 'BL',
          lastMessage: 'Do you provide a projector for presentations?',
          time: '24 Feb',
          unreadCount: 4,
          isOnline: true,
        ),
        const ConversationModel(
          id: '7',
          name: 'Sophie Walters',
          avatarInitials: 'SW',
          lastMessage: 'Wait, did you guys change the recipe for the pasta?',
          time: '23 Feb',
          unreadCount: 1,
        ),
        const ConversationModel(
          id: '8',
          name: 'Tech Support',
          avatarInitials: 'TS',
          lastMessage: 'Your POS system update is now complete.',
          time: '22 Feb',
          unreadCount: 0,
        ),
        const ConversationModel(
          id: '9',
          name: 'Liam O’Brien',
          avatarInitials: 'LO',
          lastMessage: 'Checking in about the live music setup for Friday.',
          time: '21 Feb',
          unreadCount: 0,
        ),
      ]);
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) => searchQuery.value = query;

  @override
  Future<void> refresh() => _loadConversations();
}
