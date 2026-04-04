class SaveServiceFacilitiesRequest {
  const SaveServiceFacilitiesRequest({
    required this.merchantId,
    required this.categoryId,
    required this.subcategoryId,
    required this.website,
    required this.famousFor,
    required this.estbYear,
    required this.businessEmail,
    required this.businessWhatsappNo,
    required this.businessLandLineNo,
    required this.servicesOffered,
    required this.facilities,
  });

  final int merchantId;
  final int categoryId;
  final int subcategoryId;
  final String website;
  final String famousFor;
  final String estbYear;
  final String? businessEmail;
  final String? businessWhatsappNo;
  final String? businessLandLineNo;
  final List<int> servicesOffered;
  final List<int> facilities;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'MerchantId': merchantId,
      'CategoryId': categoryId,
      'SubcategoryId': subcategoryId,
      'Website': website,
      'FamousFor': famousFor,
      'EstbYear': estbYear,
      'BusinessEmailId': businessEmail,
      'BusinessWhatsappNo': businessWhatsappNo,
      'BusinessLandLineNo': businessLandLineNo,
      'ServicesOffered': servicesOffered,
      'Facilities': facilities,
    };
  }
}
