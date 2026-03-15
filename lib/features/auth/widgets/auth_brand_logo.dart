import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBrandLogo extends StatelessWidget {
  const AuthBrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return AppImage(
      path: AppAssets.appTextLogo,
      width: 170.w,
      height: 60.h,
      fit: BoxFit.fitWidth,
      showLoading: false,
    );
  }
}
