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
          name: 'Gurwinder Singh',
          avatarInitials: 'GS',
          lastMessage: 'Is the restaurant open today?',
          time: '21 Feb 9:42 AM',
          unreadCount: 2,
          isOnline: true,
        ),
        const ConversationModel(
          id: '2',
          name: 'Aarav Sharma',
          avatarInitials: 'AS',
          lastMessage: 'Can I pre-book a table for 4?',
          time: '21 Feb 9:40 AM',
          unreadCount: 0,
          isOnline: false,
        ),
        const ConversationModel(
          id: '3',
          name: 'Vivaan Verma',
          avatarInitials: 'VV',
          lastMessage: 'What time do you close on Sundays?',
          time: '21 Feb 9:40 AM',
          unreadCount: 1,
          isOnline: true,
        ),
        const ConversationModel(
          id: '4',
          name: 'Arjun Mehta',
          avatarInitials: 'AM',
          lastMessage: 'Do you have vegan options?',
          time: '21 Feb 9:40 AM',
          unreadCount: 0,
        ),
        const ConversationModel(
          id: '5',
          name: 'Rahul Jain',
          avatarInitials: 'RJ',
          lastMessage: 'Loved the food! Will visit again.',
          time: '21 Feb 9:40 AM',
          unreadCount: 0,
        ),
        const ConversationModel(
          id: '6',
          name: 'Mukesh Choudhary',
          avatarInitials: 'MC',
          lastMessage: 'Party booking for 20 people?',
          time: '21 Feb 9:40 AM',
          unreadCount: 3,
          isOnline: true,
        ),
        const ConversationModel(
          id: '7',
          name: 'Ankit Saxena',
          avatarInitials: 'AX',
          lastMessage: 'Is there parking near by?',
          time: '21 Feb 9:40 AM',
          unreadCount: 0,
        ),
        const ConversationModel(
          id: '8',
          name: 'Deepak Srivastava',
          avatarInitials: 'DS',
          lastMessage: 'Loved the ambiance!',
          time: '21 Feb 9:40 AM',
          unreadCount: 0,
        ),
        const ConversationModel(
          id: '9',
          name: 'Tarun Pandey',
          avatarInitials: 'TP',
          lastMessage: 'Do you take UPI payments?',
          time: '21 Feb 9:40 AM',
          unreadCount: 1,
        ),
      ]);
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) => searchQuery.value = query;

  Future<void> refresh() => _loadConversations();
}
