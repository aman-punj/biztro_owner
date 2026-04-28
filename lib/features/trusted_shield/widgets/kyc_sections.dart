import 'dart:io';

import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/trusted_shield/controllers/trusted_shield_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            Text(
              'Help',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppTokens.brandPrimary,
              ),
            ),
            SizedBox(width: 2.w),
            Icon(
              Icons.help_outline,
              size: 12.sp,
              color: AppTokens.info,
            ),
          ],
        ),
      ),
      children: [
        AppTextField(
          title: 'Business/Firm Name',
          controller: controller.firmNameController,
        ),
        SizedBox(height: 10.h),
        AppTextField(
          title: 'GST Number',
          controller: controller.gstNumberController,
          maxLength: 15,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.characters,
          keyboardType: TextInputType.text,
          inputFormatters: [
            LengthLimitingTextInputFormatter(15),
          ],
          onChanged: (value) {
            final upperValue = value.toUpperCase();
            if (upperValue != value) {
              controller.gstNumberController.value =
                  controller.gstNumberController.value.copyWith(
                text: upperValue,
                selection: TextSelection.collapsed(offset: upperValue.length),
              );
            }
          },
        ),
        SizedBox(height: 12.h),
        Obx(
          () => _UploadBlock(
            label: 'Attach Documents (for GST)',
            subLabel: 'File should be max 2mb in size',
            fileName: controller.gstFileName.value,
            icon: Icons.upload_file_outlined,
            localFilePath: controller.localDocumentPath(KycDocumentType.gst),
            imageUrl: controller.buildImageUrl(
              controller.serverDocumentPath(KycDocumentType.gst),
            ),
            imageHeaders: controller.buildImageHeaders(),
            onTap: () => controller.pickDocument(KycDocumentType.gst),
          ),
        ),
        SizedBox(height: 10.h),
        AppTextField(
          title: 'PAN Number',
          controller: controller.panNumberController,
          maxLength: 10,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.characters,
          keyboardType: TextInputType.text,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
          ],
          onChanged: (value) {
            final upperValue = value.toUpperCase();
            if (upperValue != value) {
              controller.panNumberController.value =
                  controller.panNumberController.value.copyWith(
                text: upperValue,
                selection: TextSelection.collapsed(offset: upperValue.length),
              );
            }
          },
        ),
        SizedBox(height: 12.h),
        Obx(
          () => _UploadBlock(
            label: 'Attach Documents (for PAN)',
            subLabel: '',
            fileName: controller.panImageFileName.value,
            icon: Icons.credit_card_outlined,
            localFilePath: controller.localDocumentPath(KycDocumentType.pan),
            imageUrl: controller.buildImageUrl(
              controller.serverDocumentPath(KycDocumentType.pan),
            ),
            imageHeaders: controller.buildImageHeaders(),
            onTap: () => controller.pickDocument(KycDocumentType.pan),
          ),
        ),
      ],
    );
  }
}

