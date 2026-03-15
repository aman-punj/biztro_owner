import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:bizrato_owner/features/onboarding/controllers/onboarding_controller.dart';
import 'package:bizrato_owner/features/onboarding/widgets/business_information_stage.dart';
import 'package:bizrato_owner/features/onboarding/widgets/business_services_stage.dart';
import 'package:bizrato_owner/features/onboarding/widgets/onboarding_stage_indicator.dart';
import 'package:bizrato_owner/features/onboarding/widgets/personal_information_stage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontalPadding,
              vertical: 12.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppImage(path: AppAssets.appTextLogo, width: 86),
                    const Spacer(),
                    _ActionIcon(icon: Icons.notifications_none_outlined),
                    SizedBox(width: 8.w),
                    _ActionIcon(icon: Icons.logout),
                  ],
                ),
                SizedBox(height: 16.h),
                OnboardingStageIndicator(
                  stages: OnboardingController.stageTitles,
                  currentIndex: controller.stageIndex,
                ),
                SizedBox(height: 24.h),
                Text(
                  _titleByIndex(controller.stageIndex),
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  _subtitleByIndex(controller.stageIndex),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                SizedBox(height: 16.h),
                if (controller.stageIndex == 0) BusinessInformationStage(),
                if (controller.stageIndex == 1) const BusinessServicesStage(),
                if (controller.stageIndex == 2) const PersonalInformationStage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _titleByIndex(int index) {
    switch (index) {
      case 0:
        return 'Business Information';
      case 1:
        return 'Business Services';
      default:
        return 'Personal Information';
    }
  }

  String _subtitleByIndex(int index) {
    switch (index) {
      case 0:
        return 'Update your shop details to get verified';
      case 1:
        return 'Step 2: Define your core offerings and facilities';
      default:
        return 'Enter your personal and business contact details';
    }
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, size: 14.sp, color: AppColors.error),
    );
  }
}
