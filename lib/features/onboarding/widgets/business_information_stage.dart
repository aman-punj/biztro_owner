import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_footer_text.dart';
import 'package:bizrato_owner/features/onboarding/controllers/onboarding_controller.dart';
import 'package:bizrato_owner/features/onboarding/widgets/onboarding_option_tile.dart';
import 'package:bizrato_owner/features/onboarding/widgets/onboarding_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BusinessInformationStage extends GetView<OnboardingController> {
  const BusinessInformationStage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text('Business Information', style: Theme.of(context).textTheme.titleMedium),
        // SizedBox(height: 4.h),
        // Text(
        //   'Update your shop details to get verified.',
        //   style: Theme.of(context).textTheme.bodyMedium,
        // ),
        SizedBox(height: 14.h),
        OnboardingSectionCard(
          title: 'BUSINESS PROFILE',
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondaryLight.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.storefront, color: AppColors.textSecondaryLight, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shekhawati',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Id Verification Pending',
                        style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondaryLight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        OnboardingSectionCard(
          title: 'SEARCH YOUR BUSINESS CATEGORY',
          child: Column(
            children: [
              AppTextField(
                hint: 'e.g. Sweets, Restaurant...',
                prefixIcon: Icon(Icons.search, size: 20.sp, color: AppColors.textSecondaryLight),
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Icon(Icons.description_outlined,
                        color: AppColors.textSecondaryLight.withOpacity(0.5), size: 32.sp),
                    SizedBox(height: 12.h),
                    Text(
                      'Please select a category above\nto see suggested keywords.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondaryLight,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        OnboardingSectionCard(
          title: 'SUGGESTED KEYWORDS',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('QUALITY BASED',
                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight)),
              SizedBox(height: 12.h),
              ...OnboardingController.quantityTags.map(
                (String option) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: OnboardingOptionTile(
                    label: option,
                    isSelected: controller.selectedQuantityTag.value == option,
                    onTap: () => controller.selectQuantityTag(option),
                    multiSelect: true,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text('SERVICE BASED',
                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight)),
              SizedBox(height: 12.h),
              ...OnboardingController.serviceCategories.map(
                (String option) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: OnboardingOptionTile(
                    label: option,
                    isSelected: controller.selectedServiceCategory.value == option,
                    onTap: () => controller.selectServiceCategory(option),
                    multiSelect: true,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text('ADD YOUR OWN',
                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight)),
              SizedBox(height: 8.h),
              Obx(() => Column(
                    children: [
                      ...controller.customKeywords.map((keyword) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: AppTextField(
                              hint: 'Keyword',
                              initialValue: keyword,
                              readOnly: true,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.delete_outline, color: AppColors.error.withOpacity(0.5), size: 20.sp),
                                onPressed: () => controller.removeCustomKeyword(keyword),
                              ),
                            ),
                          )),
                      AppTextField(
                        hint: 'Enter keyword...',
                        onSubmitted: (val) => controller.addCustomKeyword(val),
                      ),
                    ],
                  )),
              SizedBox(height: 12.h),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45.h),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                icon: Icon(Icons.add_circle_outline, size: 18.sp),
                label: const Text('Add Another Keyword'),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        PrimaryButton(label: 'SAVE & CONTINUE', onPressed: controller.nextStage),
        SizedBox(height: 16.h),
        AuthFooterText(),
        SizedBox(height: 10.h),
      ],
    );
  }
}
