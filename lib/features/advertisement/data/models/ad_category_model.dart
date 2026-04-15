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
    return AdCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      value: json['value'] as String,
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
}
