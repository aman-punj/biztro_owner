class SearchResultModel {
  const SearchResultModel({
    required this.keywordId,
    required this.displayName,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      keywordId: json['KeywordId']?.toString() ?? '',
      displayName: json['DisplayName']?.toString() ?? '',
    );
  }

  final String keywordId;
  final String displayName;
}
