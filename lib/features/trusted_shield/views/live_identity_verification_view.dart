import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_logo_section.dart';
import 'package:bizrato_owner/features/trusted_shield/controllers/live_identity_verification_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/colors.dart';
import '../../auth/widgets/auth_brand_logo.dart';

class LiveIdentityVerificationView
    extends GetView<LiveIdentityVerificationController> {
  const LiveIdentityVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // AppTokens.white,
              AppTokens.brandPrimary,
              AppTokens.brandPrimary.withOpacity(0.85),
              // AppTokens.white,
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            final activeCamera = controller.cameraController.value;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
                  child: Row(
                    children: [
                      _TopIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: Get.back,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius:
                                BorderRadius.circular(AppDimensions.cardRadius / 2),
                              ),
                              child: const AuthBrandLogo(),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Live Identity Verification',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: AppTokens.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Center your face and capture a clear selfie',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppTokens.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 38.w),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: AppTokens.brandPrimary.withOpacity(0.6),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                              AppTokens.brandPrimary.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: controller.isReady && activeCamera != null
                              ? CameraPreview(activeCamera)
                              : AspectRatio(
                            aspectRatio: 3 / 4,
                            child: _CameraFallback(
                              isLoading:
                              controller.isInitializing.value,
                              message:
                              controller.errorMessage.value,
                              onRetry:
                              controller.retryInitialization,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding:
                  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius:
                          BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18.sp,
                              color: Colors.white70,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                'Use your real face only. Avoid masks, hats or low light.',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),
                      PrimaryButton(
                        label: controller.isCapturing.value
                            ? 'Capturing...'
                            : 'Capture Live Verification',
                        isLoading: controller.isCapturing.value,
                        onPressed: controller.isReady
                            ? controller.captureImage
                            : controller.retryInitialization,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _CameraFallback extends StatelessWidget {
  const _CameraFallback({
    required this.isLoading,
    required this.message,
    required this.onRetry,
  });

  final bool isLoading;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24.w,
              height: 24.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                color: AppTokens.brandPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Starting camera...',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTokens.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 42.sp,
              color: AppTokens.textSecondary,
            ),
            SizedBox(height: 12.h),
            Text(
              message.isEmpty
                  ? 'Unable to start live verification camera.'
                  : message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppTokens.textPrimary,
              ),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: 150.w,
              child: OutlinedButton(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppTokens.brandPrimary,
                    width: 1.w,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.brandPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}