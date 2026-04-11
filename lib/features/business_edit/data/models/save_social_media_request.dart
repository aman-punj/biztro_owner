class SaveSocialMediaRequest {
  const SaveSocialMediaRequest({
    required this.merchantId,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.twitterUrl,
    required this.linkedinUrl,
    required this.youTubeUrl,
    required this.isPubliclyVisible,
  });

  final int merchantId;
  final String facebookUrl;
  final String instagramUrl;
  final String twitterUrl;
  final String linkedinUrl;
  final String youTubeUrl;
  final bool isPubliclyVisible;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'MerchantId': merchantId,
      'FacebookUrl': facebookUrl,
      'InstagramUrl': instagramUrl,
      'TwitterUrl': twitterUrl,
      'LinkedinUrl': linkedinUrl,
      'YouTubeUrl': youTubeUrl,
      'IsPubliclyVisible': isPubliclyVisible,
    };
  }
}
