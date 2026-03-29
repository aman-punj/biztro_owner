class SaveContactRequest {
  const SaveContactRequest({
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
    this.businessStep = 2,
    this.isVerified = false,
  });

  final String fullName;
  final String landlineNo;
  final String mobile;
  final String otherMobileNo;
  final String emailId;
  final String otherEmailId;
  final String whatsappNo;
  final String website;
  final String businessLandLineNo;
  final String businessWhatsappNo;
  final String businessEmailId;
  final String address;
  final String streetNo;
  final String landmark;
  final String stateName;
  final String cityName;
  final String pincode;
  final int stateId;
  final int cityId;
  final int areaId;
  final String areaName;
  final String otherAreaName;
  final int merchantId;
  final String businessId;
  final int businessStep;
  final bool isVerified;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'FullName': fullName,
      'LandlineNo': landlineNo,
      'Mobile': mobile,
      'OtherMobileNo': otherMobileNo,
      'EmailId': emailId,
      'OtherEmailId': otherEmailId,
      'WhatsappNo': whatsappNo,
      'Website': website,
      'BusinessLandLineNo': businessLandLineNo,
      'BusinessWhatsappNo': businessWhatsappNo,
      'BusinessEmailId': businessEmailId,
      'Address': address,
      'StreetNo': streetNo,
      'Landmark': landmark,
      'StateName': stateName,
      'CityName': cityName,
      'Pincode': pincode,
      'StateId': stateId,
      'CityId': cityId,
      'AreaId': areaId,
      'AreaName': areaName,
      'OtherAreaName': otherAreaName,
      'MerchantId': merchantId,
      'BusinessId': businessId,
      'BusinessStep': businessStep,
      'IsVerified': isVerified,
    };
  }
}
