import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:bizrato_owner/features/festival/data/models/festival_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FestivalCard extends StatelessWidget {
  const FestivalCard({
    super.key,
    required this.festival,
    required this.imageUrl,
    required this.onTap,
  });

  final FestivalModel festival;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTokens.cardBackground,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppTokens.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppImage(
                path: imageUrl,
                width: double.infinity,
                height: 102.h,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(12.r),
              ),
              SizedBox(height: 8.h),
              Text(
                festival.festivalName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTokens.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Posts',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.brandPrimary,
                    ),
                  ),
                  const SizedBox(width: 1),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 14.sp,
                    color: AppTokens.brandPrimary,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
