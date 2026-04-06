import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
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
      padding: EdgeInsets.all(12.w),
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
              borderRadius: BorderRadius.circular(12.r),
              color: AppTokens.surface,
            ),
            child: Icon(
              Icons.ondemand_video_rounded,
              size: 34.sp,
              color: AppTokens.brandPrimary,
            ),
          ),
          SizedBox(height: 10.h),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppTokens.selectionBackground,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${course.totalVideos} Videos',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.brandPrimary,
                  ),
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
    );
  }
}
