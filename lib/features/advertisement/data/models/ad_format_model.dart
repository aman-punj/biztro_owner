class AdFormatModel {
  final int id;
  final String name;
  final String value;
  final String description;

  AdFormatModel({
    required this.id,
    required this.name,
    required this.value,
    required this.description,
  });

  factory AdFormatModel.fromJson(Map<String, dynamic> json) {
    return AdFormatModel(
      id: json['id'] as int,
      name: json['name'] as String,
      value: json['value'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'description': description,
    };
  }
}
