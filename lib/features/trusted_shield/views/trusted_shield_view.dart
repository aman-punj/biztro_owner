import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/trusted_shield/controllers/trusted_shield_controller.dart';
import 'package:bizrato_owner/features/trusted_shield/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TrustedShieldView extends GetView<TrustedShieldController> {
  const TrustedShieldView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.screenBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sp,
            color: AppTokens.white,
          ),
        ),
        backgroundColor: AppTokens.brandPrimary,
        centerTitle: true,
        elevation: 0,
        title: Column(
          children: [
            Text(
              'Trusted Shield',
              style: TextStyle(
                color: AppTokens.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Verify identity to unlock pro features',
              style: TextStyle(
                color: AppTokens.white.withValues(alpha: 0.8),
                fontSize: 9.sp,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress steps indicator
            _KycStepIndicator(),
            SizedBox(height: 20.h),

            // Business Credentials
            const BusinessCredentialsSection(),
            SizedBox(height: 14.h),

            // Aadhaar Verification
            const AadhaarVerificationSection(),
            SizedBox(height: 14.h),

            // Liveness Check
            const LivenessCheckSection(),
            SizedBox(height: 24.h),

            // Footer brand text
            Center(
              child: Text(
                '© 2026 Bizrato Biz Concepts Pvt. Ltd.',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: AppTokens.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _SubmitBar(),
    );
  }
}

// ── Sticky Submit Button ──────────────────────────────────────────────────────

class _SubmitBar extends GetView<TrustedShieldController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: AppTokens.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(
        () => PrimaryButton(
          label: 'Confirm & Submit All',
          isLoading: controller.isSubmitting.value,
          onPressed: controller.submitAll,
        ),
      ),
    );
  }
}

// ── Step progress row ─────────────────────────────────────────────────────────

class _KycStepIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Step(number: 1, label: 'Business\nCredentials', active: true),
        _StepDivider(),
        _Step(number: 2, label: 'Aadhaar\nVerification', active: true),
        _StepDivider(),
        _Step(number: 3, label: 'Liveness\nCheck', active: false),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.label,
    required this.active,
  });
  final int number;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppTokens.brandPrimary : AppTokens.border,
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: TextStyle(
              color: active ? AppTokens.white : AppTokens.textSecondary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 8.sp,
            color: active ? AppTokens.brandPrimary : AppTokens.textSecondary,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: EdgeInsets.only(bottom: 20.h),
        color: AppTokens.border,
      ),
    );
  }
}
