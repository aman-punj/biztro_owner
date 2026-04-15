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
      id: json['id'] as int,
      name: json['name'] as String,
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
}
