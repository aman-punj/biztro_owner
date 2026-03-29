import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_footer_text.dart';
import 'package:bizrato_owner/features/onboarding/controllers/onboarding_controller.dart';
import 'package:bizrato_owner/features/onboarding/data/models/area_item_model.dart';
import 'package:bizrato_owner/features/onboarding/widgets/onboarding_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonalInformationStage extends StatefulWidget {
  const PersonalInformationStage({super.key});

  @override
  State<PersonalInformationStage> createState() =>
      _PersonalInformationStageState();
}

class _PersonalInformationStageState extends State<PersonalInformationStage> {
  final OnboardingController controller = Get.find<OnboardingController>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _mobileController;
  late final TextEditingController _whatsAppController;
  late final TextEditingController _landlineController;
  late final TextEditingController _businessEmailController;
  late final TextEditingController _businessWhatsAppController;
  late final TextEditingController _businessLandlineController;
  late final TextEditingController _addressController;
  late final TextEditingController _streetController;
  late final TextEditingController _landmarkController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _stateController;
  late final TextEditingController _cityController;
  late final TextEditingController _areaController;

  final List<Worker> _workers = <Worker>[];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _whatsAppController = TextEditingController();
    _landlineController = TextEditingController();
    _businessEmailController = TextEditingController();
    _businessWhatsAppController = TextEditingController();
    _businessLandlineController = TextEditingController();
    _addressController = TextEditingController();
    _streetController = TextEditingController();
    _landmarkController = TextEditingController();
    _pincodeController = TextEditingController();
    _stateController = TextEditingController();
    _cityController = TextEditingController();
    _areaController = TextEditingController();

    _bindText(controller.p3FullName, _nameController);
    _bindText(controller.p3Email, _emailController);
    _bindText(controller.p3Mobile, _mobileController);
    _bindText(controller.p3WhatsApp, _whatsAppController);
    _bindText(controller.p3Landline, _landlineController);
    _bindText(controller.p3BusinessEmail, _businessEmailController);
    _bindText(controller.p3BusinessWhatsApp, _businessWhatsAppController);
    _bindText(controller.p3BusinessLandline, _businessLandlineController);
    _bindText(controller.p3Address, _addressController);
    _bindText(controller.p3StreetNo, _streetController);
    _bindText(controller.p3Landmark, _landmarkController);
    _bindText(controller.p3Pincode, _pincodeController);
    _bindText(controller.p3StateName, _stateController);
    _bindText(controller.p3CityName, _cityController);
    _workers.add(
      ever<AreaItemModel?>(
        controller.p3SelectedArea,
        (area) => _syncController(_areaController, area?.areaName ?? ''),
      ),
    );

