class TrustedShieldKycModel {
  const TrustedShieldKycModel({
    required this.merchantId,
    required this.bizId,
    required this.id,
    required this.firmName,
    required this.gstNumber,
    required this.panNumber,
    required this.aadhaarNumber,
    required this.gstImagePath,
    required this.panImagePath,
    required this.aadharFrontImagePath,
    required this.aadhaarBackImagePath,
    required this.liveImagePath,
    required this.kycStatus,
    required this.adminRemarks,
  });

  factory TrustedShieldKycModel.fromJson(Map<String, dynamic> json) {
    return TrustedShieldKycModel(
      merchantId: json['MerchantId']?.toString() ?? '',
      bizId: json['BizId']?.toString() ?? '',
      id: _parseInt(json['Id']),
      firmName: json['FirmName']?.toString() ?? '',
      gstNumber: json['GstNumber']?.toString() ?? '',
      panNumber: json['PanNumber']?.toString() ?? '',
      aadhaarNumber: json['AadhaarNumber']?.toString() ?? '',
      gstImagePath: json['GstImagePath']?.toString() ?? '',
      panImagePath: json['PanImagePath']?.toString() ?? '',
      aadharFrontImagePath: json['AadharFrontImagePath']?.toString() ?? '',
      aadhaarBackImagePath: json['AadhaarBackImagePath']?.toString() ?? '',
      liveImagePath: json['LiveImagePath']?.toString() ?? '',
      kycStatus: _parseInt(json['KycStatus']),
      adminRemarks: json['AdminRemarks']?.toString() ?? '',
    );
  }

  final String merchantId;
  final String bizId;
  final int id;
  final String firmName;
  final String gstNumber;
  final String panNumber;
  final String aadhaarNumber;
  final String gstImagePath;
  final String panImagePath;
  final String aadharFrontImagePath;
  final String aadhaarBackImagePath;
  final String liveImagePath;
  final int kycStatus;
  final String adminRemarks;

  bool get hasExistingData =>
      firmName.isNotEmpty ||
      gstNumber.isNotEmpty ||
      panNumber.isNotEmpty ||
      aadhaarNumber.isNotEmpty ||
      gstImagePath.isNotEmpty ||
      panImagePath.isNotEmpty ||
      aadharFrontImagePath.isNotEmpty ||
      aadhaarBackImagePath.isNotEmpty ||
      liveImagePath.isNotEmpty;

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
