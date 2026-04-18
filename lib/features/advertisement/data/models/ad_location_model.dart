class AdLocationModel {
  final int id;
  final String name;
  final String value;
  final String subtitle;
  final String iconPath;

  AdLocationModel({
    required this.id,
    required this.name,
    required this.value,
    this.subtitle = '',
    this.iconPath = '',
  });

  factory AdLocationModel.fromJson(Map<String, dynamic> json) {
    return AdLocationModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      iconPath: json['iconPath']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'subtitle': subtitle,
      'iconPath': iconPath,
    };
  }
}
