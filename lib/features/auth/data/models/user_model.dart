class UserModel {
  const UserModel({
    required this.merchantId,
    required this.businessId,
    required this.outletName,
    required this.mobileNo,
    required this.emailId,
    required this.businessProfileStep,
    required this.mapLocation,
    required this.unReadMsg,
    required this.verificationStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        merchantId: json['MerchantId'] is int
            ? json['MerchantId'] as int
            : int.tryParse(json['MerchantId']?.toString() ?? '') ?? 0,
        businessId: json['BusinessId']?.toString() ?? '',
        outletName: json['OutletName']?.toString() ?? '',
        mobileNo: json['MobileNo']?.toString() ?? '',
        emailId: json['EmailId']?.toString() ?? '',
        businessProfileStep: json['BusinessProfileStep'] is int
            ? json['BusinessProfileStep'] as int
            : int.tryParse(json['BusinessProfileStep']?.toString() ?? '') ?? 0,
        mapLocation: json['maplocation']?.toString() ?? '',
        unReadMsg: json['UnReadMsg'] is int
            ? json['UnReadMsg'] as int
            : int.tryParse(json['UnReadMsg']?.toString() ?? '') ?? 0,
        verificationStatus: json['VerificationStatus'] is int
            ? json['VerificationStatus'] as int
            : int.tryParse(json['VerificationStatus']?.toString() ?? '') ?? 0,
      );

  final int merchantId;
  final String businessId;
  final String outletName;
  final String mobileNo;
  final String emailId;
  final int businessProfileStep;
  final String mapLocation;
  final int unReadMsg;
  final int verificationStatus;

  Map<String, dynamic> toJson() => {
        'MerchantId': merchantId,
        'BusinessId': businessId,
        'OutletName': outletName,
        'MobileNo': mobileNo,
        'EmailId': emailId,
        'BusinessProfileStep': businessProfileStep,
        'maplocation': mapLocation,
        'UnReadMsg': unReadMsg,
        'VerificationStatus': verificationStatus,
      };
}
