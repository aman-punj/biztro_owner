import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FestivalPostTile extends StatelessWidget {
  const FestivalPostTile({
    super.key,
    required this.imageUrl,
    required this.onDownload,
    this.isDownloading = false,
  });

  final String imageUrl;
  final VoidCallback onDownload;
  final bool isDownloading;

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
            child: GestureDetector(
              onTap: isDownloading ? null : onDownload,
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: AppTokens.cardBackground,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTokens.border),
                ),
                child: isDownloading
                    ? Padding(
                        padding: EdgeInsets.all(7.w),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          color: AppTokens.brandPrimary,
                        ),
                      )
                    : Icon(
                        Icons.arrow_downward,
                        size: 15.sp,
                        color: AppTokens.brandPrimary,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
