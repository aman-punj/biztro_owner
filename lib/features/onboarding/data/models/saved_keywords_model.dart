class SavedKeywordItem {
  const SavedKeywordItem({
    required this.keywordId,
    required this.keywordType,
  });

  factory SavedKeywordItem.fromJson(Map<String, dynamic> json) {
    return SavedKeywordItem(
      keywordId: _parseInt(json['KeywordId']),
      keywordType: json['KeywordType']?.toString() ?? '',
    );
  }

  final int keywordId;
  final String keywordType;
}

class SavedKeywordsModel {
  const SavedKeywordsModel({
    required this.success,
    required this.keywords,
    required this.otherKeywords,
  });

  factory SavedKeywordsModel.fromJson(Map<String, dynamic> json) {
    final rawKeywords = json['Keywords'];
    final rawOtherKeywords = json['OtherKeywords'];

    return SavedKeywordsModel(
      success: _parseBool(json['success']),
      keywords: rawKeywords is List
          ? rawKeywords
              .whereType<Map>()
              .map(
                (item) => SavedKeywordItem.fromJson(
                  item.cast<String, dynamic>(),
                ),
              )
              .toList()
          : const <SavedKeywordItem>[],
      otherKeywords: rawOtherKeywords is List
          ? rawOtherKeywords
              .map((item) => item?.toString() ?? '')
              .where((item) => item.isNotEmpty)
              .toList()
          : const <String>[],
    );
  }

  final bool success;
  final List<SavedKeywordItem> keywords;
  final List<String> otherKeywords;
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _parseBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  final normalized = value?.toString().toLowerCase();
  return normalized == 'true' || normalized == '1';
}
