import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingOptionTile extends StatelessWidget {
  const OnboardingOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
    this.multiSelect = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTokens.selectionBackground : AppTokens.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppTokens.brandPrimary : AppTokens.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppTokens.textPrimary : AppTokens.textSecondary,
                ),
              ),
            ),
            if (multiSelect)
              AppCheckbox(isSelected: isSelected)
            else
              Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1.5,
                    color: isSelected ? AppTokens.brandPrimary : AppTokens.border,
                  ),
                  color: AppTokens.white,
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: const BoxDecoration(
                            color: AppTokens.brandPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
