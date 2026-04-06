import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_page_shell.dart';
import 'package:bizrato_owner/core/widgets/app_shimmer.dart';
import 'package:bizrato_owner/features/festival/controllers/festival_controller.dart';
import 'package:bizrato_owner/features/festival/widgets/festival_post_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FestivalDetailsView extends GetView<FestivalController> {
  const FestivalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Festival Templates',
      useFloatingSurface: true,
      contentHorizontalMargin: 26,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 0.h),
        child: Obx(() {
          final selected = controller.selectedFestival.value;
          if (selected == null) {
            return Center(
              child: Text(
                'Festival not selected',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppTokens.textSecondary,
                ),
              ),
            );
          }

          if (controller.isDetailsLoading.value) {
            return GridView.builder(
              itemCount: 8,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (_, __) => AppShimmer(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTokens.surface,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            );
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppTokens.cardBackground,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppTokens.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected.festivalName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTokens.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTokens.selectionBackground,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '${controller.festivalPosts.length} Designs',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTokens.brandPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: GridView.builder(
                  itemCount: controller.festivalPosts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (_, index) {
                    final post = controller.festivalPosts[index];
                    return FestivalPostTile(
                      imageUrl: controller.buildImageUrl(post.postImageUrl),
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
