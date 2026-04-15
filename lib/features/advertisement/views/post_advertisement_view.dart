import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/secondary_button.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
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
      child: Obx(
        () {
          if (controller.isLoadingPage.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              StepIndicator(
                totalSteps: 5,
                currentStep: controller.currentStep.value,
              ),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: PageController(
                    initialPage: controller.currentStep.value,
                  ),
                  onPageChanged: (index) =>
                      controller.currentStep.value = index,
                  children: [
                    _buildStep1(context),
                    _buildStep2(context),
                    _buildStep3(context),
                    _buildStep4(context),
                    _buildStep5(context),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: Row(
                    children: [
                      if (controller.currentStep.value > 0)
                        Expanded(
                          child: SecondaryButton(
                            label: 'BACK',
                            onPressed: controller.previousStep,
                          ),
                        ),
                      if (controller.currentStep.value > 0)
                        SizedBox(width: 12.w),
                      Expanded(
                        child: PrimaryButton(
                          label: controller.currentStep.value == 4
                              ? 'SUBMIT AD'
                              : 'CONTINUE',
                          isLoading: controller.isSaving.value,
                          onPressed: () {
                            if (controller.currentStep.value == 0 &&
                                !controller.isStep1Complete) {
                              _showValidationError(
                                  'Please complete all selections');
                              return;
                            }
                            if (controller.currentStep.value == 1 &&
                                !controller.isStep2Complete) {
                              _showValidationError('Please select a category');
                              return;
                            }
                            if (controller.currentStep.value == 2 &&
                                !controller.isStep3Complete) {
                              _showValidationError('Please select a state');
                              return;
                            }
                            if (controller.currentStep.value == 3 &&
                                !controller.isStep4Complete) {
                              _showValidationError('Please select an image');
                              return;
                            }

                            if (controller.currentStep.value == 4) {
                              controller.submitAdvertisement();
                            } else {
                              controller.nextStep();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStep1(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Select Ad Location'),
          SizedBox(height: 12.h),
          _buildSectionDescription(
              'Choose where your ad will be displayed on the app.'),
          SizedBox(height: 16.h),
          Obx(
            () => Column(
              children: controller.locations
                  .map(
                    (location) => OptionSelectionCard(
                      item: location,
                      title: location.name,
                      isSelected:
                          controller.selectedLocation.value?.id == location.id,
                      onTap: () => controller.selectLocation(location),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle('Ad Format'),
          SizedBox(height: 12.h),
          _buildSectionDescription('Select the format of your advertisement.'),
          SizedBox(height: 16.h),
          Obx(
            () => Column(
              children: controller.formats
                  .map(
                    (format) => OptionSelectionCard(
                      item: format,
                      title: format.name,
                      subtitle: format.description,
                      isSelected:
                          controller.selectedFormat.value?.id == format.id,
                      onTap: () => controller.selectFormat(format),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle('Select Operation Mode'),
          SizedBox(height: 12.h),
          _buildSectionDescription('Choose how to target locations.'),
          SizedBox(height: 16.h),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildModeButton(
                    'Single State',
                    controller.locationType.value == 'Single',
                    () => controller.setLocationType('Single'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildModeButton(
                    'Multiple States',
                    controller.locationType.value == 'Multiple',
                    () => controller.setLocationType('Multiple'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Select Category Type'),
          SizedBox(height: 12.h),
          _buildSectionDescription('Choose how you want to select categories.'),
          SizedBox(height: 16.h),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildModeButton(
                    'Single Category',
                    controller.categoryType.value == 'Single',
                    () => controller.setCategoryType('Single'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildModeButton(
                    'Multiple Categories',
                    controller.categoryType.value == 'Multiple',
                    () => controller.setCategoryType('Multiple'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle('Select Business Category'),
          SizedBox(height: 12.h),
          _buildSectionDescription(
              'Pick the category that matches your business.'),
          SizedBox(height: 16.h),
          Obx(
            () => Column(
              children: controller.categories
                  .map(
                    (category) => SelectionCheckbox(
                      label: category.name,
                      isSelected: controller.selectedCategories
                          .any((c) => c.id == category.id),
                      onTap: () => controller.toggleCategory(category),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Choose State(s)'),
          SizedBox(height: 12.h),
          _buildSectionDescription(
            controller.locationType.value == 'Single'
                ? 'Select one state where you want to display your ad.'
                : 'Select one or more states for your ad.',
          ),
          SizedBox(height: 16.h),
          Obx(
            () => Column(
              children: controller.states
                  .map(
                    (state) => SelectionCheckbox(
                      label: state.name,
                      isSelected: controller.selectedStates
                          .any((s) => s.id == state.id),
                      onTap: () => controller.toggleState(state),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Upload Creative'),
          SizedBox(height: 12.h),
          _buildSectionDescription('Upload high-quality JPG or PNG images.'),
          SizedBox(height: 24.h),
          Obx(
            () => ImagePickerWidget(
              imagePath: controller.selectedImage.value?.path,
              onTap: controller.pickImage,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppTokens.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Image Guidelines:',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildGuidelineItem('Recommended size: 1080x720 px'),
                _buildGuidelineItem('Formats: JPG, PNG'),
                _buildGuidelineItem('Max file size: 5 MB'),
                _buildGuidelineItem('Avoid cropped or blurry images'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep5(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Review Advertisement'),
          SizedBox(height: 12.h),
          _buildSectionDescription('Verify your ad details before submission.'),
          SizedBox(height: 24.h),
          _buildReviewCard(
            'Ad Location',
            controller.selectedLocation.value?.name ?? 'Not selected',
          ),
          SizedBox(height: 12.h),
          _buildReviewCard(
            'Ad Format',
            controller.selectedFormat.value?.name ?? 'Not selected',
          ),
          SizedBox(height: 12.h),
          _buildReviewCard(
            'States',
            controller.getSelectedStateText(),
          ),
          SizedBox(height: 12.h),
          _buildReviewCard(
            'Categories',
            controller.getSelectedCategoryText(),
          ),
          SizedBox(height: 24.h),
          Obx(
            () => controller.selectedImage.value != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      controller.selectedImage.value!,
                      height: 250.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 250.h,
                    decoration: BoxDecoration(
                      color: AppTokens.surface,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 48.sp,
                        color: AppTokens.textSecondary,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppTokens.textPrimary,
      ),
    );
  }

  Widget _buildSectionDescription(String description) {
    return Text(
      description,
      style: TextStyle(
        fontSize: 13.sp,
        color: AppTokens.textSecondary,
      ),
    );
  }

  Widget _buildModeButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isActive ? AppTokens.brandPrimary : AppTokens.surface,
          border: Border.all(
            color: isActive ? AppTokens.brandPrimary : AppTokens.border,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isActive ? AppTokens.white : AppTokens.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTokens.textSecondary,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
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

  Widget _buildReviewCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppTokens.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTokens.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppTokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showValidationError(String message) {
    Get.snackbar(
      'Validation Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTokens.error,
      colorText: AppTokens.white,
      duration: const Duration(seconds: 2),
    );
  }
}