    _syncController(_nameController, controller.p3FullName.value);
    _syncController(_emailController, controller.p3Email.value);
    _syncController(_mobileController, controller.p3Mobile.value);
    _syncController(_whatsAppController, controller.p3WhatsApp.value);
    _syncController(_landlineController, controller.p3Landline.value);
    _syncController(
      _businessEmailController,
      controller.p3BusinessEmail.value,
    );
    _syncController(
      _businessWhatsAppController,
      controller.p3BusinessWhatsApp.value,
    );
    _syncController(
      _businessLandlineController,
      controller.p3BusinessLandline.value,
    );
    _syncController(_addressController, controller.p3Address.value);
    _syncController(_streetController, controller.p3StreetNo.value);
    _syncController(_landmarkController, controller.p3Landmark.value);
    _syncController(_pincodeController, controller.p3Pincode.value);
    _syncController(_stateController, controller.p3StateName.value);
    _syncController(_cityController, controller.p3CityName.value);
    _syncController(
      _areaController,
      controller.p3SelectedArea.value?.areaName ?? '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initPage3Data();
    });
  }

  @override
  void dispose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _whatsAppController.dispose();
    _landlineController.dispose();
    _businessEmailController.dispose();
    _businessWhatsAppController.dispose();
    _businessLandlineController.dispose();
    _addressController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingContactInfo.value) {
        return SizedBox(
          height: 300.h,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              color: AppColors.primary,
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: controller.previousStage,
            icon: Icon(
              Icons.arrow_back_ios,
              size: 14.sp,
              color: AppColors.primary,
            ),
            label: Text(
              'Back',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          OnboardingSectionCard(
            title: 'Personal Information',
            titleIcon: Icon(
              Icons.person_outline,
              size: 16.sp,
              color: AppColors.primary,
            ),
            child: Column(
              children: [
                AppTextField(
                  controller: _nameController,
                  hint: 'Full Name',
                  onChanged: (value) => controller.p3FullName.value = value,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: _emailController,
                  hint: 'Email',
                  onChanged: (value) => controller.p3Email.value = value,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _mobileController,
                        hint: 'Mobile No.',
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => controller.p3Mobile.value = value,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppTextField(
                        controller: _whatsAppController,
                        hint: 'WhatsApp No.',
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => controller.p3WhatsApp.value = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: _landlineController,
                  hint: 'Landline (Optional)',
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => controller.p3Landline.value = value,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          OnboardingSectionCard(
            title: 'Business Information',
            titleIcon: Icon(
              Icons.business_center_outlined,
              size: 16.sp,
              color: AppColors.primary,
            ),
            child: Column(
              children: [
                AppTextField(
                  controller: _businessEmailController,
                  hint: 'Business Email',
                  onChanged: (value) => controller.p3BusinessEmail.value = value,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: _businessWhatsAppController,
                  hint: 'Business WhatsApp',
                  keyboardType: TextInputType.phone,
                  onChanged: (value) =>
                      controller.p3BusinessWhatsApp.value = value,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: _businessLandlineController,
                  hint: 'Business Landline (Optional)',
                  keyboardType: TextInputType.phone,
                  onChanged: (value) =>
                      controller.p3BusinessLandline.value = value,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          OnboardingSectionCard(
            title: 'Location Information',
            titleIcon: Icon(
              Icons.location_on_outlined,
              size: 16.sp,
              color: AppColors.primary,
            ),
            child: Column(
              children: [
                AppTextField(
                  controller: _addressController,
                  hint: 'Building/Shop No.',
                  onChanged: (value) => controller.p3Address.value = value,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: _streetController,
                  hint: 'Street Name',
                  onChanged: (value) => controller.p3StreetNo.value = value,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: _landmarkController,
                  hint: 'Landmark',
                  onChanged: (value) => controller.p3Landmark.value = value,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: _pincodeController,
                  hint: 'Pincode',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    controller.onPincodeChanged(value);
                  },
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _stateController,
                        hint: 'State',
                        readOnly: true,
                        suffixIcon: _loadingSuffix(),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppTextField(
                        controller: _cityController,
                        hint: 'City',
                        readOnly: true,
                        suffixIcon: _loadingSuffix(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: _showAreaPicker,
                  child: AbsorbPointer(
                    child: Obx(
                      () => AppTextField(
                        controller: _areaController,
                        hint: controller.p3AreaList.isEmpty
                            ? 'Enter pincode first'
                            : 'Select Area',
                        readOnly: true,
                        suffixIcon: controller.isLoadingAreas.value
                            ? SizedBox(
                                width: 14.w,
                                height: 14.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.w,
                                  color: AppColors.primary,
                                ),
                              )
                            : Icon(
                                Icons.keyboard_arrow_down,
                                size: 20.sp,
                                color: AppColors.textSecondaryLight,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Obx(
            () => PrimaryButton(
              label: 'SAVE & CONTINUE',
              isLoading: controller.isSavingContact.value,
              onPressed: controller.saveContactAndFinish,
            ),
          ),
          SizedBox(height: 16.h),
          const AuthFooterText(),
          SizedBox(height: 12.h),
        ],
      );
    });
  }

  Widget _loadingSuffix() {
    return Obx(
      () => controller.isLoadingAreas.value ||
              controller.isLoadingLocationDetails.value
          ? SizedBox(
              width: 14.w,
              height: 14.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                color: AppColors.primary,
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  void _showAreaPicker() {
    if (controller.p3AreaList.isEmpty) {
      return;
    }

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Select Area',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Divider(
              color: AppColors.borderLight,
              height: 0.h,
            ),
            Obx(
              () => ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.p3AreaList.length,
                  separatorBuilder: (_, __) => Divider(
                    color: AppColors.borderLight,
                    height: 0.h,
                  ),
                  itemBuilder: (_, i) {
                    final area = controller.p3AreaList[i];
                    return ListTile(
                      title: Text(
                        area.areaName,
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      trailing:
                          controller.p3SelectedArea.value?.areaId == area.areaId
                              ? Icon(
                                  Icons.check,
                                  color: AppColors.primary,
                                  size: 18.sp,
                                )
                              : null,
                      onTap: () {
                        controller.selectArea(area);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _bindText(RxString source, TextEditingController target) {
    _workers.add(
      ever<String>(source, (value) {
        _syncController(target, value);
      }),
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
