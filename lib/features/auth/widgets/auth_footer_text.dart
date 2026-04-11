import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthFooterText extends StatelessWidget {
  const AuthFooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(
      '© 2026 Bizrato Biz Concepts Pvt. Ltd.',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondaryLight,
        fontSize: 9.sp,
      ),
      textAlign: TextAlign.center,
    ),);
  }
}
