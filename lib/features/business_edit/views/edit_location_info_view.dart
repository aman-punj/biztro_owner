import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/business_edit/controllers/edit_location_info_controller.dart';
import 'package:bizrato_owner/features/onboarding/data/models/area_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditLocationInfoView extends StatefulWidget {
  const EditLocationInfoView({super.key});

  @override
  State<EditLocationInfoView> createState() => _EditLocationInfoViewState();
}

class _EditLocationInfoViewState extends State<EditLocationInfoView> {
  final EditLocationInfoController controller =
      Get.find<EditLocationInfoController>();

  late final TextEditingController _addressController;
  late final TextEditingController _streetController;
  late final TextEditingController _landmarkController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _stateController;
  late final TextEditingController _cityController;
  late final TextEditingController _areaController;
  late final TextEditingController _otherAreaController;

  final List<Worker> _workers = <Worker>[];

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: controller.address.value);
    _streetController = TextEditingController(text: controller.streetNo.value);
    _landmarkController =
        TextEditingController(text: controller.landmark.value);
    _pincodeController = TextEditingController(text: controller.pincode.value);
    _stateController = TextEditingController(text: controller.stateName.value);
    _cityController = TextEditingController(text: controller.cityName.value);
    _areaController = TextEditingController(
      text: controller.selectedArea.value?.areaName ?? '',
    );
    _otherAreaController =
        TextEditingController(text: controller.otherAreaName.value);

    _workers.addAll([
      ever<String>(controller.address,
          (value) => _syncController(_addressController, value)),
      ever<String>(controller.streetNo,
          (value) => _syncController(_streetController, value)),
      ever<String>(controller.landmark,
          (value) => _syncController(_landmarkController, value)),
      ever<String>(controller.pincode,
          (value) => _syncController(_pincodeController, value)),
      ever<String>(controller.stateName,
          (value) => _syncController(_stateController, value)),
      ever<String>(controller.cityName,
          (value) => _syncController(_cityController, value)),
      ever<AreaItemModel?>(controller.selectedArea,
          (area) => _syncController(_areaController, area?.areaName ?? '')),
      ever<String>(controller.otherAreaName,
          (value) => _syncController(_otherAreaController, value)),
    ]);
  }

  @override
  void dispose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    _addressController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _otherAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Location Information',
      child: Obx(
        () {
          if (controller.isLoadingPage.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                OnboardingSectionCard(
                  title: 'Location Information',
                  titleIcon: Icon(
                    Icons.add_location_rounded,
                    size: 18.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppTokens.textPrimaryInverse
                        : AppTokens.brandPrimary,
                  ),
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _addressController,
                        title: 'Building / Shop No.',
                        onChanged: (value) => controller.address.value = value,
                      ),
                      SizedBox(height: 12.h),
                      AppTextField(
                        controller: _streetController,
                        title: 'Street Name',
                        onChanged: (value) => controller.streetNo.value = value,
                      ),
                      SizedBox(height: 12.h),
                      AppTextField(
                        controller: _landmarkController,
                        title: 'Landmark',
                        onChanged: (value) => controller.landmark.value = value,
                      ),
                      SizedBox(height: 12.h),
                      AppTextField(
                        controller: _pincodeController,
                        title: 'Pincode',
                        keyboardType: TextInputType.number,
                        onChanged: controller.onPincodeChanged,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _stateController,
                              title: 'State',
                              readOnly: true,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: AppTextField(
                              controller: _cityController,
                              title: 'City',
                              readOnly: true,
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
                              title: controller.areaList.isEmpty
                                  ? 'Enter pincode first'
                                  : 'Select Area',
                              readOnly: true,
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 20.sp,
                                color: AppTokens.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => controller.isOtherAreaSelected
                            ? Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: AppTextField(
                                  controller: _otherAreaController,
                                  title: 'Enter Area Name',
                                  onChanged: (value) =>
                                      controller.otherAreaName.value = value,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => PrimaryButton(
                    label: 'SAVE & CONTINUE',
                    isLoading: controller.isSaving.value,
                    onPressed: controller.saveAndUpdate,
                  ),
                ),
                  ],
                ),
              ),
              Obx(
                () {
                  final isLoading = controller.isLoadingLocationDetails.value ||
                      controller.isLoadingAreas.value;
                  if (!isLoading) {
                    return const SizedBox.shrink();
                  }
                  return Positioned.fill(
                    child: Container(
                      color: AppTokens.white.withValues(alpha: 0.75),
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        color: AppTokens.brandPrimary,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAreaPicker() {
    FocusScope.of(context).unfocus();
    if (controller.areaList.isEmpty) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTokens.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: Text(
                  'Select Area',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...controller.areaList.map(
                (area) => ListTile(
                  title: Text(area.areaName),
                  subtitle: Text(area.pinCode),
                  onTap: () {
                    controller.selectArea(area);
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        );
      },
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
