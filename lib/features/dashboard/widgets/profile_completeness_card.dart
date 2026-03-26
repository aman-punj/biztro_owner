import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfileCompletenessCard extends GetView<DashboardController> {
  const ProfileCompletenessCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.profileCardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(color: AppColors.profileCardBorder, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Obx(
          () => Row(
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
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Add Photos to Boost Visibility',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondaryLight,
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
                    color: AppColors.profileIndicator,
                  ),
                ),
                progressColor: AppColors.profileIndicator,
                backgroundColor: AppColors.profileCardBackground,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
