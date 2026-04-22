class AdStateModel {
  final int id;
  final String name;
  bool isSelected;

  AdStateModel({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  factory AdStateModel.fromJson(Map<String, dynamic> json) {
    return AdStateModel(
      id: _parseId(json['id'] ?? json['StateId']),
      name: (json['name'] ?? json['StateName'])?.toString().trim() ?? '',
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isSelected': isSelected,
    };
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
