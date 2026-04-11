import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialMediaLinkInputField extends StatelessWidget {
  const SocialMediaLinkInputField({
    required this.label,
    required this.controller,
    required this.iconPath,
    super.key,
    this.hint,
    this.errorText,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String iconPath;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppTokens.cardBackground,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                padding: EdgeInsets.all(9.w),
                decoration: BoxDecoration(
                  color: AppTokens.surface,
                  borderRadius: BorderRadius.circular(21.r),
                ),
                child: AppImage(
                  path: iconPath,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          AppTextField(
            controller: controller,
            title: 'Link',
            hintText: hint ?? 'https://...',
            keyboardType: TextInputType.url,
            onChanged: onChanged,
            errorText: errorText,
            height: 52.h,
          ),
        ],
      ),
    );
  }
}
