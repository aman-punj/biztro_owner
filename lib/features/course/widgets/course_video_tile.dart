import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseVideoTile extends StatelessWidget {
  const CourseVideoTile({
    super.key,
    required this.title,
    required this.index,
    required this.onPlay,
  });

  final String title;
  final int index;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppTokens.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppTokens.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppTokens.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.play_lesson_outlined,
              size: 22.sp,
              color: AppTokens.brandPrimary,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Day ${index + 1}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.brandPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          InkWell(
            onTap: onPlay,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              width: 52.w,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: AppTokens.surface,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    size: 18.sp,
                    color: AppTokens.textPrimary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTokens.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
