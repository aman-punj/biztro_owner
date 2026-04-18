import 'dart:io';

import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagePickerWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;
  final String label;

  const ImagePickerWidget({
    super.key,
    this.imagePath,
    required this.onTap,
    this.label = 'Tap to Upload Image',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: AppTokens.surface,
          border: Border.all(color: AppTokens.border, width: 2.w),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: imagePath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48.sp,
                    color: AppTokens.brandPrimary,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.brandPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'JPG or PNG. Recommended size: 1080 by 450 pixels',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTokens.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      File(imagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8.w,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTokens.brandPrimary,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 16.sp,
                          color: AppTokens.white,
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
