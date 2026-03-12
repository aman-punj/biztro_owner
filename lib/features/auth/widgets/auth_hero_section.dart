import 'package:biztro_owner/core/theme/colors.dart';
import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:biztro_owner/features/auth/widgets/auth_brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AuthHeroSection extends GetView<AuthController> {
  const AuthHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 34.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      child: Obx(
        () => Column(
          children: [
            const AuthBrandLogo(),
            SizedBox(height: 10.h),
            Text(
              controller.stageTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.cardLight,
                fontSize: 34.sp,
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
                fontSize: 9.5.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
