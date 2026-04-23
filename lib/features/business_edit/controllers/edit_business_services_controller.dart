import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/core/widgets/app_status_dialog.dart';
import 'package:bizrato_owner/features/onboarding/data/models/business_service_model.dart';
import 'package:bizrato_owner/features/onboarding/data/models/save_service_facilities_request.dart';
import 'package:bizrato_owner/features/onboarding/data/models/service_facility_item_model.dart';
import 'package:bizrato_owner/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class EditBusinessServicesController extends GetxController {
  EditBusinessServicesController({required this.repository});

  final OnboardingRepository repository;
  final AuthStorage _authStorage = Get.find<AuthStorage>();
  final AppToastService _toastService =
      Get.find<AppToastService>();

  final Rxn<BusinessServiceResult> businessServiceData =
      Rxn<BusinessServiceResult>();
  final RxBool isLoadingPage = false.obs;
  final RxBool isSaving = false.obs;
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

  @override
  void onInit() {
    super.onInit();
    loadExistingData();
  }

  Future<void> loadExistingData() async {
    isLoadingPage.value = true;
    try {
      final merchantId = _authStorage.merchantId;
      if (merchantId == null || merchantId == 0) {
        _toastService.error('Merchant ID is not available.');
        return;
      }

      final response = await repository.getBusinessServiceData(merchantId);
      if (!response.success || response.data?.result == null) {
        _toastService.error(response.message.isNotEmpty
            ? response.message
            : 'Unable to load business service data.');
        return;
      }

      final data = response.data!.result!;
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
      isLoadingPage.value = false;
    }
  }

  Future<void> loadServiceFacilitiesList(String categoryId) async {
    isLoadingFacilities.value = true;
    try {
      final response = await repository.getServiceFacilitiesList(categoryId);
      if (!response.success) {
        servicesOfferedList.clear();
        facilitiesList.clear();
        selectedServiceIds.clear();
        selectedFacilityIds.clear();
        _toastService.error(response.message);
        return;
      }

      final items = response.data ??
          const ServiceFacilityListModel(
            servicesOffered: <ServiceFacilityItemModel>[],
            facilities: <ServiceFacilityItemModel>[],
          );
      servicesOfferedList.assignAll(items.servicesOffered);
      facilitiesList.assignAll(items.facilities);

      final savedData = businessServiceData.value;
      final savedServiceIds = savedData?.serviceOfferedList
              .where((service) => service.isSelected)
              .map((service) => service.serviceOfferedId)
              .toSet() ??
          <int>{};
      final savedFacilityIds = savedData?.facilitiesList
              .where((facility) => facility.isSelected)
              .map((facility) => facility.facilitiesId)
              .toSet() ??
          <int>{};

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
    } finally {
      isLoadingFacilities.value = false;
    }
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

  Future<void> saveAndUpdate() async {
    final data = businessServiceData.value;
    if (data == null) {
      _toastService.error('Business service data is unavailable.');
      return;
    }

    final merchantId = _authStorage.merchantId;
    if (merchantId == null || merchantId == 0) {
      _toastService.error('Merchant ID is unavailable.');
      return;
    }

    if (data.categoryId <= 0 || data.subCategoryId <= 0) {
      _toastService.error('Category details are unavailable.');
      return;
    }

    final estbYear = page2EstbYear.value.trim();
    if (estbYear.isNotEmpty && estbYear.length != 4) {
      _toastService.error('Establishment year must be exactly 4 digits.');
      return;
    }

    final request = SaveServiceFacilitiesRequest(
      merchantId: merchantId,
      categoryId: data.categoryId,
      subcategoryId: data.subCategoryId,
      website: page2Website.value.trim(),
      famousFor: page2FamousFor.value.trim(),
      estbYear: estbYear,
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

    isSaving.value = true;
    try {
      final AppResponse<void> response =
          await repository.saveServiceFacilities(request);
      if (!response.success) {
        await AppStatusDialog.show(
          dialog: AppStatusDialog.error(
            message: response.message.isNotEmpty
                ? response.message
                : 'Unable to update business services.',
          ),
        );
        return;
      }

      await AppStatusDialog.show(
        dialog: AppStatusDialog.success(
          message: 'Business services updated successfully.',
        ),
        onDismissed: () => Get.offAllNamed(AppRoutes.dashboard),
      );
    } finally {
      isSaving.value = false;
    }
  }
}
