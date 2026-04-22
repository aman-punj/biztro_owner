import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/app_page_shell.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/core/widgets/secondary_button.dart';
import 'package:bizrato_owner/features/advertisement/controllers/post_advertisement_controller.dart';
import 'package:bizrato_owner/features/advertisement/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PostAdvertisementView extends GetView<PostAdvertisementController> {
  const PostAdvertisementView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Post New Advertisement',
      onBack: controller.previousStep,
      useFloatingSurface: false,
      child: Container(
        color: AppTokens.cardBackground,
        child: Obx(
          () {
            if (controller.isLoadingPage.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                StepIndicator(
                  totalSteps: PostAdvertisementController.totalSteps,
                  currentStep: controller.currentStep.value,
                ),
                Expanded(
                  child: IndexedStack(
                    index: controller.currentStep.value,
                    children: [
                      _buildLocationStep(),
                      _buildFormatStep(),
                      _buildTargetLocationStep(),
                      _buildCategoryStep(),
                      _buildUploadStep(),
                    ],
                  ),
                ),
                _buildBottomActions(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLocationStep() {
    return _StepScrollView(
      title: 'Select Ad Location',
      subtitle: 'Choose Where do you want to display your ad',
      child: Column(
        children: controller.locations
            .map(
              (location) => OptionSelectionCard(
                item: location,
                title: location.name,
                subtitle: location.subtitle.isEmpty ? null : location.subtitle,
                iconPath: location.iconPath,
                isSelected: controller.selectedLocation.value?.id == location.id,
                onTap: () => controller.selectLocation(location),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFormatStep() {
    return _StepScrollView(
      title: 'Ad Format',
      subtitle: 'Select the visual size of your ad',
      child: Column(
        children: controller.formats
            .map(
              (format) => OptionSelectionCard(
                item: format,
                title: format.name,
                subtitle: format.description.isEmpty ? null : format.description,
                leadingText: format.leadingText,
                iconPath: format.iconPath,
                isSelected: controller.selectedFormat.value?.id == format.id,
                onTap: () => controller.selectFormat(format),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTargetLocationStep() {
    final isMultiple = controller.locationType.value == 'Multiple';

    return _StepScrollView(
      title: 'Target Location',
      subtitle: 'Pick the state where you want to show your ad',
      child: Column(
        children: [
          _buildModeSelector(
            selectedValue: controller.locationType.value,
            onChanged: controller.setLocationType,
          ),
          SizedBox(height: 18.h),
          ...controller.states.map(
            (state) => SelectionCheckbox(
              label: state.name,
              isMultiSelect: isMultiple,
              isSelected:
                  controller.selectedStates.any((item) => item.id == state.id),
              onTap: () => controller.toggleState(state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryStep() {
    final isMultiple = controller.categoryType.value == 'Multiple';

    return _StepScrollView(
      title: 'Select categories',
      subtitle: 'Specific business categories',
      child: Column(
        children: [
          _buildModeSelector(
            selectedValue: controller.categoryType.value,
            onChanged: controller.setCategoryType,
          ),
          SizedBox(height: 18.h),
          ...controller.categories.map(
            (category) => SelectionCheckbox(
              label: category.name,
              isMultiSelect: isMultiple,
              isSelected: controller.selectedCategories
                  .any((item) => item.value == category.value),
              onTap: () => controller.toggleCategory(category),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadStep() {
    return _StepScrollView(
      title: 'Upload Creative',
      subtitle: 'Upload high-quality JPG or PNG images here',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImagePickerWidget(
            imagePath: controller.selectedImage.value?.path,
            onTap: controller.pickImage,
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppTokens.surface,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppTokens.border, width: 1.w),
            ),
            child: Text(
              'Recommended size: 1080 by 450 pixels. Formats: JPG or PNG.',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTokens.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector({
    required String selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: _ModeOption(
            label: 'Single',
            isSelected: selectedValue == 'Single',
            onTap: () => onChanged('Single'),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _ModeOption(
            label: 'Multiple',
            isSelected: selectedValue == 'Multiple',
            onTap: () => onChanged('Multiple'),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: 'Back',
                onPressed: controller.previousStep,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: PrimaryButton(
                label: controller.primaryButtonLabel,
                isLoading: controller.isSaving.value,
                onPressed: controller.handlePrimaryAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepScrollView extends StatelessWidget {
  const _StepScrollView({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppTokens.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTokens.textSecondary,
            ),
          ),
          SizedBox(height: 22.h),
          child,
        ],
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTokens.selectionBackground : AppTokens.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppTokens.brandPrimary : AppTokens.border,
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 18.sp,
              color: isSelected ? AppTokens.brandPrimary : AppTokens.textSecondary,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppTokens.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
