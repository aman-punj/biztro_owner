class AdFormatModel {
  final int id;
  final String name;
  final String value;
  final String description;
  final String leadingText;
  final String iconPath;

  AdFormatModel({
    required this.id,
    required this.name,
    required this.value,
    required this.description,
    this.leadingText = '',
    this.iconPath = '',
  });

  factory AdFormatModel.fromJson(Map<String, dynamic> json) {
    return AdFormatModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      leadingText: json['leadingText']?.toString() ?? '',
      iconPath: json['iconPath']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'description': description,
      'leadingText': leadingText,
      'iconPath': iconPath,
    };
  }
}
