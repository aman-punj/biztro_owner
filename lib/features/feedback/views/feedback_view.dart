import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/feedback/controllers/feedback_controller.dart';
import 'package:bizrato_owner/features/feedback/widgets/feedback_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Merchant Feedback',
      onFilter: () {}, // Optional filter logic later
      useFloatingSurface: false, // Disabling so we can have mixed backgrounds below header natively
      child: Column(
        children: [
          _buildSummaryHeader(),
          _buildTabs(),
          Expanded(
            child: _buildFeedbackList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Transform.translate(
      offset: Offset(0, -30.h),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 26.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppTokens.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppTokens.surfaceInverse.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.summary.value.averageRating.toString(),
                    style: TextStyle(
                      fontSize: 42.sp,
                      fontWeight: FontWeight.w800,
                      color: AppTokens.textPrimary,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 2.w),
                        child: Icon(
                          index < 4 ? Icons.star : Icons.star_half,
                          size: 14.sp,
                          color: AppTokens.star,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${controller.summary.value.totalReviews} REVIEWS',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTokens.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRatingBar(1.0, AppTokens.star),
                  SizedBox(height: 6.h),
                  _buildRatingBar(0.7, AppTokens.star),
                  SizedBox(height: 6.h),
                  _buildRatingBar(0.4, AppTokens.star),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(double percentage, Color color) {
    return Container(
      height: 6.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(4.r),
      ),
      alignment: Alignment.centerLeft,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth * percentage,
            height: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs() {
    return Transform.translate(
      offset: Offset(0, -10.h),
      child: SizedBox(
        height: 40.h,
        child: Obx(
          () => ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            children: [
              _buildTabPill('All Feedbacks', 0),
              SizedBox(width: 12.w),
              _buildTabPill('Recent', 1),
              SizedBox(width: 12.w),
              _buildTabPill('Negative', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabPill(String title, int index) {
    final isSelected = controller.selectedTab.value == index;

    return GestureDetector(
      onTap: () => controller.switchTab(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppTokens.brandPrimary : AppTokens.white,
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected ? null : Border.all(color: AppTokens.border),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppTokens.white : AppTokens.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackList() {
    return Obx(
      () => ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 8.h),
        itemCount: controller.feedbacks.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final item = controller.feedbacks[index];
          return FeedbackCard(
            item: item,
            onReplyPressed: () => controller.replyToFeedback(item),
          );
        },
      ),
    );
  }
}
