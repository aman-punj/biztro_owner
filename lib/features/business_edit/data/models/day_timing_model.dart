class DayTimingModel {
  const DayTimingModel({
    required this.weekId,
    this.fromTimeId,
    this.toTimeId,
    this.isClosed = false,
  });

  factory DayTimingModel.fromJson(Map<String, dynamic> json) {
    return DayTimingModel(
      weekId: _readInt(json['WeekDaysId']),
      fromTimeId: _readNullableInt(json['FromTimeId']),
      toTimeId: _readNullableInt(json['ToTimeId']),
      isClosed: _readBool(json['IsClosed']),
    );
  }

  final int weekId;
  final int? fromTimeId;
  final int? toTimeId;
  final bool isClosed;

  DayTimingModel copyWith({
    int? weekId,
    int? fromTimeId,
    int? toTimeId,
    bool? isClosed,
    bool clearFromTime = false,
    bool clearToTime = false,
  }) {
    return DayTimingModel(
      weekId: weekId ?? this.weekId,
      fromTimeId: clearFromTime ? null : (fromTimeId ?? this.fromTimeId),
      toTimeId: clearToTime ? null : (toTimeId ?? this.toTimeId),
      isClosed: isClosed ?? this.isClosed,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'WeekDaysId': weekId,
      'FromTimeId': fromTimeId,
      'ToTimeId': toTimeId,
      'IsClosed': isClosed,
    };
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _readNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }
    return _readInt(value);
  }

  static bool _readBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }

    final normalized = value?.toString().trim().toLowerCase() ?? '';
    return normalized == 'true' || normalized == '1';
  }
}
