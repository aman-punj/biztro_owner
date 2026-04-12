import 'package:bizrato_owner/features/feedback/data/models/feedback_model.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  final isLoading = false.obs;

  final summary = const FeedbackSummaryModel(
    averageRating: 4.5,
    totalReviews: 2567,
  ).obs;

  // Tabs: 0: All Feedbacks, 1: Recent, 2: Negative
  final selectedTab = 0.obs;

  final feedbacks = <FeedbackItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    feedbacks.value = List.generate(
      5,
      (index) => FeedbackItemModel(
        id: 'mock_$index',
        userName: 'Towhidur Rahman',
        userImage: 'https://i.pravatar.cc/150?img=${11 + index}',
        location: 'Jaipur',
        timeAgo: '2 hours ago',
        isVerified: true,
        rating: 4, // Intentionally 4 matching the 4-and-a-half stars vaguely, or exact 4 like Figma screenshot
        comment: 'The quality of service provided by this merchant is exceptional. I really liked the timing!',
      ),
    );
  }

  void switchTab(int index) {
    selectedTab.value = index;
    // In future: Filter the list based on tab or hit API again.
  }

  void replyToFeedback(FeedbackItemModel item) {
    // Stub
  }
}
