import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/core/widgets/scrollable_option_item.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_footer_text.dart';
import 'package:bizrato_owner/features/onboarding/controllers/onboarding_controller.dart';
import 'package:bizrato_owner/features/onboarding/data/models/service_facility_item_model.dart';
import 'package:bizrato_owner/features/onboarding/widgets/onboarding_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BusinessServicesStage extends StatefulWidget {
  const BusinessServicesStage({super.key});

  @override
  State<BusinessServicesStage> createState() => _BusinessServicesStageState();
}

class _BusinessServicesStageState extends State<BusinessServicesStage> {
  final OnboardingController controller = Get.find<OnboardingController>();

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
    _websiteController = TextEditingController(text: controller.page2Website.value);
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initPage2Data();
    });
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
    return Obx(() {
      if (controller.isLoadingServiceData.value) {
        return SizedBox(
          height: 480.h,
          child: Center(
            child: CircularProgressIndicator(
              color: AppTokens.brandPrimary,
              strokeWidth: 2.w,
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: controller.previousStage,
              icon: Icon(
                Icons.arrow_back_ios,
                size: 14.sp,
                color: AppTokens.textPrimary,
              ),
              label: Text(
                'Back',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Obx(() {
            final data = controller.businessServiceData.value;
            if (data == null) {
              return const SizedBox.shrink();
            }

            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppTokens.selectionBackground,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppTokens.brandPrimary),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 16.sp,
                    color: AppTokens.brandPrimary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      data.displayName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTokens.brandPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          OnboardingSectionCard(
            title: 'BUSINESS SERVICES',
            child: Column(
              children: [
                AppTextField(
                  controller: _businessNameController,
                  title: 'Business Name',
                  onChanged: (value) => controller.page2BusinessName.value = value,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: _websiteController,
                  title: 'Website/Optional',
                  onChanged: (value) => controller.page2Website.value = value,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: _famousForController,
                  title: 'Famous For',
                  onChanged: (value) => controller.page2FamousFor.value = value,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: _estbYearController,
                  title: 'Establishment Year',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) => controller.page2EstbYear.value = value,
                ),
                // SizedBox(height: 12.h),
                // AppTextField(
                //   controller: _businessEmailController,
                //   hint: 'Business Email (Optional)',
                //   keyboardType: TextInputType.emailAddress,
                //   onChanged: (value) => controller.page2BusinessEmail.value = value,
                // ),
                // SizedBox(height: 12.h),
                // AppTextField(
                //   controller: _businessWhatsAppController,
                //   hint: 'Business WhatsApp (Optional)',
                //   keyboardType: TextInputType.phone,
                //   onChanged: (value) =>
                //       controller.page2BusinessWhatsApp.value = value,
                // ),
                // SizedBox(height: 12.h),
                // AppTextField(
                //   controller: _businessLandlineController,
                //   hint: 'Business Landline (Optional)',
                //   keyboardType: TextInputType.phone,
                //   onChanged: (value) =>
                //       controller.page2BusinessLandline.value = value,
                // ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          OnboardingSectionCard(
            title: 'SERVICES OFFERED',
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
          SizedBox(height: 16.h),
          OnboardingSectionCard(
            title: 'FACILITIES',
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
          SizedBox(height: 24.h),
          Obx(
            () => PrimaryButton(
              label: 'SAVE & CONTINUE',
              isLoading: controller.isSavingServiceData.value,
              onPressed: controller.savePage2AndContinue,
            ),
          ),
          SizedBox(height: 16.h),
          const AuthFooterText(),
          SizedBox(height: 12.h),
        ],
      );
    });
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
