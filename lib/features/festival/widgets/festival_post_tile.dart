import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FestivalPostTile extends StatelessWidget {
  const FestivalPostTile({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.cardBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppTokens.border),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: AppImage(
                path: imageUrl,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          Positioned(
            top: 10.h,
            right: 10.w,
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: AppTokens.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: AppTokens.border),
              ),
              child: Icon(
                Icons.arrow_downward,
                size: 14.sp,
                color: AppTokens.brandPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
