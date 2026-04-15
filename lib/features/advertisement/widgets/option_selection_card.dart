import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionSelectionCard<T> extends StatelessWidget {
  final T item;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionSelectionCard({
    super.key,
    required this.item,
    required this.title,
    this.subtitle,
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
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  width: 2,
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
