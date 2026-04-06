class FestivalModel {
  const FestivalModel({
    required this.festivalId,
    required this.festivalName,
    required this.festivalImageUrl,
  });

  factory FestivalModel.fromJson(Map<String, dynamic> json) {
    return FestivalModel(
      festivalId: (json['FestivalId'] as num?)?.toInt() ?? 0,
      festivalName: (json['FestivalName'] as String? ?? '').trim(),
      festivalImageUrl: (json['FestivalImageUrl'] as String? ?? '').trim(),
    );
  }

  final int festivalId;
  final String festivalName;
  final String festivalImageUrl;
}

class FestivalPostModel {
  const FestivalPostModel({
    required this.postId,
    required this.festivalId,
    required this.festivalName,
    required this.postImageUrl,
  });

  factory FestivalPostModel.fromJson(Map<String, dynamic> json) {
    return FestivalPostModel(
      postId: (json['PostId'] as num?)?.toInt() ?? 0,
      festivalId: (json['FestivalId'] as num?)?.toInt() ?? 0,
      festivalName: (json['FestivalName'] as String? ?? '').trim(),
      postImageUrl: (json['PostImageUrl'] as String? ?? '').trim(),
    );
  }

  final int postId;
  final int festivalId;
  final String festivalName;
  final String postImageUrl;
}
