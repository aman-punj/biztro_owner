import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthLogoSection extends StatelessWidget {
  const AuthLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppImage(
          path: AppAssets.appTextLogo,
          width: 160.w,
          height: 56.h,
          fit: BoxFit.contain,
          showLoading: false,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
