import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectionCheckbox extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isMultiSelect;
  final VoidCallback onTap;

  const SelectionCheckbox({
    super.key,
    required this.label,
    required this.isSelected,
    this.isMultiSelect = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTokens.selectionBackground
              : AppTokens.cardBackground,
          border: Border.all(
            color: isSelected ? AppTokens.brandPrimary : AppTokens.border,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Container(
              width: 18.w,
              height: 18.h,
              decoration: BoxDecoration(
                shape: isMultiSelect ? BoxShape.rectangle : BoxShape.circle,
                borderRadius:
                    isMultiSelect ? BorderRadius.circular(4.r) : null,
                border: Border.all(
                  color: isSelected ? AppTokens.brandPrimary : AppTokens.border,
                  width: 2.w,
                ),
                color: isSelected ? AppTokens.brandPrimary : AppTokens.white,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 12.sp,
                      color: AppTokens.white,
                    )
                  : null,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppTokens.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
