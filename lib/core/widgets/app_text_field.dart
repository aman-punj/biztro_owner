import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.hint,
    super.key,
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
  });

  final String hint;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final int? maxLength;
  final double? height;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? AppDimensions.inputHeight,
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlign: textAlign,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.textFieldBackground,
          counterText: '',
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
