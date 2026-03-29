class LocationDetailsItem {
  const LocationDetailsItem({
    required this.stateId,
    required this.stateName,
    required this.cityId,
    required this.cityName,
  });

  factory LocationDetailsItem.fromJson(Map<String, dynamic> json) {
    return LocationDetailsItem(
      stateId: _parseInt(json['StateId']),
      stateName: json['StateName']?.toString() ?? '',
      cityId: _parseInt(json['CityId']),
      cityName: json['CityName']?.toString() ?? '',
    );
  }

  final int stateId;
  final String stateName;
  final int cityId;
  final String cityName;
}

class LocationDetailsModel {
  const LocationDetailsModel({
    required this.success,
    required this.data,
  });

  factory LocationDetailsModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return LocationDetailsModel(
      success: _parseBool(json['success']),
      data: rawData is List
          ? rawData
              .whereType<Map>()
              .map(
                (item) =>
                    LocationDetailsItem.fromJson(item.cast<String, dynamic>()),
              )
              .toList()
          : const <LocationDetailsItem>[],
    );
  }

  final bool success;
  final List<LocationDetailsItem> data;
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