class AadhaarVerificationSection extends GetView<TrustedShieldController> {
  const AadhaarVerificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _KycCard(
      title: 'Aadhaar Verification',
      subtitle: 'Secure identity confirmation',
      children: [
        AppTextField(
          title: 'Aadhaar Number',
          controller: controller.aadhaarNumberController,
          keyboardType: TextInputType.number,
          maxLength: 12,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _PhotoUploadBox(
                  label: 'Attach Documents\n(for Aadhaar front side)',
                  icon: Icons.portrait_outlined,
                  fileName: controller.aadhaarFrontFileName.value,
                  localFilePath: controller.localDocumentPath(
                    KycDocumentType.aadhaarFront,
                  ),
                  imageUrl: controller.buildImageUrl(
                    controller.serverDocumentPath(KycDocumentType.aadhaarFront),
                  ),
                  imageHeaders: controller.buildImageHeaders(),
                  onTap: () => controller.pickDocument(
                    KycDocumentType.aadhaarFront,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Obx(
                () => _PhotoUploadBox(
                  label: 'Attach Documents\n(for Aadhaar back side)',
                  icon: Icons.layers_outlined,
                  fileName: controller.aadhaarBackFileName.value,
                  localFilePath: controller.localDocumentPath(
                    KycDocumentType.aadhaarBack,
                  ),
                  imageUrl: controller.buildImageUrl(
                    controller.serverDocumentPath(KycDocumentType.aadhaarBack),
                  ),
                  imageHeaders: controller.buildImageHeaders(),
                  onTap: () => controller.pickDocument(
                    KycDocumentType.aadhaarBack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LivenessCheckSection extends GetView<TrustedShieldController> {
  const LivenessCheckSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _KycCard(
      icon: Icons.verified_user_outlined,
      title: 'Live Identity Verification (Mandatory)',
      subtitle: 'Open the Bizrato camera to capture a real-face verification selfie',
      children: [
        Obx(
          () => _LiveImagePreview(
            fileName: controller.liveImageFileName.value,
            localFilePath: controller.localDocumentPath(KycDocumentType.live),
            imageUrl: controller.buildImageUrl(
              controller.serverDocumentPath(KycDocumentType.live),
            ),
            imageHeaders: controller.buildImageHeaders(),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => ElevatedButton.icon(
            onPressed: controller.startLiveIdentityVerification,
            icon: Icon(Icons.camera_alt_outlined, size: 16.sp),
            label: Text(
              controller.liveImageFileName.value.isEmpty
                  ? 'Start Live Verification'
                  : 'Retake Live Verification',
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
        side: BorderSide(color: AppTokens.border, width: 1.w),
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

class _UploadBlock extends StatelessWidget {
  const _UploadBlock({
    required this.label,
    required this.subLabel,
    required this.fileName,
    required this.icon,
    required this.localFilePath,
    required this.imageUrl,
    required this.imageHeaders,
    required this.onTap,
  });

  final String label;
  final String subLabel;
  final String fileName;
  final IconData icon;
  final String localFilePath;
  final String imageUrl;
  final Map<String, String>? imageHeaders;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasFile =
        fileName.isNotEmpty || localFilePath.isNotEmpty || imageUrl.isNotEmpty;
    final bool hasPreview = localFilePath.isNotEmpty || imageUrl.isNotEmpty;

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
            width: hasFile ? 1.5.w : 1.w,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Icon(
                hasFile ? Icons.check_circle_outline : icon,
                size: 20.sp,
                color:
                    hasFile ? AppTokens.brandPrimary : AppTokens.textSecondary,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasFile && fileName.isNotEmpty ? fileName : label,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: hasFile
                          ? AppTokens.brandPrimary
                          : AppTokens.textPrimary,
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
                  if (hasPreview) ...[
                    SizedBox(height: 8.h),
                    _DocumentPreview(
                      localFilePath: localFilePath,
                      imageUrl: imageUrl,
                      imageHeaders: imageHeaders,
                    ),
                  ],
                ],
              ),
            ),
            if (!hasFile)
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Icon(
                  Icons.cloud_upload_outlined,
                  size: 18.sp,
                  color: AppTokens.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PhotoUploadBox extends StatelessWidget {
  const _PhotoUploadBox({
    required this.label,
    required this.icon,
    required this.fileName,
    required this.localFilePath,
    required this.imageUrl,
    required this.imageHeaders,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String fileName;
  final String localFilePath;
  final String imageUrl;
  final Map<String, String>? imageHeaders;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasFile =
        fileName.isNotEmpty || localFilePath.isNotEmpty || imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: hasFile
              ? AppTokens.brandPrimary.withValues(alpha: 0.05)
              : AppTokens.inputBackground,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: hasFile ? AppTokens.brandPrimary : AppTokens.border,
            width: 1.w,
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
            if (hasFile &&
                (localFilePath.isNotEmpty || imageUrl.isNotEmpty)) ...[
              _DocumentPreview(
                localFilePath: localFilePath,
                imageUrl: imageUrl,
                imageHeaders: imageHeaders,
                height: 76.h,
              ),
              SizedBox(height: 6.h),
            ],
            Text(
              hasFile ? (fileName.isEmpty ? 'Uploaded' : fileName) : label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color:
                    hasFile ? AppTokens.brandPrimary : AppTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveImagePreview extends StatelessWidget {
  const _LiveImagePreview({
    required this.fileName,
    required this.localFilePath,
    required this.imageUrl,
    required this.imageHeaders,
  });

  final String fileName;
  final String localFilePath;
  final String imageUrl;
  final Map<String, String>? imageHeaders;

  @override
  Widget build(BuildContext context) {
    final hasPreview = localFilePath.isNotEmpty || imageUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      height: 220.h,
      decoration: BoxDecoration(
        color: AppTokens.livenessBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: hasPreview
          ? Stack(
              children: [
                Positioned.fill(
                  child: _DocumentPreview(
                    localFilePath: localFilePath,
                    imageUrl: imageUrl,
                    imageHeaders: imageHeaders,
                    borderRadius: BorderRadius.zero,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 12.w,
                  right: 12.w,
                  bottom: 12.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTokens.textPrimary.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      fileName.isEmpty
                          ? 'Live verification image captured'
                          : fileName,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppTokens.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 42.sp,
                  color: AppTokens.white.withValues(alpha: 0.8),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Capture a clear front selfie',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Bizrato will use this only for live identity verification.',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppTokens.white.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
    );
  }
}

class _DocumentPreview extends GetView<TrustedShieldController> {
  const _DocumentPreview({
    required this.localFilePath,
    required this.imageUrl,
    required this.imageHeaders,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String localFilePath;
  final String imageUrl;
  final Map<String, String>? imageHeaders;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final resolvedHeight = height ?? 88.h;
    final resolvedBorderRadius = borderRadius ?? BorderRadius.circular(10.r);

    if (localFilePath.isNotEmpty && controller.isImageFile(localFilePath)) {
      return ClipRRect(
        borderRadius: resolvedBorderRadius,
        child: Image.file(
          File(localFilePath),
          width: double.infinity,
          height: resolvedHeight,
          fit: fit,
        ),
      );
    }

    if (imageUrl.isNotEmpty) {
      return AppImage(
        path: imageUrl,
        width: double.infinity,
        height: resolvedHeight,
        fit: fit,
        borderRadius: resolvedBorderRadius,
        httpHeaders: imageHeaders,
      );
    }

    return Container(
      width: double.infinity,
      height: resolvedHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: resolvedBorderRadius,
        border: Border.all(color: AppTokens.border, width: 1.w),
      ),
      child: Icon(
        Icons.insert_drive_file_outlined,
        size: 22.sp,
        color: AppTokens.textSecondary,
      ),
    );
  }
}
