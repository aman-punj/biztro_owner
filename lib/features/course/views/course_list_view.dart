import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:bizrato_owner/core/widgets/app_page_shell.dart';
import 'package:bizrato_owner/core/widgets/app_shimmer.dart';
import 'package:bizrato_owner/features/course/controllers/course_controller.dart';
import 'package:bizrato_owner/features/course/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CourseListView extends GetView<CourseController> {
  const CourseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'My Courses',
      useFloatingSurface: true,
      contentHorizontalMargin: 26,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 0.h),
        child: Column(
          children: [
            TextFormField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search course name...',
                prefixIcon: Icon(
                  Icons.search,
                  size: 18.sp,
                  color: AppTokens.textSecondary,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(children: [
                AppImage(path: AppAssets.sparkleIcon),
                Text(
                  'Available for you',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                  ),
                )
              ],),
            ), 
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView.separated(
                    itemCount: 3,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (_, __) => AppShimmer(
                      child: Container(
                        height: 242.h,
                        decoration: BoxDecoration(
                          color: AppTokens.surface,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                  );
                }

                if (controller.hasError.value) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTokens.error,
                      ),
                    ),
                  );
                }

                final courses = controller.filteredCourses;
                if (courses.isEmpty) {
                  return Center(
                    child: Text(
                      'No courses found',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTokens.textSecondary,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadCourses,
                  color: AppTokens.brandPrimary,
                  child: ListView.separated(
                    itemCount: courses.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (_, index) {
                      final course = courses[index];
                      return CourseCard(
                        course: course,
                        onViewDetails: () => controller.openCourse(course),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
