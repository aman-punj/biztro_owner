class AreaItemModel {
  const AreaItemModel({
    required this.areaId,
    required this.areaName,
    required this.pinCode,
  });

  factory AreaItemModel.fromJson(Map<String, dynamic> json) {
    return AreaItemModel(
      areaId: _parseInt(json['AreaId']),
      areaName: json['AreaName']?.toString() ?? '',
      pinCode: json['PinCode']?.toString() ?? '',
    );
  }

  final int areaId;
  final String areaName;
  final String pinCode;
}

class AreaListModel {
  const AreaListModel({
    required this.success,
    required this.data,
  });

  factory AreaListModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AreaListModel(
      success: _parseBool(json['success']),
      data: rawData is List
          ? rawData
              .whereType<Map>()
              .map(
                (item) => AreaItemModel.fromJson(item.cast<String, dynamic>()),
              )
              .toList()
          : const <AreaItemModel>[],
    );
  }

  final bool success;
  final List<AreaItemModel> data;
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _parseBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  final normalized = value?.toString().toLowerCase();
  return normalized == 'true' || normalized == '1';
}
