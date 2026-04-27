import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/core/widgets/year_picker_dialog.dart';
import 'package:bizrato_owner/features/business_edit/controllers/edit_business_services_controller.dart';
import 'package:bizrato_owner/features/business_edit/widgets/widgets.dart';
import 'package:bizrato_owner/features/onboarding/data/models/service_facility_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditBusinessServicesView extends StatefulWidget {
  const EditBusinessServicesView({super.key});

  @override
  State<EditBusinessServicesView> createState() =>
      _EditBusinessServicesViewState();
}

class _EditBusinessServicesViewState extends State<EditBusinessServicesView> {
  final EditBusinessServicesController controller =
      Get.find<EditBusinessServicesController>();

  late final TextEditingController _businessNameController;
  late final TextEditingController _websiteController;
  late final TextEditingController _famousForController;
  late final TextEditingController _estbYearController;
  late final TextEditingController _businessEmailController;
  late final TextEditingController _businessWhatsAppController;
  late final TextEditingController _businessLandlineController;

  Worker? _businessNameWorker;
  Worker? _websiteWorker;
  Worker? _famousForWorker;
  Worker? _estbYearWorker;
  Worker? _businessEmailWorker;
  Worker? _businessWhatsAppWorker;
  Worker? _businessLandlineWorker;

  @override
  void initState() {
    super.initState();
    _businessNameController =
        TextEditingController(text: controller.page2BusinessName.value);
    _websiteController =
        TextEditingController(text: controller.page2Website.value);
    _famousForController =
        TextEditingController(text: controller.page2FamousFor.value);
    _estbYearController =
        TextEditingController(text: controller.page2EstbYear.value);
    _businessEmailController =
        TextEditingController(text: controller.page2BusinessEmail.value);
    _businessWhatsAppController =
        TextEditingController(text: controller.page2BusinessWhatsApp.value);
    _businessLandlineController =
        TextEditingController(text: controller.page2BusinessLandline.value);

    _businessNameWorker = ever<String>(
      controller.page2BusinessName,
      (value) => _syncController(_businessNameController, value),
    );
    _websiteWorker = ever<String>(
      controller.page2Website,
      (value) => _syncController(_websiteController, value),
    );
    _famousForWorker = ever<String>(
      controller.page2FamousFor,
      (value) => _syncController(_famousForController, value),
    );
    _estbYearWorker = ever<String>(
      controller.page2EstbYear,
      (value) => _syncController(_estbYearController, value),
    );
    _businessEmailWorker = ever<String>(
      controller.page2BusinessEmail,
      (value) => _syncController(_businessEmailController, value),
    );
    _businessWhatsAppWorker = ever<String>(
      controller.page2BusinessWhatsApp,
      (value) => _syncController(_businessWhatsAppController, value),
    );
    _businessLandlineWorker = ever<String>(
      controller.page2BusinessLandline,
      (value) => _syncController(_businessLandlineController, value),
    );
  }

