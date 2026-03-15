import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/features/auth/controllers/auth_controller.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AuthHeroSection extends GetView<AuthController> {
  const AuthHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Get.height  / 2.5,
      padding: EdgeInsets.fromLTRB(20.w, 54.h, 20.w, 34.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Obx(
        () => Column(
          children: [
            Container(
              decoration: BoxDecoration(
              color: AppColors.white,
                borderRadius: BorderRadius.circular(7)
              ),
              child: const AuthBrandLogo(),
            ),
            SizedBox(height: 15.h),
            Text(
              controller.stageTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.cardLight,
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              controller.stageSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.cardLight,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
