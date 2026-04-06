import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_page_shell.dart';
import 'package:bizrato_owner/core/widgets/app_shimmer.dart';
import 'package:bizrato_owner/features/course/controllers/course_controller.dart';
import 'package:bizrato_owner/features/course/widgets/course_video_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CourseDetailsView extends GetView<CourseController> {
  const CourseDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Course Curriculum',
      useFloatingSurface: true,
      contentHorizontalMargin: 26,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 0.h),
        child: Obx(() {
          final selected = controller.selectedCourse.value;
          if (selected == null) {
            return Center(
              child: Text(
                'Course not selected',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppTokens.textSecondary,
                ),
              ),
            );
          }

          if (controller.isDetailsLoading.value) {
            return ListView.separated(
              itemCount: 10,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (_, __) => AppShimmer(
                child: Container(
                  height: 62.h,
                  decoration: BoxDecoration(
                    color: AppTokens.surface,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            );
          }

          return Column(
            children: [
              Text(
                '${controller.courseVideos.length} Video Lectures',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.textSecondary,
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.courseVideos.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (_, index) {
                    final video = controller.courseVideos[index];
                    return CourseVideoTile(
                      title: video.videoTitle,
                      index: index,
                      onPlay: () {
                        Get.snackbar('YouTube Link', video.youtubeLink);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
