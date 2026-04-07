import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:bizrato_owner/features/dashboard/widgets/widgets.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.screenBackground,
      drawer: const DashboardDrawer(),
      body: Obx(() {
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
      }),
      bottomNavigationBar: _DashboardBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTokens.brandPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: AppImage(
          path: AppAssets.navBarCenterTile,
          width: 28.sp,
          height: 28.sp,
          fit: BoxFit.contain,
          showLoading: false,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _DashboardBottomNav extends StatefulWidget {
  @override
  State<_DashboardBottomNav> createState() => _DashboardBottomNavState();
}

class _DashboardBottomNavState extends State<_DashboardBottomNav> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.white,
        boxShadow: [
          BoxShadow(
            color: AppTokens.surfaceInverse.withValues(alpha: 0.06),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomAppBar(
          height: 64.h,
          color: Colors.transparent,
          elevation: 0,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                iconPath: AppAssets.navBarHomePage,
                label: 'Home',
                selected: _selected == 0,
                onTap: () => setState(() => _selected = 0),
              ),
              _NavItem(
                iconPath: AppAssets.navBarMessages,
                label: 'Analytics',
                selected: _selected == 1,
                onTap: () => setState(() => _selected = 1),
              ),
              SizedBox(width: 48.w), // FAB space
              _NavItem(
                iconPath: AppAssets.navBarAnalytics,
                label: 'Messages',
                selected: _selected == 3,
                onTap: () {
                  setState(() => _selected = 3);
                  Get.toNamed(AppRoutes.messages);
                },
              ),
              _NavItem(
                iconPath: AppAssets.navBarProfile,
                label: 'Profile',
                selected: _selected == 4,
                onTap: () => setState(() => _selected = 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.iconPath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppImage(
                path: iconPath,
                width: 20.sp,
                height: 20.sp,
                fit: BoxFit.contain,
                showLoading: false,
                color:
                    selected ? AppTokens.brandPrimary : AppTokens.textSecondary,
              ),
              SizedBox(height: 2.h),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.5.sp, // Slightly reduced for safety
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? AppTokens.brandPrimary
                        : AppTokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      // ✅ Title bar (pinned) = WHITE
      expandedHeight: 200.h,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: AppTokens.surfaceInverse.withValues(alpha: 0.10),
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,

      // title row stays exactly the same — now on WHITE background
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
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
              _AppBarIconButton(icon: Icons.notifications_none_outlined),
              SizedBox(width: 8.w),
              _AppBarIconButton(icon: Icons.headset_mic_outlined),
            ],
          ),
        ],
      ),

      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Column(
          children: [
            // ✅ White strip = same height as pinned title bar
            Container(
              color: AppTokens.white,
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
            ),

            // ✅ Blue section below the white title bar
            Expanded(
              child: Container(
                color: AppTokens.brandPrimary,
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Welcome text on blue
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

                    // White business card
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppTokens.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppTokens.surfaceInverse.withValues(alpha: 0.08),
                            blurRadius: 8,
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
                                      Icon(Icons.remove_red_eye_outlined,
                                          size: 13.sp,
                                          color: AppTokens.brandPrimary),
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppTokens.screenBackground, // ✅ Light grey on white
        borderRadius: BorderRadius.circular(8.r),
      ),
      child:
          Icon(icon, color: AppTokens.textPrimary, size: 18.sp), // ✅ Dark
    );
  }
}
