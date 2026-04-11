import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfileCompletenessCard extends GetView<DashboardController> {
  const ProfileCompletenessCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.shouldShowProfileCompletion) {
        return const SizedBox.shrink();
      }

      return GestureDetector(
        onTap: controller.openProfileCompletion,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: AppTokens.profileBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            side: BorderSide(color: AppTokens.profileBorder, width: 1.w),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile ${controller.profileCompletionLabel.value} Complete',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTokens.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        controller.profileCompletionSubtitle,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                CircularPercentIndicator(
                  radius: 28.r,
                  lineWidth: 5.w,
                  percent: controller.profileCompletionPercent.value,
                  center: Text(
                    controller.profileCompletionLabel.value,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: AppTokens.brandAccent,
                    ),
                  ),
                  progressColor: AppTokens.brandAccent,
                  backgroundColor: AppTokens.profileBackground,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
