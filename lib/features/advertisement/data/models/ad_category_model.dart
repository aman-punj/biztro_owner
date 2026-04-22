class AdCategoryModel {
  final int id;
  final String name;
  final String value;
  bool isSelected;

  AdCategoryModel({
    required this.id,
    required this.name,
    required this.value,
    this.isSelected = false,
  });

  factory AdCategoryModel.fromJson(Map<String, dynamic> json) {
    final categoryName =
        (json['name'] ?? json['CategoryName'] ?? json['DisplayName'])
                ?.toString()
                .trim() ??
            '';
    final categoryValue =
        (json['value'] ?? json['CategoryName'] ?? json['DisplayName'])
                ?.toString()
                .trim() ??
            categoryName;

    return AdCategoryModel(
      id: _parseId(json['id'] ?? json['CategoryId'] ?? json['KeywordId']),
      name: categoryName,
      value: categoryValue,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'isSelected': isSelected,
    };
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;

    final text = value?.toString().trim() ?? '';
    final parsed = int.tryParse(text);
    if (parsed != null) return parsed;

    return text.codeUnits.fold<int>(
      0,
      (previous, element) => (previous * 31 + element) & 0x7fffffff,
    );
  }
}
