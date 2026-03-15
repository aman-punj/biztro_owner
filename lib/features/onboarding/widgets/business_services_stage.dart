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

class BusinessServicesStage extends GetView<OnboardingController> {
  const BusinessServicesStage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingSectionCard(
            title: 'BUSINESS SERVICES',
            child: Column(
              children: [
                AppTextField(
                  hint: 'Business Name',
                  initialValue: 'Shekhawati',
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  hint: 'Website/Optional',
                  initialValue: 'www.abc.com',
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  hint: 'Famous For',
                  initialValue: 'Wedding',
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  hint: 'Establishment Year',
                  initialValue: '2000',
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          OnboardingSectionCard(
            title: 'Services Offered',
            child: Column(
              children: OnboardingController.servicesOffered
                  .map(
                    (String option) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: OnboardingOptionTile(
                        label: option,
                        multiSelect: true,
                        isSelected: controller.selectedServices.contains(option),
                        onTap: () => controller.toggleService(option),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 16.h),
          OnboardingSectionCard(
            title: 'Facilities',
            child: Column(
              children: OnboardingController.facilities
                  .map(
                    (String option) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: OnboardingOptionTile(
                        label: option,
                        multiSelect: true,
                        isSelected: controller.selectedFacilities.contains(option),
                        onTap: () => controller.toggleFacility(option),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 24.h),
          PrimaryButton(
            label: 'SAVE & CONTINUE',
            onPressed: controller.nextStage,
          ),
          SizedBox(height: 16.h),
          AuthFooterText(),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
