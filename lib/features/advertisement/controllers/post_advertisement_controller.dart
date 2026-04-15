import 'dart:io';

import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_category_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_format_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_location_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_master_data_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/ad_state_model.dart';
import 'package:bizrato_owner/features/advertisement/data/models/save_ad_request.dart';
import 'package:bizrato_owner/features/advertisement/data/repositories/advertisement_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostAdvertisementController extends GetxController {
  PostAdvertisementController({required this.repository});

  final AdvertisementRepository repository;
  final AuthStorage _authStorage = Get.find<AuthStorage>();
  final AppToastService _toastService = Get.find<AppToastService>();

  // State management
  final RxInt currentStep = 0.obs;
  final RxBool isLoadingPage = false.obs;
  final RxBool isSaving = false.obs;

  // Master data
  final RxList<AdLocationModel> locations = <AdLocationModel>[].obs;
  final RxList<AdFormatModel> formats = <AdFormatModel>[].obs;
  final RxList<AdStateModel> states = <AdStateModel>[].obs;
  final RxList<AdCategoryModel> categories = <AdCategoryModel>[].obs;

  // Form data
  final Rx<AdLocationModel?> selectedLocation = Rx(null);
  final Rx<AdFormatModel?> selectedFormat = Rx(null);
  final Rx<String?> locationType = Rx(null); // Single or Multiple
  final Rx<String?> categoryType = Rx(null); // Single or Multiple
  final RxList<AdStateModel> selectedStates = <AdStateModel>[].obs;
  final RxList<AdCategoryModel> selectedCategories = <AdCategoryModel>[].obs;
  final Rx<File?> selectedImage = Rx(null);

  final ImagePicker _imagePicker = ImagePicker();

  // Getters
  bool get isStep1Complete =>
      selectedLocation.value != null &&
      selectedFormat.value != null &&
      locationType.value != null;

  bool get isStep2Complete =>
      categoryType.value != null &&
      ((categoryType.value == 'Single' && selectedCategories.isNotEmpty) ||
          (categoryType.value == 'Multiple' && selectedCategories.isNotEmpty));

  bool get isStep3Complete =>
      (locationType.value == 'Single' && selectedStates.isNotEmpty) ||
      (locationType.value == 'Multiple' && selectedStates.isNotEmpty);

  bool get isStep4Complete => selectedImage.value != null;

  @override
  void onInit() {
    super.onInit();
    loadMasterData();
  }

  /// Load master data for advertisement
  Future<void> loadMasterData() async {
    isLoadingPage.value = true;
    try {
      final AppResponse<AdMasterDataModel> response =
          await repository.getMasterData();

      if (!response.success || response.data == null) {
        _toastService.error(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load advertisement data.',
        );
        return;
      }

      final data = response.data!;
      locations.assignAll(data.locations);
      formats.assignAll(data.formats);
      states.assignAll(data.states);
      categories.assignAll(data.categories);
    } finally {
      isLoadingPage.value = false;
    }
  }

  /// Step 1: Select location and format
  void selectLocation(AdLocationModel location) {
    selectedLocation.value = location;
  }

  void selectFormat(AdFormatModel format) {
    selectedFormat.value = format;
  }

  void setLocationType(String type) {
    locationType.value = type;
    // Reset selected states when changing type
    selectedStates.clear();
  }

  /// Step 2: Select category type
  void setCategoryType(String type) {
    categoryType.value = type;
    // Reset selected categories when changing type
    selectedCategories.clear();
  }

  /// Step 3: Select states or categories
  void toggleState(AdStateModel state) {
    if (locationType.value == 'Single') {
      selectedStates.clear();
      selectedStates.add(state);
    } else {
      final exists = selectedStates.any((s) => s.name == state.name);
      if (exists) {
        selectedStates.removeWhere((s) => s.name == state.name);
      } else {
        selectedStates.add(state);
      }
    }
  }

  void toggleCategory(AdCategoryModel category) {
    if (categoryType.value == 'Single') {
      selectedCategories.clear();
      selectedCategories.add(category);
    } else {
      final exists = selectedCategories.any((c) => c.id == category.id);
      if (exists) {
        selectedCategories.removeWhere((c) => c.id == category.id);
      } else {
        selectedCategories.add(category);
      }
    }
  }

  /// Step 4: Pick image
  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      _toastService.error('Failed to pick image');
    }
  }

  /// Navigate to next step
  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
    }
  }

  /// Navigate to previous step
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  /// Submit advertisement
  Future<void> submitAdvertisement() async {
    final merchantId = _authStorage.merchantId;
    if (merchantId == null || merchantId == 0) {
      _toastService.error('Merchant ID is not available');
      return;
    }

    if (selectedImage.value == null) {
      _toastService.error('Please select an image');
      return;
    }

    isSaving.value = true;
    try {
      final selectedStateNames = selectedStates.map((s) => s.name).toList();
      final selectedCategoryValues =
          selectedCategories.map((c) => c.value).toList();

      final request = SaveAdRequest(
        merchantId: merchantId,
        adPageLocation: selectedLocation.value!.value,
        adFormat: selectedFormat.value!.value,
        locationType: locationType.value!,
        categoryType: categoryType.value!,
        singleState: locationType.value == 'Single'
            ? selectedStateNames.firstOrNull
            : null,
        singleCategory: categoryType.value == 'Single'
            ? selectedCategoryValues.firstOrNull
            : null,
        multipleStates:
            locationType.value == 'Multiple' ? selectedStateNames : null,
        multipleCategories:
            categoryType.value == 'Multiple' ? selectedCategoryValues : null,
      );

      final AppResponse<Map<String, dynamic>> response =
          await repository.saveAdvertisement(
        request: request,
        imageFile: selectedImage.value!,
      );

      if (response.success) {
        _toastService.success('Advertisement posted successfully');
        // Clear form and navigate back
        resetForm();
        Get.offNamed(AppRoutes.dashboard);
      } else {
        _toastService.error(response.message);
      }
    } finally {
      isSaving.value = false;
    }
  }

  /// Reset form
  void resetForm() {
    currentStep.value = 0;
    selectedLocation.value = null;
    selectedFormat.value = null;
    locationType.value = null;
    categoryType.value = null;
    selectedStates.clear();
    selectedCategories.clear();
    selectedImage.value = null;
  }

  /// Get selected state display text
  String getSelectedStateText() {
    if (selectedStates.isEmpty) return 'Select State';
    if (locationType.value == 'Single') {
      return selectedStates.first.name;
    }
    return '${selectedStates.length} states selected';
  }

  /// Get selected category display text
  String getSelectedCategoryText() {
    if (selectedCategories.isEmpty) return 'Select Category';
    if (categoryType.value == 'Single') {
      return selectedCategories.first.name;
    }
    return '${selectedCategories.length} categories selected';
  }
}
