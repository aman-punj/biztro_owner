class SaveAdRequest {
  final int merchantId;
  final String adPageLocation;
  final String adFormat;
  final String locationType;
  final String categoryType;
  final String? singleState;
  final String? singleCategory;
  final List<String>? multipleStates;
  final List<String>? multipleCategories;
  // Note: AdImage (file) is handled separately in the multipart request

  SaveAdRequest({
    required this.merchantId,
    required this.adPageLocation,
    required this.adFormat,
    required this.locationType,
    required this.categoryType,
    this.singleState,
    this.singleCategory,
    this.multipleStates,
    this.multipleCategories,
  });

  Map<String, String> toJson() {
    return {
      'MerchantId': merchantId.toString(),
      'AdPageLocation': adPageLocation,
      'AdFormat': adFormat,
      'LocationType': locationType,
      'CategoryType': categoryType,
      if (singleState != null) 'SingleState': singleState!,
      if (singleCategory != null) 'SingleCategory': singleCategory!,
      if (multipleStates != null) 'MultipleStates': multipleStates!.join(','),
      if (multipleCategories != null)
        'MultipleCategories': multipleCategories!.join(','),
    };
  }
}
