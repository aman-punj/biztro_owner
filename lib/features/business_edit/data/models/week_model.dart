class WeekModel {
  const WeekModel({
    required this.id,
    required this.name,
  });

  factory WeekModel.fromJson(Map<String, dynamic> json) {
    return WeekModel(
      id: _readInt(json['WeekId']),
      name: _readString(json['WeekName']),
    );
  }

  final int id;
  final String name;

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _readString(dynamic value) {
    return value?.toString().trim() ?? '';
  }
}
