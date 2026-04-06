import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/core/notifications/notification_service.dart';
import 'package:bizrato_owner/core/notifications/notification_service_extension.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/core/utils/debouncer.dart';
import 'package:bizrato_owner/core/widgets/app_status_dialog.dart';
import 'package:bizrato_owner/features/onboarding/data/models/business_details_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/keyword_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/saved_keywords_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/save_keywords_request.dart';
import 'package:bizrato_owner/features/onboarding/data/models/search_result_model.dart'; 
import 'package:bizrato_owner/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class EditBusinessDetailsController extends GetxController {
  EditBusinessDetailsController({required this.repository});

  final OnboardingRepository repository;
  final AuthStorage _authStorage = Get.find<AuthStorage>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  final Debouncer _debouncer = Debouncer();

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
  final RxBool isLoadingPage = false.obs;
  final RxBool isCategoryRestored = false.obs;
  final RxBool isRestoringKeywords = false.obs;

  String? _lastLoadedCategoryId;

  bool get hasSelectedCategory => selectedCategory.value != null;
  bool get canAddMoreKeywords => customKeywords.length < 5;

  @override
  void onInit() {
    super.onInit();
    loadExistingData();
  }

  @override
  void onClose() {
    _debouncer.cancel();
    super.onClose();
  }

  Future<void> loadExistingData() async {
    isLoadingPage.value = true;
    try {
      final merchantId = _authStorage.merchantId;
      if (merchantId == null || merchantId == 0) {
        _notificationService.error('Merchant ID is not available.');
        return;
      }

      final response = await repository.getBusinessDetails(merchantId);
      if (!response.success || response.data?.result == null) {
        _notificationService.error(response.message.isNotEmpty
            ? response.message
            : 'Unable to load business details.');
        return;
      }

      final BusinessDetailsResult result = response.data!.result!;
      businessName.value = result.businessName;

      final String categoryId = result.encryptSubCategoryId.isNotEmpty
          ? result.encryptSubCategoryId
          : result.subcategoryId > 0
              ? result.subcategoryId.toString()
              : result.categoryId.toString();

      if (categoryId.isNotEmpty && categoryId != '0') {
        selectedCategory.value = SearchResultModel(
          keywordId: categoryId,
          displayName: result.displayName,
        );
        searchQuery.value = result.displayName;
        isCategoryRestored.value = true;
        await _loadKeywords(categoryId);
      }

      await _loadSavedKeywords(merchantId);
    } finally {
      isLoadingPage.value = false;
    }
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
        await repository.searchCategory(term);
    isSearching.value = false;

    if (!response.success) {
      _notificationService.error(response.message);
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
        await repository.getKeywords(categoryId);
    isLoadingKeywords.value = false;

    if (!response.success) {
      _notificationService.error(response.message);
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

  Future<void> _loadSavedKeywords(int merchantId) async {
    if (selectedCategory.value == null) {
      return;
    }

    if (isRestoringKeywords.value) {
      return;
    }

    isRestoringKeywords.value = true;
    try {
      final AppResponse<SavedKeywordsModel> response =
          await repository.getSavedKeywords(merchantId);
      if (!response.success || response.data == null) {
        return;
      }

      final savedKeywords = response.data!;
      selectedKeywordIds.addAll(
        savedKeywords.keywords
            .map((keyword) => keyword.keywordId)
            .where((id) => id > 0),
      );

      for (final keyword in savedKeywords.otherKeywords) {
        if (!canAddMoreKeywords) break;
        if (!customKeywords.contains(keyword)) {
          customKeywords.add(keyword);
        }
      }
    } finally {
      isRestoringKeywords.value = false;
    }
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

  void updateCustomKeyword({
    required String oldValue,
    required String newValue,
  }) {
    final trimmed = newValue.trim();
    final currentIndex = customKeywords.indexOf(oldValue);
    if (currentIndex == -1) {
      return;
    }

    if (trimmed.isEmpty) {
      customKeywords.removeAt(currentIndex);
      return;
    }

    final duplicateIndex = customKeywords.indexOf(trimmed);
    if (duplicateIndex != -1 && duplicateIndex != currentIndex) {
      return;
    }

    customKeywords[currentIndex] = trimmed;
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

  Future<void> saveAndUpdate() async {
    if (selectedCategory.value == null) {
      _notificationService.error('Please select a category.');
      return;
    }

    final List<SelectedKeyword> keywordPayload = _selectedKeywordPayload();
    if (keywordPayload.isEmpty && customKeywords.isEmpty) {
      _notificationService.error(
        'Please select at least one keyword or add your own.',
      );
      return;
    }

    final merchantId = _authStorage.merchantId;
    if (merchantId == null || merchantId == 0) {
      _notificationService.error('Merchant ID is unavailable.');
      return;
    }

    final request = SaveKeywordsRequest(
      businessName: businessName.value.trim(),
      categoryId: selectedCategory.value!.keywordId,
      keywords: keywordPayload,
      otherKeywords: List<String>.from(customKeywords),
      merchantId: merchantId,
    );

    isSaving.value = true;
    try {
      final AppResponse<void> response = await repository.saveKeywords(request);
      if (!response.success) {
        await AppStatusDialog.show(
          dialog: AppStatusDialog.error(
            message: response.message.isNotEmpty
                ? response.message
                : 'Unable to update business details.',
          ),
        );
        return;
      }

      await AppStatusDialog.show(
        dialog: AppStatusDialog.success(
          message: 'Business details updated successfully.',
        ),
        onDismissed: () => Get.offAllNamed(AppRoutes.dashboard),
      );
    } finally {
      isSaving.value = false;
    }
  }

  List<SelectedKeyword> _selectedKeywordPayload() {
    final availableKeywords = <KeywordModel>[
      ...qualityKeywords,
      ...serviceKeywords,
    ];
    return availableKeywords
        .where((keyword) => selectedKeywordIds.contains(keyword.keywordId))
        .map((keyword) => SelectedKeyword(
              keywordId: keyword.keywordId,
              keywordType: keyword.keywordTypeId,
            ))
        .toList();
  }
}
