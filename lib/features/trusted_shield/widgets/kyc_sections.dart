import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/trusted_shield/controllers/trusted_shield_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BusinessCredentialsSection extends GetView<TrustedShieldController> {
  const BusinessCredentialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _KycCard(
      title: 'Business Credentials',
      subtitle: 'Official business registration documents',
      helpAction: TextButton(
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Help',
                style: TextStyle(fontSize: 10.sp, color: AppTokens.brandPrimary)),
            SizedBox(width: 2.w),
            Icon(Icons.help_outline, size: 12.sp, color: AppTokens.info),
          ],
        ),
      ),
      children: [
        AppTextField(
          title: 'Legal Business Name',
          onChanged: controller.onBusinessNameChanged,
        ),
        SizedBox(height: 10.h),
        AppTextField(
          title: 'GST Number (Optional)',
          onChanged: controller.onGstNumberChanged,
        ),
        SizedBox(height: 12.h),
        // GST certificate upload
        Obx(
          () => _UploadBlock(
            label: 'Upload GST Certificate',
            subLabel: 'File should be max 2mb in size',
            fileName: controller.gstFileName.value,
            icon: Icons.upload_file_outlined,
            onTap: controller.pickGstCertificate,
          ),
        ),
        SizedBox(height: 10.h),
        AppTextField(
          title: 'Pan Number',
          onChanged: controller.onPanNumberChanged,
        ),
        SizedBox(height: 12.h),
        // Firm card upload
        Obx(
          () => _UploadBlock(
            label: 'Upload Firm Card Copy',
            subLabel: '',
            fileName: controller.firmCardFileName.value,
            icon: Icons.credit_card_outlined,
            onTap: controller.pickFirmCard,
          ),
        ),
      ],
    );
  }
}

// ── Aadhaar Verification ──────────────────────────────────────────────────────

class AadhaarVerificationSection extends GetView<TrustedShieldController> {
  const AadhaarVerificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _KycCard(
      title: 'Aadhaar Verification',
      subtitle: 'Secure identity confirmation',
      children: [
        AppTextField(
          title: 'Aadhaar Number (12 Digits)',
          onChanged: controller.onAadhaarNumberChanged,
          keyboardType: TextInputType.number,
          maxLength: 12,
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _PhotoUploadBox(
                  label: 'Front Side',
                  icon: Icons.portrait_outlined,
                  fileName: controller.aadhaarFrontFileName.value,
                  onTap: controller.pickAadhaarFront,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Obx(
                () => _PhotoUploadBox(
                  label: 'Back Side',
                  icon: Icons.layers_outlined,
                  fileName: controller.aadhaarBackFileName.value,
                  onTap: controller.pickAadhaarBack,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Liveness Check ─────────────────────────────────────────────────────────────

class LivenessCheckSection extends GetView<TrustedShieldController> {
  const LivenessCheckSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _KycCard(
      icon: Icons.shield_outlined,
      title: 'Liveness Check',
      subtitle: 'Ensure you are a real person',
      children: [
        // Camera preview simulation
        Obx(
          () => Container(
            height: 220.h,
            decoration: BoxDecoration(
              color: AppTokens.livenessBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Face outline guide
                Container(
                  width: 130.w,
                  height: 160.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(80.r),
                    border: Border.all(
                      color: controller.isFaceDetected.value
                          ? AppTokens.online
                          : AppTokens.white.withValues(alpha: 0.4),
                      width: 2.5,
                    ),
                  ),
                ),
                if (!controller.isScanning.value &&
                    !controller.isFaceDetected.value) ...[
                  Icon(
                    Icons.person_outline_rounded,
                    size: 80.sp,
                    color: AppTokens.white.withValues(alpha: 0.3),
                  ),
                ],
                if (controller.isScanning.value) ...[
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: controller.scanProgress.value,
                      backgroundColor: AppTokens.white.withValues(alpha: 0.2),
                      color: AppTokens.online,
                      minHeight: 3,
                    ),
                  ),
                ],
                if (controller.isFaceDetected.value &&
                    !controller.isScanning.value) ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 60.h),
                      Icon(Icons.check_circle,
                          color: AppTokens.online, size: 32.sp),
                      SizedBox(height: 8.h),
                      Text(
                        'Face Verified!',
                        style: TextStyle(
                            color: AppTokens.online,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
                // Scanning overlay text
                Positioned(
                  bottom: 14.h,
                  child: Column(
                    children: [
                      Text(
                        'Facial Recognition',
                        style: TextStyle(
                          color: AppTokens.white.withValues(alpha: 0.7),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => ElevatedButton.icon(
            onPressed: controller.isScanning.value ? null : controller.startScan,
            icon: controller.isScanning.value
                ? SizedBox(
                    width: 14.w,
                    height: 14.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTokens.white,
                    ),
                  )
                : Icon(Icons.center_focus_strong_outlined, size: 16.sp),
            label: Text(
              controller.isScanning.value ? 'Scanning...' : 'Start Scanning',
              style: TextStyle(fontSize: 12.sp),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 44.h),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Shared KYC Card Shell ─────────────────────────────────────────────────────

class _KycCard extends StatelessWidget {
  const _KycCard({
    required this.title,
    required this.subtitle,
    required this.children,
    this.icon,
    this.helpAction,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final IconData? icon;
  final Widget? helpAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(color: AppTokens.border, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16.sp, color: AppTokens.brandPrimary),
                  SizedBox(width: 6.w),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTokens.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (helpAction != null) helpAction!,
              ],
            ),
            SizedBox(height: 14.h),
            ...children,
          ],
        ),
      ),
    );
  }
}

// ── Upload Block ──────────────────────────────────────────────────────────────

class _UploadBlock extends StatelessWidget {
  const _UploadBlock({
    required this.label,
    required this.subLabel,
    required this.fileName,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String subLabel;
  final String fileName;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasFile = fileName.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: hasFile
              ? AppTokens.brandPrimary.withValues(alpha: 0.05)
              : AppTokens.inputBackground,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: hasFile ? AppTokens.brandPrimary : AppTokens.border,
            width: hasFile ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasFile ? Icons.check_circle_outline : icon,
              size: 20.sp,
              color: hasFile ? AppTokens.brandPrimary : AppTokens.textSecondary,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasFile ? fileName : label,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: hasFile ? AppTokens.brandPrimary : AppTokens.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!hasFile && subLabel.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subLabel,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppTokens.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!hasFile)
              Icon(
                Icons.cloud_upload_outlined,
                size: 18.sp,
                color: AppTokens.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Photo Upload Box (front/back) ─────────────────────────────────────────────

class _PhotoUploadBox extends StatelessWidget {
  const _PhotoUploadBox({
    required this.label,
    required this.icon,
    required this.fileName,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasFile = fileName.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: hasFile
              ? AppTokens.brandPrimary.withValues(alpha: 0.05)
              : AppTokens.inputBackground,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: hasFile ? AppTokens.brandPrimary : AppTokens.border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              hasFile ? Icons.check_circle : icon,
              size: 24.sp,
              color: hasFile ? AppTokens.brandPrimary : AppTokens.textSecondary,
            ),
            SizedBox(height: 6.h),
            Text(
              hasFile ? 'Uploaded' : label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: hasFile ? AppTokens.brandPrimary : AppTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
