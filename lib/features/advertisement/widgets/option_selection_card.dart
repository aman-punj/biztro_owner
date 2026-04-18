import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionSelectionCard<T> extends StatelessWidget {
  final T item;
  final String title;
  final String? subtitle;
  final String? leadingText;
  final String? iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionSelectionCard({
    super.key,
    required this.item,
    required this.title,
    this.subtitle,
    this.leadingText,
    this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTokens.selectionBackground
              : AppTokens.cardBackground,
          border: Border.all(
            color: isSelected ? AppTokens.brandPrimary : AppTokens.border,
            width: isSelected ? 2.w : 1.w,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            _OptionIcon(iconPath: iconPath),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leadingText != null && leadingText!.isNotEmpty) ...[
                    Text(
                      leadingText!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTokens.brandPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTokens.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTokens.brandPrimary : AppTokens.border,
                  width: 2.w,
                ),
                color: isSelected ? AppTokens.brandPrimary : AppTokens.white,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14.sp,
                      color: AppTokens.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionIcon extends StatelessWidget {
  const _OptionIcon({this.iconPath});

  final String? iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      height: 42.w,
      padding: EdgeInsets.all(9.w),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: iconPath != null && iconPath!.isNotEmpty
          ? AppImage(
              path: iconPath!,
              width: 24.w,
              height: 24.w,
              color: AppTokens.brandPrimary,
            )
          : Icon(
              Icons.campaign_outlined,
              size: 22.sp,
              color: AppTokens.brandPrimary,
            ),
    );
  }
}
