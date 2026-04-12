class FeedbackSummaryModel {
  const FeedbackSummaryModel({
    required this.averageRating,
    required this.totalReviews,
  });

  final double averageRating;
  final int totalReviews;
}

class FeedbackItemModel {
  const FeedbackItemModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.location,
    required this.timeAgo,
    required this.isVerified,
    required this.rating,
    required this.comment,
  });

  final String id;
  final String userName;
  final String userImage;
  final String location;
  final String timeAgo;
  final bool isVerified;
  final int rating;
  final String comment;
}
