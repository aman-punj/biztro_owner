class ServiceFacilityListModel {
  const ServiceFacilityListModel({
    required this.servicesOffered,
    required this.facilities,
  });

  factory ServiceFacilityListModel.fromJson(Map<String, dynamic> json) {
    return ServiceFacilityListModel(
      servicesOffered: _parseItems(
        json['ServiceofferedList'] ?? json['ServiceOfferedList'],
      ),
      facilities: _parseItems(json['FacilitiesList']),
    );
  }

  final List<ServiceFacilityItemModel> servicesOffered;
  final List<ServiceFacilityItemModel> facilities;
}

class ServiceFacilityItemModel {
  const ServiceFacilityItemModel({
    required this.id,
    required this.name,
    required this.isSelected,
  });

  factory ServiceFacilityItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceFacilityItemModel(
      id: _parseInt(
        json['ServiceOfferedId'] ??
            json['FacilitiesId'] ??
            json['Id'] ??
            json['id'] ??
            json['ServiceId'] ??
            json['FacilityId'] ??
            json['KeywordId'],
      ),
      name: json['ServiceOfferedName']?.toString() ??
          json['FacilitiesName']?.toString() ??
          json['Name']?.toString() ??
          json['name']?.toString() ??
          json['ServiceName']?.toString() ??
          json['FacilityName']?.toString() ??
          json['DisplayName']?.toString() ??
          '',
      isSelected: _parseBool(json['IsSelected'] ?? json['isSelected']),
    );
  }

  final int id;
  final String name;
  final bool isSelected;
}

List<ServiceFacilityItemModel> _parseItems(dynamic raw) {
  if (raw is! List) {
    return const <ServiceFacilityItemModel>[];
  }

  return raw
      .whereType<Map>()
      .map(
        (entry) => ServiceFacilityItemModel.fromJson(
          entry.cast<String, dynamic>(),
        ),
      )
      .where((item) => item.id != 0 || item.name.isNotEmpty)
      .toList();
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
