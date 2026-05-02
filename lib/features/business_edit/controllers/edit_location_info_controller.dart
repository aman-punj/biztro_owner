import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/core/utils/onboarding_validators.dart';
import 'package:bizrato_owner/core/utils/debouncer.dart';
import 'package:bizrato_owner/core/widgets/app_status_dialog.dart';
import 'package:bizrato_owner/features/onboarding/data/models/area_item_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/contact_info_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/location_details_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/save_contact_request.dart';
import 'package:bizrato_owner/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EditLocationInfoController extends GetxController {
  EditLocationInfoController({required this.repository});

  final OnboardingRepository repository;
  final AuthStorage _authStorage = Get.find<AuthStorage>();
  final AppToastService _toastService =
      Get.find<AppToastService>();
  final Debouncer _debouncer = Debouncer();

  final RxBool isLoadingPage = false.obs;
  final RxBool isLoadingLocationDetails = false.obs;
  final RxBool isLoadingAreas = false.obs;
  final RxBool isSaving = false.obs;

  final RxString fullName = ''.obs;
  final RxString landlineNo = ''.obs;
  final RxString mobile = ''.obs;
  final RxString otherMobileNo = ''.obs;
  final RxString emailId = ''.obs;
  final RxString otherEmailId = ''.obs;
  final RxString whatsappNo = ''.obs;
  final RxString website = ''.obs;
  final RxString businessLandLineNo = ''.obs;
  final RxString businessWhatsappNo = ''.obs;
  final RxString businessEmailId = ''.obs;
  final RxString businessId = ''.obs;

  final RxString address = ''.obs;
  final RxString streetNo = ''.obs;
  final RxString landmark = ''.obs;
  final RxString pincode = ''.obs;
  final RxString stateName = ''.obs;
  final RxString cityName = ''.obs;
  final RxInt stateId = 0.obs;
  final RxInt cityId = 0.obs;
  final RxList<AreaItemModel> areaList = <AreaItemModel>[].obs;
  final Rxn<AreaItemModel> selectedArea = Rxn<AreaItemModel>();
  final RxString otherAreaName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocationInfo();
  }

  Future<void> _loadSavedLocationInfo() async {
    isLoadingPage.value = true;
    try {
      final merchantId = _authStorage.merchantId;
      if (merchantId == null || merchantId == 0) {
        _toastService.error('Merchant ID is not available.');
        return;
      }

      final AppResponse<ContactInfoModel> response =
          await repository.getContactInfo(merchantId);
      if (!response.success || response.data?.result == null) {
        _toastService.error(response.message.isNotEmpty
            ? response.message
            : 'Unable to load location information.');
        return;
      }

      final ContactInfoResult result = response.data!.result!;
      fullName.value = result.fullName;
      landlineNo.value = result.landlineNo ?? '';
      mobile.value = result.mobile;
      otherMobileNo.value = result.otherMobileNo ?? '';
      emailId.value = result.emailId;
      otherEmailId.value = result.otherEmailId ?? '';
      whatsappNo.value = result.whatsappNo ?? '';
      website.value = result.website ?? '';
      businessLandLineNo.value = result.businessLandLineNo ?? '';
      businessWhatsappNo.value = result.businessWhatsappNo ?? '';
      businessEmailId.value = result.businessEmailId ?? '';
      businessId.value = result.businessId ?? '';

      address.value = result.address ?? '';
      streetNo.value = result.streetNo ?? '';
      landmark.value = result.landmark ?? '';
      pincode.value = result.pincode ?? '';
      stateName.value = result.stateName ?? '';
      cityName.value = result.cityName ?? '';
      stateId.value = result.stateId;
      cityId.value = result.cityId;
      otherAreaName.value = result.otherAreaName ?? '';

      if (result.pincode != null && result.pincode!.isNotEmpty) {
        await _loadLocationByPincode(result.pincode!);
        await _loadAreasByPincode(result.pincode!);

        if (result.areaId > 0) {
          AreaItemModel? matched;
          for (final area in areaList) {
            if (area.areaId == result.areaId) {
              matched = area;
              break;
            }
          }
          selectedArea.value = matched;
        }

        if (selectedArea.value == null &&
            (result.areaName?.isNotEmpty ?? false)) {
          AreaItemModel? matched;
          for (final area in areaList) {
            if (area.areaName.toLowerCase() == result.areaName!.toLowerCase()) {
              matched = area;
              break;
            }
          }
          selectedArea.value = matched;
        }
      }
    } finally {
      isLoadingPage.value = false;
    }
  }

  void onPincodeChanged(String value) {
    pincode.value = value;

    if (value.length < 6) {
      stateName.value = '';
      cityName.value = '';
      stateId.value = 0;
      cityId.value = 0;
      areaList.clear();
      selectedArea.value = null;
      return;
    }

    if (value.length == 6) {
      FocusManager.instance.primaryFocus?.unfocus();
      _debouncer(
        () async {
          await _loadLocationByPincode(value);
          await _loadAreasByPincode(value);
        },
        duration: const Duration(milliseconds: 600),
      );
    }
  }

  Future<void> _loadLocationByPincode(String value) async {
    isLoadingLocationDetails.value = true;
    try {
      final response = await repository.getLocationByPincode(value);
      if (!response.success) {
        return;
      }

      final locations = response.data?.data ?? const <LocationDetailsItem>[];
      if (locations.isNotEmpty) {
        final location = locations.first;
        stateName.value = location.stateName;
        cityName.value = location.cityName;
        stateId.value = location.stateId;
        cityId.value = location.cityId;
      }
    } finally {
      isLoadingLocationDetails.value = false;
    }
  }

  Future<void> _loadAreasByPincode(String value) async {
    isLoadingAreas.value = true;
    try {
      final response = await repository.getAreasByPincode(value);
      if (!response.success) {
        areaList.clear();
        selectedArea.value = null;
        return;
      }

      final areas = response.data?.data ?? const <AreaItemModel>[];
      areaList.assignAll(areas);
      if (selectedArea.value != null &&
          !areaList.any((area) => area.areaId == selectedArea.value!.areaId)) {
        selectedArea.value = null;
      }
    } finally {
      isLoadingAreas.value = false;
    }
  }

  void selectArea(AreaItemModel area) {
    selectedArea.value = area;
    if (!_isOtherArea(area)) {
      otherAreaName.value = '';
    }
  }

  String? _validateForm() {
    return OnboardingValidators.validateLocationAndContact(
      fullName: fullName.value,
      address: address.value,
      streetNo: streetNo.value,
      landmark: landmark.value,
      pincode: pincode.value,
      stateName: stateName.value,
      cityName: cityName.value,
      hasSelectedArea: selectedArea.value != null,
    );
  }

  Future<void> saveAndUpdate() async {
    final validationError = _validateForm();
    if (validationError != null) {
      _toastService.error(validationError);
      return;
    }

    final isOtherAreaSelected = _isOtherArea(selectedArea.value);
    if (isOtherAreaSelected && otherAreaName.value.trim().isEmpty) {
      _toastService.error('Please enter area name.');
      return;
    }

    final merchantId = _authStorage.merchantId;
    if (merchantId == null || merchantId == 0) {
      _toastService.error('Merchant ID is unavailable.');
      return;
    }

    final areaId = isOtherAreaSelected ? 0 : selectedArea.value?.areaId ?? 0;
    final areaName = isOtherAreaSelected
        ? otherAreaName.value.trim()
        : selectedArea.value?.areaName ?? '';

    final request = SaveContactRequest(
      fullName: fullName.value.trim(),
      landlineNo: landlineNo.value.trim(),
      mobile: mobile.value.trim(),
      otherMobileNo: otherMobileNo.value.trim(),
      emailId: emailId.value.trim(),
      otherEmailId: otherEmailId.value.trim(),
      whatsappNo: whatsappNo.value.trim(),
      website: website.value.trim(),
      businessLandLineNo: businessLandLineNo.value.trim(),
      businessWhatsappNo: businessWhatsappNo.value.trim(),
      businessEmailId: businessEmailId.value.trim(),
      address: address.value.trim(),
      streetNo: streetNo.value.trim(),
      landmark: landmark.value.trim(),
      stateName: stateName.value.trim(),
      cityName: cityName.value.trim(),
      pincode: pincode.value.trim(),
      stateId: stateId.value,
      cityId: cityId.value,
      areaId: areaId,
      areaName: areaName,
      otherAreaName: otherAreaName.value.trim(),
      merchantId: merchantId,
      businessId: businessId.value.trim(),
    );

    isSaving.value = true;
    try {
      final AppResponse<void> response =
          await repository.saveContactDetails(request);
      if (!response.success) {
        await AppStatusDialog.show(
          dialog: AppStatusDialog.error(
            message: response.message.isNotEmpty
                ? response.message
                : 'Unable to update location information.',
          ),
        );
        return;
      }

      await AppStatusDialog.show(
        dialog: AppStatusDialog.success(
          message: 'Location information updated successfully.',
        ),
        onDismissed: () => Get.offAllNamed(AppRoutes.dashboard),
      );
    } finally {
      isSaving.value = false;
    }
  }

  bool get isOtherAreaSelected => _isOtherArea(selectedArea.value);

  bool _isOtherArea(AreaItemModel? area) {
    return area?.areaName.trim().toLowerCase() == 'other';
  }
}
