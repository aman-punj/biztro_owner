import 'package:biztro_owner/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBrandLogo extends StatelessWidget {
  const AuthBrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      width: 84.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        'bizrato',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
