import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:bizrato_owner/features/dashboard/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashboardHomeTabView extends GetView<DashboardController> {
  const DashboardHomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const _DashboardLoadingState();
      }
      if (controller.hasError.value) {
        return _DashboardErrorState(
          message: controller.errorMessage.value,
          onRetry: controller.refresh,
        );
      }
      return RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppTokens.brandPrimary,
        child: CustomScrollView(
          slivers: [
            const _DashboardSliverAppBar(),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const ProfileCompletenessCard(),
                  SizedBox(height: 16.h),
                  const QuickActionsSection(),
                  SizedBox(height: 16.h),
                  const UpgradeBannerCard(),
                  SizedBox(height: 16.h),
                  const BusinessInsightsSection(),
                  SizedBox(height: 16.h),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14.r),
                      child: const LeadAnalyticsSection(),
                    ),
                  ),
                  SizedBox(height: 90.h),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _DashboardLoadingState extends StatelessWidget {
  const _DashboardLoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppTokens.brandPrimary),
          SizedBox(height: 16.h),
          Text(
            'Loading your dashboard...',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardErrorState extends StatelessWidget {
  const _DashboardErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48.sp,
              color: AppTokens.textSecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppTokens.textSecondary,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardSliverAppBar extends GetView<DashboardController> {
  const _DashboardSliverAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppTokens.white,
      expandedHeight: 200.h,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: AppTokens.surfaceInverse.withValues(alpha: 0.10),
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  Icons.menu,
                  color: AppTokens.textPrimary,
                  size: 24.sp,
                ),
              ),
            ),
          ),
          AppImage(
            path: AppAssets.appTextLogo,
            width: 90.w,
            height: 28.h,
            fit: BoxFit.fitWidth,
            showLoading: false,
          ),
          Row(
            children: [
              const _AppBarIconButton(icon: Icons.notifications_none_outlined),
              SizedBox(width: 8.w),
              const _AppBarIconButton(icon: Icons.headset_mic_outlined),
            ],
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Column(
          children: [
            Container(
              color: AppTokens.white,
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: Container(
                color: AppTokens.brandPrimary,
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        'Welcome to ${controller.businessName.value}',
                        style: TextStyle(
                          color: AppTokens.white.withValues(alpha: 0.88),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppTokens.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppTokens.surfaceInverse
                                .withValues(alpha: 0.08),
                            blurRadius: 8.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Obx(
                        () => Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Container(
                                width: 56.w,
                                height: 56.w,
                                color: AppTokens.screenBackground,
                                child: Center(
                                  child: AppImage(
                                    path: AppAssets.businessCardIcon,
                                    width: 28.sp,
                                    height: 28.sp,
                                    fit: BoxFit.contain,
                                    showLoading: false,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.businessName.value,
                                    style: TextStyle(
                                      color: AppTokens.textPrimary,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    controller.businessType.value,
                                    style: TextStyle(
                                      color: AppTokens.textSecondary,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 13.sp,
                                        color: AppTokens.star,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        controller.totalClickCount.value,
                                        style: TextStyle(
                                          color: AppTokens.textPrimary,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 13.sp,
                                        color: AppTokens.brandPrimary,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        controller.viewCount.value,
                                        style: TextStyle(
                                          color: AppTokens.textPrimary,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.favorite_rounded,
                                        size: 13.sp,
                                        color: AppTokens.error,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        controller.likeCount.value,
                                        style: TextStyle(
                                          color: AppTokens.textPrimary,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: AppTokens.screenBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        icon,
        color: AppTokens.textPrimary,
        size: 18.sp,
      ),
    );
  }
}
