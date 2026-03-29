class KeywordModel {
  const KeywordModel({
    required this.keywordId,
    required this.keywordTypeId,
    this.keywordType,
    required this.keyword,
  });

  factory KeywordModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return KeywordModel(
      keywordId: parseInt(json['KeywordId']),
      keywordTypeId: parseInt(json['KeywordTypeId']),
      keywordType: json['KeywordType']?.toString(),
      keyword: json['Keyword']?.toString() ?? '',
    );
  }

  final int keywordId;
  final int keywordTypeId;
  final String? keywordType;
  final String keyword;
}
