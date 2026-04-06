import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/core/notifications/notification_service.dart';
import 'package:bizrato_owner/core/notifications/notification_service_extension.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/utils/debouncer.dart';
import 'package:bizrato_owner/features/auth/services/logout_service.dart';
import 'package:bizrato_owner/features/onboarding/data/models/area_item_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/business_details_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/business_service_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/keyword_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/location_details_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/save_contact_request.dart';
import 'package:bizrato_owner/features/onboarding/data/models/save_keywords_request.dart';
import 'package:bizrato_owner/features/onboarding/data/models/save_service_facilities_request.dart';
import 'package:bizrato_owner/features/onboarding/data/models/saved_keywords_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/search_result_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/service_facility_item_model.dart';
import 'package:bizrato_owner/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  OnboardingController({required this.onboardingRepository});

  final OnboardingRepository onboardingRepository;
  final AuthStorage _authStorage = Get.find<AuthStorage>();

  final RxInt _stageIndex = 0.obs;

  int get stageIndex => _stageIndex.value;

  static const List<String> stageTitles = <String>[
    'Basic Info',
    'Keywords',
    'Finalize',
  ];

  final RxString businessName = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxList<SearchResultModel> searchResults = <SearchResultModel>[].obs;
  final RxBool isSearching = false.obs;
  final Rxn<SearchResultModel> selectedCategory = Rxn<SearchResultModel>();
  final RxList<KeywordModel> qualityKeywords = <KeywordModel>[].obs;
  final RxList<KeywordModel> serviceKeywords = <KeywordModel>[].obs;
  final RxSet<int> selectedKeywordIds = <int>{}.obs;
  final RxList<String> customKeywords = <String>[].obs;
  final RxBool isLoadingKeywords = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isSavingServiceData = false.obs;
  final RxBool isRestoringKeywords = false.obs;
  final RxBool isCategoryRestored = false.obs;

  final Rxn<BusinessServiceResult> businessServiceData =
      Rxn<BusinessServiceResult>();
  final RxBool isLoadingServiceData = false.obs;
  final RxList<ServiceFacilityItemModel> servicesOfferedList =
      <ServiceFacilityItemModel>[].obs;
  final RxList<ServiceFacilityItemModel> facilitiesList =
      <ServiceFacilityItemModel>[].obs;
  final RxBool isLoadingFacilities = false.obs;
  final RxSet<int> selectedServiceIds = <int>{}.obs;
  final RxSet<int> selectedFacilityIds = <int>{}.obs;
  final RxString page2BusinessName = ''.obs;
  final RxString page2Website = ''.obs;
  final RxString page2FamousFor = ''.obs;
  final RxString page2EstbYear = ''.obs;
  final RxString page2BusinessEmail = ''.obs;
  final RxString page2BusinessWhatsApp = ''.obs;
  final RxString page2BusinessLandline = ''.obs;

  final RxBool isLoadingContactInfo = false.obs;
  final RxBool isSavingContact = false.obs;
  final RxBool isLoadingAreas = false.obs;
  final RxBool isLoadingLocationDetails = false.obs;

  final RxString p3FullName = ''.obs;
  final RxString p3Email = ''.obs;
  final RxString p3Mobile = ''.obs;
  final RxString p3OtherMobile = ''.obs;
  final RxString p3WhatsApp = ''.obs;
  final RxString p3Landline = ''.obs;
  final RxString p3OtherEmail = ''.obs;
  final RxString p3Website = ''.obs;

  final RxString p3BusinessEmail = ''.obs;
  final RxString p3BusinessWhatsApp = ''.obs;
  final RxString p3BusinessLandline = ''.obs;

  final RxString p3Address = ''.obs;
  final RxString p3StreetNo = ''.obs;
  final RxString p3Landmark = ''.obs;
  final RxString p3Pincode = ''.obs;
  final RxString p3StateName = ''.obs;
  final RxString p3CityName = ''.obs;
  final RxInt p3StateId = 0.obs;
  final RxInt p3CityId = 0.obs;
  final RxString p3OtherAreaName = ''.obs;

  final RxList<AreaItemModel> p3AreaList = <AreaItemModel>[].obs;
  final Rxn<AreaItemModel> p3SelectedArea = Rxn<AreaItemModel>();
  final RxString p3BusinessId = ''.obs;

  final Debouncer _debouncer = Debouncer();
  String? _lastLoadedCategoryId;
  int? _merchantIdOverride;

  bool get hasSelectedCategory => selectedCategory.value != null;
  bool get canAddMoreKeywords => customKeywords.length < 5;

  @override
  void onInit() {
    super.onInit();
    _stageIndex.value = _normalizedStage(_authStorage.profileStep);
  }

  @override
  void onClose() {
    _debouncer.cancel();
    super.onClose();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    final sanitized = value.trim();
    if (sanitized.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      return;
    }

    _debouncer(() => _performSearch(sanitized));
  }

  Future<void> _performSearch(String term) async {
    isSearching.value = true;
    final AppResponse<List<SearchResultModel>> response =
        await onboardingRepository.searchCategory(term);
    isSearching.value = false;

    if (!response.success) {
      Get.snackbar('Search failed', response.message);
      return;
    }

    searchResults.assignAll(response.data ?? const <SearchResultModel>[]);
  }

  void onCategorySelected(SearchResultModel result) {
    selectedCategory.value = result;
    searchQuery.value = result.displayName;
    searchResults.clear();
    selectedKeywordIds.clear();
    _debouncer.cancel();

    if (_lastLoadedCategoryId == result.keywordId &&
        (qualityKeywords.isNotEmpty || serviceKeywords.isNotEmpty)) {
      return;
    }

    _loadKeywords(result.keywordId);
  }

  Future<void> _loadKeywords(String categoryId) async {
    isLoadingKeywords.value = true;
    final AppResponse<List<KeywordModel>> response =
        await onboardingRepository.getKeywords(categoryId);
    isLoadingKeywords.value = false;

    if (!response.success) {
      Get.snackbar('Unable to load keywords', response.message);
      return;
    }

    final keywords = response.data ?? const <KeywordModel>[];
    qualityKeywords.assignAll(
      keywords.where((keyword) => keyword.keywordTypeId == 1).toList(),
    );
    serviceKeywords.assignAll(
      keywords.where((keyword) => keyword.keywordTypeId == 2).toList(),
    );

    _lastLoadedCategoryId = categoryId;
  }

  void toggleKeyword(int keywordId) {
    if (selectedKeywordIds.contains(keywordId)) {
      selectedKeywordIds.remove(keywordId);
    } else {
      selectedKeywordIds.add(keywordId);
    }
  }

  void addCustomKeyword(String value) {
    if (!canAddMoreKeywords) {
      return;
    }

    final trimmed = value.trim();
    if (trimmed.isEmpty || customKeywords.contains(trimmed)) {
      return;
    }

    customKeywords.add(trimmed);
  }

  void removeCustomKeyword(String value) {
    customKeywords.remove(value);
  }

  void clearRestoredCategory() {
    selectedCategory.value = null;
    searchQuery.value = '';
    searchResults.clear();
    qualityKeywords.clear();
    serviceKeywords.clear();
    selectedKeywordIds.clear();
    customKeywords.clear();
    isCategoryRestored.value = false;
    _lastLoadedCategoryId = null;
  }

  Future<void> saveAndContinue() async {
    if (selectedCategory.value == null) {
      Get.snackbar(
        'Category required',
        'Please select a category to continue.',
      );
      return;
    }

    final List<SelectedKeyword> keywordPayload = _selectedKeywordPayload();
    if (keywordPayload.isEmpty && customKeywords.isEmpty) {
      Get.snackbar(
        'Add keywords',
        'Select at least one suggested keyword or add your own before continuing.',
      );
      return;
    }

    final merchantId = _resolvedMerchantId;
    if (merchantId == null) {
      _notifyError('Merchant id unavailable. Please login again.');
      return;
    }

    final request = SaveKeywordsRequest(
      businessName: businessName.value,
      categoryId: selectedCategory.value!.keywordId,
      keywords: keywordPayload,
      otherKeywords: List<String>.from(customKeywords),
      merchantId: merchantId,
    );

    isSaving.value = true;
    final AppResponse<void> response =
        await onboardingRepository.saveKeywords(request);
    isSaving.value = false;

    if (!response.success) {
      Get.snackbar('Unable to save keywords', response.message);
      return;
    }

    nextStage();
  }

  void initPageData(String? name) {
    if (name != null && name.isNotEmpty) {
      businessName.value = name;
    }

    if (selectedCategory.value != null &&
        qualityKeywords.isEmpty &&
        serviceKeywords.isEmpty) {
      _loadKeywords(selectedCategory.value!.keywordId);
    }

    restoreSavedKeywordsIfNeeded();
  }

  Future<void> initPage2Data() async {
    // Always fetch fresh - handles both direct landing and back navigation
    await loadBusinessServiceData();
  }

  void setMerchantId(String id) {
    _merchantIdOverride = int.tryParse(id);
  }

  Future<void> loadBusinessServiceData() async {
    final merchantId = _resolvedMerchantId;
    if (merchantId == null) {
      _notifyError('Merchant id unavailable. Please login again.');
      return;
    }

    isLoadingServiceData.value = true;
    try {
      final response =
          await onboardingRepository.getBusinessServiceData(merchantId);
      if (!response.success) {
        businessServiceData.value = null;
        _notifyError(response.message);
        return;
      }

      final data = response.data?.result;
      if (data == null) {
        businessServiceData.value = null;
        _notifyError('Business service data is unavailable.');
        return;
      }

      businessServiceData.value = data;
      page2BusinessName.value = data.businessName;
      page2Website.value = data.website ?? '';
      page2FamousFor.value = data.famousFor ?? '';
      page2EstbYear.value = data.estbYear ?? '';
      page2BusinessEmail.value = data.businessEmailId ?? '';
      page2BusinessWhatsApp.value = data.businessWhatsappNo ?? '';
      page2BusinessLandline.value = data.businessLandLineNo ?? '';

      final categoryLookupId = data.encryptSubCategoryId.isNotEmpty
          ? data.encryptSubCategoryId
          : (data.subCategoryId > 0
              ? data.subCategoryId.toString()
              : data.categoryId.toString());
      if (categoryLookupId.isNotEmpty && categoryLookupId != '0') {
        await loadServiceFacilitiesList(categoryLookupId);
      } else {
        servicesOfferedList.clear();
        facilitiesList.clear();
        selectedServiceIds.clear();
        selectedFacilityIds.clear();
      }
    } finally {
      isLoadingServiceData.value = false;
    }
  }

  Future<void> loadServiceFacilitiesList(String categoryId) async {
    isLoadingFacilities.value = true;
    try {
      final response =
          await onboardingRepository.getServiceFacilitiesList(categoryId);
      if (!response.success) {
        servicesOfferedList.clear();
        facilitiesList.clear();
        selectedServiceIds.clear();
        selectedFacilityIds.clear();
        _notifyError(response.message);
        return;
      }

      final items = response.data ??
          const ServiceFacilityListModel(
            servicesOffered: <ServiceFacilityItemModel>[],
            facilities: <ServiceFacilityItemModel>[],
          );
      servicesOfferedList.assignAll(items.servicesOffered);
      facilitiesList.assignAll(items.facilities);
      selectedServiceIds
        ..clear()
        ..addAll(
          items.servicesOffered
              .where((item) => item.isSelected)
              .map((item) => item.id),
        );
      selectedFacilityIds
        ..clear()
        ..addAll(
          items.facilities
              .where((item) => item.isSelected)
              .map((item) => item.id),
        );

      final savedData = businessServiceData.value;
      if (savedData != null) {
        final savedServiceIds = savedData.serviceOfferedList
            .where((service) => service.isSelected)
            .map((service) => service.serviceOfferedId)
            .toSet();

        final savedFacilityIds = savedData.facilitiesList
            .where((facility) => facility.isSelected)
            .map((facility) => facility.facilitiesId)
            .toSet();

        selectedServiceIds
          ..clear()
          ..addAll(
            servicesOfferedList
                .where((item) => savedServiceIds.contains(item.id))
                .map((item) => item.id),
          );

        selectedFacilityIds
          ..clear()
          ..addAll(
            facilitiesList
                .where((item) => savedFacilityIds.contains(item.id))
                .map((item) => item.id),
          );
      }
    } finally {
      isLoadingFacilities.value = false;
    }
  }

  Future<void> savePage2AndContinue() async {
    final data = businessServiceData.value;
    if (data == null) {
      _notifyError('Business service data is unavailable.');
      return;
    }

    final merchantId = _resolvedMerchantId;
    if (merchantId == null) {
      _notifyError('Merchant id unavailable. Please login again.');
      return;
    }

    if (data.categoryId <= 0 || data.subCategoryId <= 0) {
      _notifyError('Category details are unavailable.');
      return;
    }

    final request = SaveServiceFacilitiesRequest(
      merchantId: merchantId,
      categoryId: data.categoryId,
      subcategoryId: data.subCategoryId,
      website: page2Website.value.trim(),
      famousFor: page2FamousFor.value.trim(),
      estbYear: page2EstbYear.value.trim(),
      businessEmail: page2BusinessEmail.value.trim().isEmpty
          ? null
          : page2BusinessEmail.value.trim(),
      businessWhatsappNo: page2BusinessWhatsApp.value.trim().isEmpty
          ? null
          : page2BusinessWhatsApp.value.trim(),
      businessLandLineNo: page2BusinessLandline.value.trim().isEmpty
          ? null
          : page2BusinessLandline.value.trim(),
      servicesOffered: selectedServiceIds.toList()..sort(),
      facilities: selectedFacilityIds.toList()..sort(),
    );

    isSavingServiceData.value = true;
    try {
      final response =
          await onboardingRepository.saveServiceFacilities(request);
      if (!response.success) {
        _notifyError(response.message);
        return;
      }

      nextStage();
    } finally {
      isSavingServiceData.value = false;
    }
  }

  Future<void> restoreSavedKeywordsIfNeeded() async {
    if (selectedKeywordIds.isNotEmpty) {
      return;
    }

    final merchantId = _resolvedMerchantId;
    if (merchantId == null || merchantId == 0) {
      return;
    }

    if (isRestoringKeywords.value) {
      return;
    }

    isRestoringKeywords.value = true;
    try {
      await _restoreKeywordContextIfNeeded(merchantId);

      final AppResponse<SavedKeywordsModel> response =
          await onboardingRepository.getSavedKeywords(merchantId);
      if (!response.success) {
        print(
          '[OnboardingController] Could not restore keywords: ${response.message}',
        );
        return;
      }

      final savedKeywords = response.data;
      if (savedKeywords == null) {
        print(
          '[OnboardingController] Could not restore keywords: Saved keywords are unavailable.',
        );
        return;
      }

      final ids = savedKeywords.keywords
          .map((keyword) => keyword.keywordId)
          .where((id) => id > 0)
          .toSet();
      selectedKeywordIds.addAll(ids);

      for (final keyword in savedKeywords.otherKeywords) {
        if (customKeywords.length >= 5) {
          break;
        }
        if (!customKeywords.contains(keyword)) {
          customKeywords.add(keyword);
        }
      }

      print(
        '[OnboardingController] Restored ${ids.length} saved keywords',
      );
    } finally {
      isRestoringKeywords.value = false;
    }
  }

  Future<void> _restoreKeywordContextIfNeeded(int merchantId) async {
    // Already have keywords loaded - nothing to do.
    if (qualityKeywords.isNotEmpty || serviceKeywords.isNotEmpty) {
      return;
    }

    final AppResponse<BusinessDetailsModel> detailsResponse =
        await onboardingRepository.getBusinessDetails(merchantId);
    if (!detailsResponse.success || detailsResponse.data?.result == null) {
      print(
        '[OnboardingController] Could not restore category context: ${detailsResponse.message}',
      );
      return;
    }

    final BusinessDetailsResult details = detailsResponse.data!.result!;
    final String categoryId = details.encryptSubCategoryId.trim();
    final String displayName = details.displayName.trim();
    if (categoryId.isEmpty || displayName.isEmpty) {
      print(
        '[OnboardingController] Could not restore category context: Missing business details fields',
      );
      return;
    }

    if (businessName.value.isEmpty && details.businessName.isNotEmpty) {
      businessName.value = details.businessName;
    }

    selectedCategory.value = SearchResultModel(
      keywordId: categoryId,
      displayName: displayName,
    );
    searchQuery.value = displayName;
    searchResults.clear();
    isCategoryRestored.value = true;

    final AppResponse<List<KeywordModel>> keywordResponse =
        await onboardingRepository.getKeywords(categoryId);
    if (!keywordResponse.success) {
      print(
        '[OnboardingController] Could not restore category context: ${keywordResponse.message}',
      );
      return;
    }

    final keywords = keywordResponse.data ?? const <KeywordModel>[];
    qualityKeywords.assignAll(
      keywords.where((keyword) => keyword.keywordTypeId == 1).toList(),
    );
    serviceKeywords.assignAll(
      keywords.where((keyword) => keyword.keywordTypeId == 2).toList(),
    );
    _lastLoadedCategoryId = categoryId;
  }

  Future<void> loadContactInfo() async {
    final merchantId = _resolvedMerchantId;
    if (merchantId == null) {
      _notifyError('Merchant id unavailable. Please login again.');
      return;
    }

    isLoadingContactInfo.value = true;
    try {
      final response = await onboardingRepository.getContactInfo(merchantId);
      if (!response.success) {
        _notifyError(response.message);
        return;
      }

      final result = response.data?.result;
      if (result == null) {
        return;
      }

      p3FullName.value = result.fullName;
      p3Landline.value = result.landlineNo ?? '';
      p3Mobile.value = result.mobile;
      p3OtherMobile.value = result.otherMobileNo ?? '';
      p3Email.value = result.emailId;
      p3OtherEmail.value = result.otherEmailId ?? '';
      p3WhatsApp.value = result.whatsappNo ?? '';
      p3Website.value = result.website ?? '';
      p3BusinessLandline.value = result.businessLandLineNo ?? '';
      p3BusinessWhatsApp.value = result.businessWhatsappNo ?? '';
      p3BusinessEmail.value = result.businessEmailId ?? '';
      p3Address.value = result.address ?? '';
      p3StreetNo.value = result.streetNo ?? '';
      p3Landmark.value = result.landmark ?? '';
      p3Pincode.value = result.pincode ?? '';
      p3StateName.value = result.stateName ?? '';
      p3CityName.value = result.cityName ?? '';
      p3StateId.value = result.stateId;
      p3CityId.value = result.cityId;
      p3OtherAreaName.value = result.otherAreaName ?? '';
      p3BusinessId.value = result.businessId ?? '';

      if (result.pincode != null && result.pincode!.isNotEmpty) {
        await _loadLocationByPincode(result.pincode!);
        await _loadAreasByPincode(result.pincode!);

        AreaItemModel? matchedArea;
        if (result.areaId > 0) {
          for (final area in p3AreaList) {
            if (area.areaId == result.areaId) {
              matchedArea = area;
              break;
            }
          }
        }
        if (matchedArea == null && (result.areaName?.isNotEmpty ?? false)) {
          for (final area in p3AreaList) {
            if (area.areaName.toLowerCase() == result.areaName!.toLowerCase()) {
              matchedArea = area;
              break;
            }
          }
        }
        if (matchedArea != null) {
          p3SelectedArea.value = matchedArea;
        }
      }
    } finally {
      isLoadingContactInfo.value = false;
    }
  }

  Future<void> onPincodeChanged(String pincode) async {
    p3Pincode.value = pincode;

    if (pincode.length < 6) {
      p3StateName.value = '';
      p3CityName.value = '';
      p3StateId.value = 0;
      p3CityId.value = 0;
      p3AreaList.clear();
      p3SelectedArea.value = null;
      return;
    }

    if (pincode.length == 6) {
      _debouncer(
        () async {
          await _loadLocationByPincode(pincode);
          await _loadAreasByPincode(pincode);
        },
        duration: const Duration(milliseconds: 600),
      );
    }
  }

  Future<void> _loadLocationByPincode(String pincode) async {
    isLoadingLocationDetails.value = true;
    try {
      final response = await onboardingRepository.getLocationByPincode(pincode);
      if (!response.success) {
        // Silent - user can still type manually
        return;
      }

      final locations = response.data?.data ?? const <LocationDetailsItem>[];
      if (locations.isNotEmpty) {
        final location = locations.first;
        p3StateName.value = location.stateName;
        p3CityName.value = location.cityName;
        p3StateId.value = location.stateId;
        p3CityId.value = location.cityId;
      }
    } finally {
      isLoadingLocationDetails.value = false;
    }
  }

  Future<void> _loadAreasByPincode(String pincode) async {
    isLoadingAreas.value = true;
    try {
      final response = await onboardingRepository.getAreasByPincode(pincode);
      if (!response.success) {
        p3AreaList.clear();
        p3SelectedArea.value = null;
        return;
      }

      final areas = response.data?.data ?? const <AreaItemModel>[];
      p3AreaList.assignAll(areas);

      final selectedArea = p3SelectedArea.value;
      if (selectedArea != null &&
          !areas.any((area) => area.areaId == selectedArea.areaId)) {
        p3SelectedArea.value = null;
      }
    } finally {
      isLoadingAreas.value = false;
    }
  }

  void selectArea(AreaItemModel area) {
    p3SelectedArea.value = area;
  }

  Future<void> saveContactAndFinish() async {
    final merchantId = _resolvedMerchantId;
    if (merchantId == null) {
      _notifyError('Merchant id unavailable. Please login again.');
      return;
    }

    if (p3FullName.value.trim().isEmpty) {
      _notifyError('Full name is required.');
      return;
    }

    final hasPincode = p3Pincode.value.trim().isNotEmpty;
    if (hasPincode && p3SelectedArea.value == null) {
      _notifyError('Please select an area.');
      return;
    }

    final request = SaveContactRequest(
      fullName: p3FullName.value.trim(),
      landlineNo: p3Landline.value.trim(),
      mobile: p3Mobile.value.trim(),
      otherMobileNo: p3OtherMobile.value.trim(),
      emailId: p3Email.value.trim(),
      otherEmailId: p3OtherEmail.value.trim(),
      whatsappNo: p3WhatsApp.value.trim(),
      website: p3Website.value.trim(),
      businessLandLineNo: p3BusinessLandline.value.trim(),
      businessWhatsappNo: p3BusinessWhatsApp.value.trim(),
      businessEmailId: p3BusinessEmail.value.trim(),
      address: p3Address.value.trim(),
      streetNo: p3StreetNo.value.trim(),
      landmark: p3Landmark.value.trim(),
      stateName: p3StateName.value.trim(),
      cityName: p3CityName.value.trim(),
      pincode: p3Pincode.value.trim(),
      stateId: p3StateId.value,
      cityId: p3CityId.value,
      areaId: p3SelectedArea.value?.areaId ?? 0,
      areaName: p3SelectedArea.value?.areaName ?? '',
      otherAreaName: p3OtherAreaName.value.trim(),
      merchantId: merchantId,
      businessId: p3BusinessId.value.trim(),
      businessStep: 2,
      isVerified: false,
    );

    isSavingContact.value = true;
    try {
      final response = await onboardingRepository.saveContactDetails(request);
      if (!response.success) {
        _notifyError(response.message);
        return;
      }

      await Get.find<AuthStorage>().saveProfileStep(3);
      // Replace AppRoutes.dashboard with your actual home route constant if different.
      Get.offAllNamed(AppRoutes.dashboard);
    } finally {
      isSavingContact.value = false;
    }
  }

  Future<void> initPage3Data() async {
    if (isLoadingContactInfo.value) {
      return;
    }
    if (p3Mobile.value.isNotEmpty) {
      return;
    }
    await loadContactInfo();
  }

  void toggleService(int id) {
    if (selectedServiceIds.contains(id)) {
      selectedServiceIds.remove(id);
    } else {
      selectedServiceIds.add(id);
    }
  }

  void toggleFacility(int id) {
    if (selectedFacilityIds.contains(id)) {
      selectedFacilityIds.remove(id);
    } else {
      selectedFacilityIds.add(id);
    }
  }

  List<SelectedKeyword> _selectedKeywordPayload() {
    final availableKeywords = <KeywordModel>[
      ...qualityKeywords,
      ...serviceKeywords,
    ];
    return availableKeywords
        .where((keyword) => selectedKeywordIds.contains(keyword.keywordId))
        .map(
          (keyword) => SelectedKeyword(
            keywordId: keyword.keywordId,
            keywordType: keyword.keywordTypeId,
          ),
        )
        .toList();
  }

  void nextStage() {
    if (_stageIndex.value < 2) {
      _stageIndex.value += 1;
    }
  }

  void previousStage() {
    if (_stageIndex.value > 0) {
      _stageIndex.value -= 1;
      if (_stageIndex.value == 0) {
        restoreSavedKeywordsIfNeeded();
      }
    }
  }

  void goToStage(int index) {
    if (index >= 0 && index <= 2) {
      _stageIndex.value = index;
    }
  }

  void handleBackPress() {
    if (_stageIndex.value > 0) {
      previousStage();
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text('Exit Onboarding?'),
          content: const Text(
            'Your progress is saved. You can continue after logging in again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                await Get.find<LogoutService>().logout();
              },
              child: Text(
                'Exit',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      );
    }
  }

  void goToStageIfAllowed(int index) {
    if (index < _stageIndex.value) {
      _stageIndex.value = index;
      return;
    }
    if (index > _stageIndex.value) {
      Get.find<NotificationService>().warning(
        'Please complete the current step first.',
      );
      return;
    }
  }

  int _normalizedStage(int step) {
    if (step < 0) {
      return 0;
    }
    if (step > 2) {
      return 2;
    }
    return step;
  }

  int? get _resolvedMerchantId =>
      _authStorage.merchantId ?? _merchantIdOverride;

  void _notifyError(String message) {
    Get.find<NotificationService>().error(message);
  }
}
