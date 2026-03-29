class ContactInfoResult {
  const ContactInfoResult({
    required this.fullName,
    required this.landlineNo,
    required this.mobile,
    required this.otherMobileNo,
    required this.emailId,
    required this.otherEmailId,
    required this.whatsappNo,
    required this.website,
    required this.businessLandLineNo,
    required this.businessWhatsappNo,
    required this.businessEmailId,
    required this.address,
    required this.streetNo,
    required this.landmark,
    required this.stateName,
    required this.cityName,
    required this.pincode,
    required this.stateId,
    required this.cityId,
    required this.areaId,
    required this.areaName,
    required this.otherAreaName,
    required this.merchantId,
    required this.businessId,
    required this.businessStep,
    required this.isVerified,
  });

  factory ContactInfoResult.fromJson(Map<String, dynamic> json) {
    return ContactInfoResult(
      fullName: json['FullName']?.toString() ?? '',
      landlineNo: _nullableString(json['LandlineNo']),
      mobile: json['Mobile']?.toString() ?? '',
      otherMobileNo: _nullableString(json['OtherMobileNo']),
      emailId: json['EmailId']?.toString() ?? '',
      otherEmailId: _nullableString(json['OtherEmailId']),
      whatsappNo: _nullableString(json['WhatsappNo']),
      website: _nullableString(json['Website']),
      businessLandLineNo: _nullableString(json['BusinessLandLineNo']),
      businessWhatsappNo: _nullableString(json['BusinessWhatsappNo']),
      businessEmailId: _nullableString(json['BusinessEmailId']),
      address: _nullableString(json['Address']),
      streetNo: _nullableString(json['StreetNo']),
      landmark: _nullableString(json['Landmark']),
      stateName: _nullableString(json['StateName']),
      cityName: _nullableString(json['CityName']),
      pincode: _nullableString(json['Pincode']),
      stateId: _parseInt(json['StateId']),
      cityId: _parseInt(json['CityId']),
      areaId: _parseInt(json['AreaId']),
      areaName: _nullableString(json['AreaName']),
      otherAreaName: _nullableString(json['OtherAreaName']),
      merchantId: _parseInt(json['MerchantId']),
      businessId: _nullableString(json['BusinessId']),
      businessStep: _parseInt(json['BusinessStep']),
      isVerified: _parseBool(json['IsVerified']),
    );
  }

  final String fullName;
  final String? landlineNo;
  final String mobile;
  final String? otherMobileNo;
  final String emailId;
  final String? otherEmailId;
  final String? whatsappNo;
  final String? website;
  final String? businessLandLineNo;
  final String? businessWhatsappNo;
  final String? businessEmailId;
  final String? address;
  final String? streetNo;
  final String? landmark;
  final String? stateName;
  final String? cityName;
  final String? pincode;
  final int stateId;
  final int cityId;
  final int areaId;
  final String? areaName;
  final String? otherAreaName;
  final int merchantId;
  final String? businessId;
  final int businessStep;
  final bool isVerified;
}

class ContactInfoModel {
  const ContactInfoModel({
    required this.isSuccessful,
    required this.result,
    required this.message,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['Result'];
    return ContactInfoModel(
      isSuccessful: _parseBool(json['IsSuccessful']),
      result: rawResult is Map<String, dynamic>
          ? ContactInfoResult.fromJson(rawResult)
          : rawResult is Map
              ? ContactInfoResult.fromJson(rawResult.cast<String, dynamic>())
              : null,
      message: json['Message']?.toString() ?? '',
    );
  }

  final bool isSuccessful;
  final ContactInfoResult? result;
  final String message;
}

String? _nullableString(dynamic value) {
  final parsed = value?.toString();
  if (parsed == null || parsed.isEmpty || parsed == 'null') {
    return null;
  }
  return parsed;
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
