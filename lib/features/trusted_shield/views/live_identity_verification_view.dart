import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/features/trusted_shield/controllers/live_identity_verification_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LiveIdentityVerificationView
    extends GetView<LiveIdentityVerificationController> {
  const LiveIdentityVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.textPrimary,
      body: SafeArea(
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
                          AppImage(
                            path: AppAssets.appTextLogo,
                            width: 132.w,
                            height: 28.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Bizrato',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppTokens.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Live Identity Verification (Mandatory)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w800,
                              color: AppTokens.white,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Center your face clearly in frame and capture a fresh selfie.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppTokens.white.withValues(alpha: 0.82),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: Container(
                      width: double.infinity,
                      color: AppTokens.livenessBackground,
                      child: controller.isReady && activeCamera != null
                          ? FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: 1.sw,
                                height: 1.sw / controller.previewAspectRatio,
                                child: CameraPreview(activeCamera),
                              ),
                            )
                          : _CameraFallback(
                              isLoading: controller.isInitializing.value,
                              message: controller.errorMessage.value,
                              onRetry: controller.retryInitialization,
                            ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTokens.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppTokens.white.withValues(alpha: 0.12),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            size: 18.sp,
                            color: AppTokens.white,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              'Use your real face only. Hats, masks, and low light may cause verification issues.',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppTokens.white.withValues(alpha: 0.86),
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
                    borderRadius: BorderRadius.circular(12.r),
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: AppTokens.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: AppTokens.white,
        ),
      ),
    );
  }
}
