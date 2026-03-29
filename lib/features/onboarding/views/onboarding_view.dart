import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:bizrato_owner/features/auth/services/logout_service.dart';
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        controller.handleBackPress();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const AppImage(path: AppAssets.appTextLogo, width: 86),
                        const Spacer(),
                        _ActionIcon(
                          icon: AppAssets.youtubeRedIcon,
                          onTap: () {},
                        ),
                        SizedBox(width: 8.w),
                        _ActionIcon(
                          icon: AppAssets.logoutRedIcon,
                          onTap: () async {
                            await Get.find<LogoutService>().logout();
                          },
                        ),
                      ],
                    ),
                    Obx(
                      () => OnboardingStageIndicator(
                        stages: OnboardingController.stageTitles,
                        currentIndex: controller.stageIndex,
                        onStageTap: controller.goToStageIfAllowed,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Obx(
                      () => Text(
                        _titleByIndex(controller.stageIndex),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        _subtitleByIndex(controller.stageIndex),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontalPadding,
                  ),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        if (controller.stageIndex == 0)
                          BusinessInformationStage(),
                        if (controller.stageIndex == 1)
                          const BusinessServicesStage(),
                        if (controller.stageIndex == 2)
                          const PersonalInformationStage(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
  const _ActionIcon({required this.icon, required this.onTap});

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: AppColors.errorSurfaceLight,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.errorBorderLight),
        ),
        child: AppImage(
          path: icon,
          height: 14,
          width: 14,
          fit: BoxFit.contain,
          color: AppColors.error,
        ),
      ),
    );
  }
}
