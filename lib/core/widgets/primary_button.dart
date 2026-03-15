import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.showArrow = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.inputHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 18.h,
                width: 18.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.cardLight,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: TextStyle(
                      fontSize: 13.sp, fontWeight: FontWeight.w600
                  ),),
                  if (showArrow) ...[
                    SizedBox(width: 6.w),
                    Icon(Icons.arrow_forward_rounded, size: 13.sp),
                  ],
                ],
              ),
      ),
    );
  }
}
