import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_footer_text.dart';
import 'package:bizrato_owner/features/onboarding/controllers/onboarding_controller.dart';
import 'package:bizrato_owner/features/onboarding/widgets/onboarding_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonalInformationStage extends GetView<OnboardingController> {
  const PersonalInformationStage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingSectionCard(
          title: 'Personal Information',
          titleIcon:
              Icon(Icons.person_outline, size: 16.sp, color: AppColors.primary),
          child: Column(
            children: [
              const AppTextField(hint: 'Full Name', initialValue: 'Aslam Khan'),
              SizedBox(height: 12.h),
              const AppTextField(
                  hint: 'Email', initialValue: 'aslamulux@gmail.com'),
              SizedBox(height: 12.h),
              Row(
                children: [
                  const Expanded(
                      child: AppTextField(
                          hint: 'Mobile No.', initialValue: '7014995713')),
                  SizedBox(width: 12.w),
                  const Expanded(
                      child: AppTextField(
                          hint: 'WhatsApp No.', initialValue: '7014995713')),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        OnboardingSectionCard(
          title: 'Business Information',
          titleIcon: Icon(Icons.business_center_outlined,
              size: 16.sp, color: AppColors.primary),
          child: Column(
            children: [
              const AppTextField(
                  hint: 'Business Email', initialValue: 'aslamulux@gmail.com'),
              SizedBox(height: 12.h),
              const AppTextField(
                  hint: 'Business WhatsApp', initialValue: '6079028676'),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        OnboardingSectionCard(
          title: 'Location Information',
          titleIcon: Icon(Icons.location_on_outlined,
              size: 16.sp, color: AppColors.primary),
          child: Column(
            children: [
              const AppTextField(
                  hint: 'Building/Shop No.',
                  initialValue: '4B/23, 1st Floor, Main Road'),
              SizedBox(height: 12.h),
              const AppTextField(
                  hint: 'Street Name', initialValue: 'Tilak Nagar'),
              SizedBox(height: 12.h),
              const AppTextField(hint: 'Landmark', initialValue: 'Tilak Nagar'),
              SizedBox(height: 12.h),
              Row(
                children: [
                  const Expanded(
                      child: AppTextField(
                          hint: 'Pincode', initialValue: '110018')),
                  SizedBox(width: 12.w),
                  const Expanded(
                      child: AppTextField(hint: 'City', initialValue: 'Delhi')),
                ],
              ),
              SizedBox(height: 12.h),
              AppTextField(
                hint: 'Select Area',
                initialValue: 'CHAND NAGAR',
                suffixIcon: Icon(Icons.keyboard_arrow_down,
                    size: 20.sp, color: AppColors.textSecondaryLight),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        PrimaryButton(
          label: 'SAVE & CONTINUE',
          onPressed: () {
            // Static movement: loop back to first stage for demo
            controller.goToStage(0);
          },
        ),
        SizedBox(height: 16.h),
        AuthFooterText(),
        SizedBox(height: 12.h),
      ],
    );
  }
}
