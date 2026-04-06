import 'package:bizrato_owner/core/theme/colors.dart';
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
  });

  final String title;
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // External Title
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 6.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black.withValues(alpha: 0.8),
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
              fontWeight: FontWeight.w400, // Medium weight for the value
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.textFieldBackground,
              counterText: '',
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
              // Smaller padding for a more compact look
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r), // Slightly smaller radius
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}