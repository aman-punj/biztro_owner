class SelectedKeyword {
  const SelectedKeyword({
    required this.keywordId,
    required this.keywordType,
  });

  final int keywordId;

  final int keywordType;

  Map<String, dynamic> toJson() => {
    'KeywordId': keywordId,
    'KeywordType': keywordType.toString(),
  };
}

class SaveKeywordsRequest {
  const SaveKeywordsRequest({
    required this.businessName,
    required this.categoryId,
    required this.keywords,
    this.otherKeywords = const [],
    required this.merchantId,
  });

  final String businessName;

  final String categoryId;

  final List<SelectedKeyword> keywords;

  final List<String> otherKeywords;

  final int merchantId;

  Map<String, dynamic> toJson() {
    return {
      'BusinessName': businessName,
      'CategoryId': categoryId,
      'Keywords': keywords.map((e) => e.toJson()).toList(),
      'OtherKeywords': otherKeywords,
      'MerchantId': merchantId,
    };
  }
}