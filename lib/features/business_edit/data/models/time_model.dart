class TimeModel {
  const TimeModel({
    required this.id,
    required this.value,
  });

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    return TimeModel(
      id: _readInt(json['TimeTableId']),
      value: _readString(json['TimeValue']),
    );
  }

  final int id;
  final String value;

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
