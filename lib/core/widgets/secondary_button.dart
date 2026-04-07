import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.height,
    this.padding,
  }) : assert(label != null || child != null);

  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final buttonChild = child ??
        Text(
          label!,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppTokens.brandPrimary,
          ),
        );

    return SizedBox(
      height: height ?? AppDimensions.inputHeight,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: AppTokens.secondaryButtonBackground,
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 10.h,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
        ),
        child: buttonChild,
      ),
    );
  }
}
