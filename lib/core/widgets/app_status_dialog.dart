import 'dart:async';

import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppStatusDialog extends StatelessWidget {
  const AppStatusDialog._({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.borderColor,
  });

  factory AppStatusDialog.success({
    Key? key,
    required String message,
    String title = 'Success',
  }) {
    return AppStatusDialog._(
      key: key,
      title: title,
      message: message,
      icon: Icons.check_rounded,
      iconColor: AppTokens.brandPrimary,
      iconBackgroundColor: AppTokens.selectionBackground,
      borderColor: AppTokens.brandPrimary.withValues(alpha: 0.18),
    );
  }

  factory AppStatusDialog.error({
    Key? key,
    required String message,
    String title = 'Error',
  }) {
    return AppStatusDialog._(
      key: key,
      title: title,
      message: message,
      icon: Icons.close_rounded,
      iconColor: AppTokens.error,
      iconBackgroundColor: AppTokens.errorSurface,
      borderColor: AppTokens.errorBorder,
    );
  }

  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color borderColor;

  static Future<void> show({
    required AppStatusDialog dialog,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismissed,
  }) async {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    unawaited(
      Get.dialog<void>(
        dialog,
        barrierDismissible: false,
      ),
    );

    await Future<void>.delayed(duration);

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    onDismissed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppTokens.cardBackground,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppTokens.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.4,
                color: AppTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
