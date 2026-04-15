class AdLocationModel {
  final int id;
  final String name;
  final String value;

  AdLocationModel({
    required this.id,
    required this.name,
    required this.value,
  });

  factory AdLocationModel.fromJson(Map<String, dynamic> json) {
    return AdLocationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
    };
  }
}
