import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/app_overlay_loader.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/trusted_shield/controllers/trusted_shield_controller.dart';
import 'package:bizrato_owner/features/trusted_shield/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth/widgets/auth_footer_text.dart';

class TrustedShieldView extends GetView<TrustedShieldController> {
  const TrustedShieldView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Trusted Shield',
      useFloatingSurface: true,
      contentHorizontalMargin: 26,
      child: Obx(
        () => AppOverlayLoader(
          isVisible: controller.isBusy,
          message: controller.loaderMessage.value,
          child: RefreshIndicator(
            color: AppTokens.brandPrimary,
            onRefresh: () => controller.loadKycDetails(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _KycStatusBanner(),
                  SizedBox(height: 12.h),
                  if (controller.hasError.value) ...[
                    _InlineInfoCard(
                      title: 'Unable to load KYC details',
                      message: controller.errorMessage.value,
                      icon: Icons.error_outline_rounded,
                      color: AppTokens.error,
                    ),
                    SizedBox(height: 12.h),
                  ],
                  const BusinessCredentialsSection(),
                  SizedBox(height: 14.h),
                  const AadhaarVerificationSection(),
                  SizedBox(height: 14.h),
                  const LivenessCheckSection(),
                  SizedBox(height: 18.h),
                  PrimaryButton(
                    label: 'Confirm & Submit All',
                    isLoading: controller.isSubmitting.value,
                    onPressed: controller.submitAll,
                  ),
                  SizedBox(height: 18.h),
                  AuthFooterText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KycStatusBanner extends GetView<TrustedShieldController> {
  const _KycStatusBanner();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.kycStatus.value;
      final remarks = controller.adminRemarks.value.trim();
      final title = controller.hasExistingKyc.value
          ? 'Current KYC Status'
          : 'Complete Your Verification';
      final message = controller.hasExistingKyc.value
          ? controller.statusLabel(status)
          : 'Fill in the details below and upload the required documents.';

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppTokens.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppTokens.border, width: 1.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: controller.statusColor(status),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppTokens.textSecondary,
              ),
            ),
            if (remarks.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                'Admin remarks: $remarks',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppTokens.textPrimary,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _InlineInfoCard extends StatelessWidget {
  const _InlineInfoCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppTokens.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppTokens.border, width: 1.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: color),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
