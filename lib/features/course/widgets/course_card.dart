import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/core/widgets/secondary_button.dart';
import 'package:bizrato_owner/features/course/data/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.onViewDetails,
  });

  final CourseModel course;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 126.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r)),
              color: AppTokens.surface,
            ),
            child: Icon(
              Icons.ondemand_video_rounded,
              size: 34.sp,
              color: AppTokens.brandPrimary,
            ),
          ),
          // SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              children: [
                Text(
                  course.courseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  course.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTokens.textSecondary,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    SecondaryButton(
                      height: 36.h,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_circle_fill_rounded,
                            size: 14.sp,
                            color: AppTokens.brandPrimary,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '${course.totalVideos} Videos',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTokens.brandPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 36.h,
                        child: PrimaryButton(
                          label: 'View Details',
                          onPressed: onViewDetails,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
