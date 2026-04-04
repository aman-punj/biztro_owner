class BusinessDetailsResult {
  const BusinessDetailsResult({
    required this.merchantId,
    required this.categoryId,
    required this.businessName,
    required this.displayName,
    required this.encryptSubCategoryId,
    required this.businessStep,
    required this.subcategoryId,
  });

  factory BusinessDetailsResult.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsResult(
      merchantId: _asInt(json['MerchantId']),
      categoryId: _asInt(json['CategoryId']),
      businessName: json['BusinessName']?.toString() ?? '',
      displayName: json['DisplayName']?.toString() ?? '',
      encryptSubCategoryId: json['EncryptSubCategoryId']?.toString() ?? '',
      businessStep: _asInt(json['BusinessStep']),
      subcategoryId: _asInt(json['SubcategoryId']),
    );
  }

  final int merchantId;
  final int categoryId;
  final String businessName;
  final String displayName;
  final String encryptSubCategoryId;
  final int businessStep;
  final int subcategoryId;

  static int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class BusinessDetailsModel {
  const BusinessDetailsModel({
    required this.isSuccessful,
    required this.result,
    required this.message,
  });

  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['Result'];
    return BusinessDetailsModel(
      isSuccessful: json['IsSuccessful'] == true,
      result: rawResult is Map<String, dynamic>
          ? BusinessDetailsResult.fromJson(rawResult)
          : rawResult is Map
              ? BusinessDetailsResult.fromJson(rawResult.cast<String, dynamic>())
              : null,
      message: json['Message']?.toString() ?? '',
    );
  }

  final bool isSuccessful;
  final BusinessDetailsResult? result;
  final String message;
}
