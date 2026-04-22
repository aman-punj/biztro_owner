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
  final ImagePicker _imagePicker = ImagePicker();

  final RxInt currentStep = 0.obs;
  final RxBool isLoadingPage = false.obs;
  final RxBool isSaving = false.obs;

  final RxList<AdLocationModel> locations = <AdLocationModel>[].obs;
  final RxList<AdFormatModel> formats = <AdFormatModel>[].obs;
  final RxList<AdStateModel> states = <AdStateModel>[].obs;
  final RxList<AdCategoryModel> categories = <AdCategoryModel>[].obs;

  final Rx<AdLocationModel?> selectedLocation = Rx<AdLocationModel?>(null);
  final Rx<AdFormatModel?> selectedFormat = Rx<AdFormatModel?>(null);
  final Rx<String> locationType = 'Single'.obs;
  final Rx<String> categoryType = 'Single'.obs;
  final RxList<AdStateModel> selectedStates = <AdStateModel>[].obs;
  final RxList<AdCategoryModel> selectedCategories = <AdCategoryModel>[].obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

  static const int totalSteps = 5;

  bool get isLocationStepComplete => selectedLocation.value != null;
  bool get isFormatStepComplete => selectedFormat.value != null;
  bool get isTargetLocationStepComplete => selectedStates.isNotEmpty;
  bool get isCategoryStepComplete => selectedCategories.isNotEmpty;
  bool get isUploadStepComplete => selectedImage.value != null;

  String get primaryButtonLabel =>
      currentStep.value == totalSteps - 1 ? 'SUBMIT AD' : 'CONTINUE';

  @override
  void onInit() {
    super.onInit();
    loadMasterData();
  }

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

  void selectLocation(AdLocationModel location) {
    selectedLocation.value = location;
  }

  void selectFormat(AdFormatModel format) {
    selectedFormat.value = format;
  }

  void setLocationType(String type) {
    if (locationType.value == type) return;
    locationType.value = type;
    selectedStates.clear();
  }

  void setCategoryType(String type) {
    if (categoryType.value == type) return;
    categoryType.value = type;
    selectedCategories.clear();
  }

  void toggleState(AdStateModel state) {
    if (locationType.value == 'Single') {
      selectedStates.assignAll([state]);
      return;
    }

    final exists = selectedStates.any((item) => item.id == state.id);
    if (exists) {
      selectedStates.removeWhere((item) => item.id == state.id);
    } else {
      selectedStates.add(state);
    }
  }

  void toggleCategory(AdCategoryModel category) {
    if (categoryType.value == 'Single') {
      selectedCategories.assignAll([category]);
      return;
    }

    final exists =
        selectedCategories.any((item) => item.value == category.value);
    if (exists) {
      selectedCategories.removeWhere((item) => item.value == category.value);
    } else {
      selectedCategories.add(category);
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (_) {
      _toastService.error('Failed to pick image');
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  Future<void> handlePrimaryAction() async {
    if (!_validateCurrentStep()) return;

    if (currentStep.value == totalSteps - 1) {
      await submitAdvertisement();
      return;
    }

    currentStep.value++;
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        if (!isLocationStepComplete) {
          _toastService.error('Please select an ad location');
          return false;
        }
        return true;
      case 1:
        if (!isFormatStepComplete) {
          _toastService.error('Please select an ad format');
          return false;
        }
        return true;
      case 2:
        if (!isTargetLocationStepComplete) {
          _toastService.error('Please select at least one state');
          return false;
        }
        return true;
      case 3:
        if (!isCategoryStepComplete) {
          _toastService.error('Please select at least one category');
          return false;
        }
        return true;
      case 4:
        if (!isUploadStepComplete) {
          _toastService.error('Please select an ad image');
          return false;
        }
        return true;
      default:
        return false;
    }
  }

  Future<void> submitAdvertisement() async {
    final merchantId = _authStorage.merchantId;
    if (merchantId == null || merchantId == 0) {
      _toastService.error('Merchant ID is not available');
      return;
    }

    if (selectedLocation.value == null || selectedFormat.value == null) {
      _toastService.error('Please complete the advertisement details');
      return;
    }

    final imageFile = selectedImage.value;
    if (imageFile == null) {
      _toastService.error('Please select an ad image');
      return;
    }

    isSaving.value = true;
    try {
      final selectedStateNames = selectedStates.map((item) => item.name).toList();
      final selectedCategoryValues =
          selectedCategories.map((item) => item.value).toList();

      final request = SaveAdRequest(
        merchantId: merchantId,
        adPageLocation: selectedLocation.value!.value,
        adFormat: selectedFormat.value!.value,
        locationType: locationType.value,
        categoryType: categoryType.value,
        singleState:
            locationType.value == 'Single' ? selectedStateNames.first : null,
        singleCategory: categoryType.value == 'Single'
            ? selectedCategoryValues.first
            : null,
        multipleStates:
            locationType.value == 'Multiple' ? selectedStateNames : null,
        multipleCategories: categoryType.value == 'Multiple'
            ? selectedCategoryValues
            : null,
      );

      final AppResponse<Map<String, dynamic>> response =
          await repository.saveAdvertisement(
        request: request,
        imageFile: imageFile,
      );

      if (response.success) {
        _toastService.success('Advertisement posted successfully');
        resetForm();
        Get.offNamed(AppRoutes.dashboard);
      } else {
        _toastService.error(response.message);
      }
    } finally {
      isSaving.value = false;
    }
  }

  void resetForm() {
    currentStep.value = 0;
    selectedLocation.value = null;
    selectedFormat.value = null;
    locationType.value = 'Single';
    categoryType.value = 'Single';
    selectedStates.clear();
    selectedCategories.clear();
    selectedImage.value = null;
  }
}
