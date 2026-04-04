class BusinessServiceModel {
  const BusinessServiceModel({
    required this.isSuccessful,
    required this.result,
    required this.message,
  });

  factory BusinessServiceModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['Result'];
    return BusinessServiceModel(
      isSuccessful: _parseBool(json['IsSuccessful']),
      result: rawResult is Map<String, dynamic>
          ? BusinessServiceResult.fromJson(rawResult)
          : rawResult is Map
              ? BusinessServiceResult.fromJson(
                  rawResult.cast<String, dynamic>(),
                )
              : null,
      message: json['Message']?.toString() ?? '',
    );
  }

  final bool isSuccessful;
  final BusinessServiceResult? result;
  final String message;
}

class BusinessServiceResult {
  const BusinessServiceResult({
    required this.merchantId,
    required this.businessName,
    required this.businessEmailId,
    required this.businessWhatsappNo,
    required this.businessLandLineNo,
    required this.website,
    required this.isVerified,
    required this.businessStep,
    required this.famousFor,
    required this.estbYear,
    required this.categoryList,
    required this.subCategoryList,
    required this.serviceOfferedList,
    required this.facilitiesList,
    required this.categoryId,
    required this.subCategoryId,
    required this.encryptSubCategoryId,
    required this.displayName,
  });

  factory BusinessServiceResult.fromJson(Map<String, dynamic> json) {
    return BusinessServiceResult(
      merchantId: _parseInt(json['MerchantId']),
      businessName: json['BusinessName']?.toString() ?? '',
      businessEmailId: _parseNullableString(json['BusinessEmailId']),
      businessWhatsappNo: _parseNullableString(json['BusinessWhatsappNo']),
      businessLandLineNo: _parseNullableString(json['BusinessLandLineNo']),
      website: _parseNullableString(json['Website']),
      isVerified: _parseBool(json['IsVerified']),
      businessStep: _parseInt(json['BusinessStep']),
      famousFor: _parseNullableString(json['FamousFor']),
      estbYear: _parseNullableString(json['EstbYear']),
      categoryList: _parseCategoryList(json['CategoryList']),
      subCategoryList: _parseSubCategoryList(json['SubCategoryList']),
      serviceOfferedList: _parseServiceOfferedList(
        json['ServiceofferedList'] ?? json['ServiceOfferedList'],
      ),
      facilitiesList: _parseFacilitiesList(json['FacilitiesList']),
      categoryId: _parseInt(json['CategoryId']),
      subCategoryId: _parseInt(
        json['SubcategoryId'] ?? json['SubCategoryId'],
      ),
      encryptSubCategoryId: json['EncryptSubCategoryId']?.toString() ?? '',
      displayName: json['DisplayName']?.toString() ?? '',
    );
  }

  final int merchantId;
  final String businessName;
  final String? businessEmailId;
  final String? businessWhatsappNo;
  final String? businessLandLineNo;
  final String? website;
  final bool isVerified;
  final int businessStep;
  final String? famousFor;
  final String? estbYear;
  final List<BusinessCategoryItem> categoryList;
  final List<BusinessSubCategoryItem> subCategoryList;
  final List<ServiceOfferedItem> serviceOfferedList;
  final List<FacilityItem> facilitiesList;
  final int categoryId;
  final int subCategoryId;
  final String encryptSubCategoryId;
  final String displayName;
}

class BusinessCategoryItem {
  const BusinessCategoryItem({
    required this.categoryId,
    required this.categoryName,
  });

  factory BusinessCategoryItem.fromJson(Map<String, dynamic> json) {
    return BusinessCategoryItem(
      categoryId: _parseInt(json['CategoryId']),
      categoryName: json['CategoryName']?.toString() ?? '',
    );
  }

  final int categoryId;
  final String categoryName;
}

class BusinessSubCategoryItem {
  const BusinessSubCategoryItem({
    required this.subCategoryId,
    required this.categoryId,
    required this.subCategoryName,
    required this.isSelected,
  });

  factory BusinessSubCategoryItem.fromJson(Map<String, dynamic> json) {
    return BusinessSubCategoryItem(
      subCategoryId: _parseInt(json['SubCategoryId']),
      categoryId: _parseInt(json['CategoryId']),
      subCategoryName: json['SubCategoryName']?.toString() ?? '',
      isSelected: _parseBool(json['IsSelected']),
    );
  }

  final int subCategoryId;
  final int categoryId;
  final String subCategoryName;
  final bool isSelected;
}

class ServiceOfferedItem {
  const ServiceOfferedItem({
    required this.serviceOfferedId,
    required this.categoryId,
    required this.serviceOfferedName,
    required this.isSelected,
  });

  factory ServiceOfferedItem.fromJson(Map<String, dynamic> json) {
    return ServiceOfferedItem(
      serviceOfferedId: _parseInt(json['ServiceOfferedId']),
      categoryId: _parseInt(json['CategoryId']),
      serviceOfferedName: _parseNullableString(json['ServiceOfferedName']),
      isSelected: _parseBool(json['IsSelected']),
    );
  }

  final int serviceOfferedId;
  final int categoryId;
  final String? serviceOfferedName;
  final bool isSelected;
}

class FacilityItem {
  const FacilityItem({
    required this.facilitiesId,
    required this.categoryId,
    required this.facilitiesName,
    required this.isSelected,
  });

  factory FacilityItem.fromJson(Map<String, dynamic> json) {
    return FacilityItem(
      facilitiesId: _parseInt(json['FacilitiesId']),
      categoryId: _parseInt(json['CategoryId']),
      facilitiesName: _parseNullableString(json['FacilitiesName']),
      isSelected: _parseBool(json['IsSelected']),
    );
  }

  final int facilitiesId;
  final int categoryId;
  final String? facilitiesName;
  final bool isSelected;
}

List<BusinessCategoryItem> _parseCategoryList(dynamic raw) {
  if (raw is! List) {
    return const <BusinessCategoryItem>[];
  }

  return raw
      .whereType<Map>()
      .map(
        (entry) => BusinessCategoryItem.fromJson(entry.cast<String, dynamic>()),
      )
      .toList();
}

List<BusinessSubCategoryItem> _parseSubCategoryList(dynamic raw) {
  if (raw is! List) {
    return const <BusinessSubCategoryItem>[];
  }

  return raw
      .whereType<Map>()
      .map(
        (entry) =>
            BusinessSubCategoryItem.fromJson(entry.cast<String, dynamic>()),
      )
      .toList();
}

List<ServiceOfferedItem> _parseServiceOfferedList(dynamic raw) {
  if (raw is! List) {
    return const <ServiceOfferedItem>[];
  }

  return raw
      .whereType<Map>()
      .map((entry) => ServiceOfferedItem.fromJson(entry.cast<String, dynamic>()))
      .toList();
}

List<FacilityItem> _parseFacilitiesList(dynamic raw) {
  if (raw is! List) {
    return const <FacilityItem>[];
  }

  return raw
      .whereType<Map>()
      .map((entry) => FacilityItem.fromJson(entry.cast<String, dynamic>()))
      .toList();
}

String? _parseNullableString(dynamic value) {
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
