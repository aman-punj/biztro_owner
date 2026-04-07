import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_page_shell.dart';
import 'package:bizrato_owner/core/widgets/app_shimmer.dart';
import 'package:bizrato_owner/features/festival/controllers/festival_controller.dart';
import 'package:bizrato_owner/features/festival/widgets/festival_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FestivalListView extends GetView<FestivalController> {
  const FestivalListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'My Festivals',
      useFloatingSurface: true,
      contentHorizontalMargin: 26,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 0.h),
        child: Column(
          children: [
            TextFormField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search festivals...',
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
              child: Text(
                'Festivals',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTokens.textPrimary,
                ),
              ),
            ),
            // SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return GridView.builder(
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (_, __) => AppShimmer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppTokens.surface,
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

                final festivals = controller.filteredFestivals;
                if (festivals.isEmpty) {
                  return Center(
                    child: Text(
                      'No festivals found',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTokens.textSecondary,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadFestivals,
                  color: AppTokens.brandPrimary,
                  child: GridView.builder(
                    itemCount: festivals.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.92,
                    ),
                    itemBuilder: (_, index) {
                      final item = festivals[index];
                      return FestivalCard(
                        festival: item,
                        imageUrl: controller.buildImageUrl(item.festivalImageUrl),
                        onTap: () => controller.openFestival(item),
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