  @override
  void dispose() {
    _businessNameWorker?.dispose();
    _websiteWorker?.dispose();
    _famousForWorker?.dispose();
    _estbYearWorker?.dispose();
    _businessEmailWorker?.dispose();
    _businessWhatsAppWorker?.dispose();
    _businessLandlineWorker?.dispose();
    _businessNameController.dispose();
    _websiteController.dispose();
    _famousForController.dispose();
    _estbYearController.dispose();
    _businessEmailController.dispose();
    _businessWhatsAppController.dispose();
    _businessLandlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Business Services',
      child: Obx(
        () {
          if (controller.isLoadingPage.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    final data = controller.businessServiceData.value;
                    if (data == null) {
                      return const SizedBox.shrink();
                    }

                    return BusinessEditHeader(
                      businessName: data.displayName.obs,
                      subtitle: '',
                    );
                  },
                ),
                SizedBox(height: 16.h),
                OnboardingSectionCard(
                  title: 'BASIC INFO',
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _businessNameController,
                        title: 'Business Name',
                        readOnly: true,
                        suffixIcon: Icon(
                          Icons.lock_outline,
                          size: 16.sp,
                          color: AppTokens.textSecondary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      AppTextField(
                        controller: _websiteController,
                        title: 'Website (Optional)',
                        keyboardType: TextInputType.url,
                        onChanged: (value) =>
                            controller.page2Website.value = value,
                      ),
                      SizedBox(height: 12.h),
                      AppTextField(
                        controller: _famousForController,
                        title: 'Famous For/Speciality',
                        onChanged: (value) =>
                            controller.page2FamousFor.value = value,
                      ),
                      SizedBox(height: 12.h),
                      AppTextField(
                        controller: _estbYearController,
                        title: 'Establishment Year',
                        readOnly: true,
                        onTap: () async {
                          final int currentYear = DateTime.now().year;
                          final int? pickedYear = await showAppYearPicker(
                            context: context,
                            initialYear:
                                int.tryParse(_estbYearController.text) ??
                                    currentYear,
                            firstYear: 1900,
                            lastYear: currentYear + 1,
                          );
                          if (pickedYear != null) {
                            _estbYearController.text = pickedYear.toString();
                            controller.page2EstbYear.value =
                                pickedYear.toString();
                          }
                        },
                      ),
                      SizedBox(height: 12.h),
                      AppTextField(
                        controller: _businessEmailController,
                        title: 'Business Email (Optional)',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) =>
                            controller.page2BusinessEmail.value = value,
                      ),
                      SizedBox(height: 12.h),
                      AppTextField(
                        controller: _businessWhatsAppController,
                        title: 'Business WhatsApp (Optional)',
                        keyboardType: TextInputType.phone,
                        onChanged: (value) =>
                            controller.page2BusinessWhatsApp.value = value,
                      ),
                      SizedBox(height: 12.h),
                      AppTextField(
                        controller: _businessLandlineController,
                        title: 'Business Landline (Optional)',
                        keyboardType: TextInputType.phone,
                        onChanged: (value) =>
                            controller.page2BusinessLandline.value = value,
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 16.h),
                OnboardingSectionCard(
                  title: 'SERVICES OFFERED',
                  titleIcon: AppImage(path: AppAssets.sparkleIcon),
                  child: Obx(
                    () => _buildServiceFacilityContent(
                      items: controller.servicesOfferedList,
                      isLoading: controller.isLoadingFacilities.value,
                      selectedIds: controller.selectedServiceIds,
                      onTap: controller.toggleService,
                      emptyMessage: 'Services list will be available soon.',
                    ),
                  ),
                ),
                // SizedBox(height: 16.h),
                OnboardingSectionCard(
                  title: 'FACILITIES',
                  titleIcon: AppImage(path: AppAssets.flashIcon),
                  child: Obx(
                    () => _buildServiceFacilityContent(
                      items: controller.facilitiesList,
                      isLoading: controller.isLoadingFacilities.value,
                      selectedIds: controller.selectedFacilityIds,
                      onTap: controller.toggleFacility,
                      emptyMessage: 'Facilities list will be available soon.',
                    ),
                  ),
                ),
                SafeArea(
                    child: Obx(
                  () => PrimaryButton(
                    label: 'SAVE & CONTINUE',
                    isLoading: controller.isSaving.value,
                    onPressed: controller.saveAndUpdate,
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceFacilityContent({
    required List<ServiceFacilityItemModel> items,
    required bool isLoading,
    required Set<int> selectedIds,
    required ValueChanged<int> onTap,
    required String emptyMessage,
  }) {
    if (isLoading) {
      return SizedBox(
        height: 96.h,
        child: Center(
          child: CircularProgressIndicator(
            color: AppTokens.brandPrimary,
            strokeWidth: 2.w,
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Text(
          emptyMessage,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppTokens.textSecondary,
          ),
        ),
      );
    }

    return ScrollableOptionList(
      maxHeight: 220.h,
      title: emptyMessage == 'Services list will be available soon.'
          ? 'SERVICES OFFERED'
          : 'FACILITIES',
      items: items
          .map((item) => ScrollableOptionItem(id: item.id, label: item.name))
          .toList(),
      selectedIds: selectedIds.toSet(),
      onTap: (item) => onTap(item.id),
    );
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }

    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }
}
