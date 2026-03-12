import 'package:biztro_owner/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBottomPrompt extends StatelessWidget {
  const AuthBottomPrompt({
    required this.question,
    required this.actionText,
    required this.onTap,
    super.key,
  });

  final String question;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          question,
          style: textTheme.bodyMedium?.copyWith(fontSize: 10.sp),
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 10.sp,
            ),
          ),
        ),
      ],
    );
  }
}
