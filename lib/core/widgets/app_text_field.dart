import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.title, // Renamed hint to title for clarity
    super.key,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.height,
    this.inputFormatters,
    this.readOnly = false,
    this.onSubmitted,
    this.maxLines = 1,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.autofocus = false,
    this.errorText,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
  });

  final String title;
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final int? maxLength;
  final int? maxLines;
  final double? height;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final String? errorText;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // External Title
      if(title.isNotEmpty)  Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 6.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppTokens.textPrimary.withValues(alpha: 0.8),
            ),
          ),
        ),

        // Input Box
        SizedBox(
          height: height ?? 48.h, // Reduced height to match screenshot
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            textInputAction: textInputAction,
            autofocus: autofocus,
            onTap: onTap,
            textCapitalization: textCapitalization,
            initialValue: controller == null ? initialValue : null,
            onChanged: onChanged,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textAlign: textAlign,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            onFieldSubmitted: onSubmitted,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: AppTokens.textPrimary,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTokens.inputBackground,
              counterText: '',
              errorText: errorText?.trim().isEmpty ?? true ? null : errorText,
              hintText: hintText ?? title,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: AppTokens.textSecondary,
              ),
              // Smaller padding for a more compact look
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: AppTokens.textPrimary,
                  width: 0.8.w,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: errorText?.trim().isEmpty ?? true
                    ? BorderSide(
                        color: AppTokens.textPrimary,
                        width: 0.8.w,
                      )
                    : BorderSide(color: AppTokens.error, width: 1.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: errorText?.trim().isEmpty ?? true
                    ? BorderSide(
                        color: AppTokens.textPrimary,
                        width: 0.8.w,
                      )
                    : BorderSide(color: AppTokens.error, width: 1.w),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppTokens.error, width: 1.w),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppTokens.error, width: 1.w),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
