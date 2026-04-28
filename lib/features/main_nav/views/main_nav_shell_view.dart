import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/app_image.dart';
import 'package:bizrato_owner/features/dashboard/views/dashboard_home_tab_view.dart';
import 'package:bizrato_owner/features/dashboard/widgets/dashboard_drawer.dart';
import 'package:bizrato_owner/features/leads/views/leads_view.dart';
import 'package:bizrato_owner/features/main_nav/controllers/main_nav_controller.dart';
import 'package:bizrato_owner/features/messages/views/messages_view.dart';
import 'package:bizrato_owner/features/profile/views/profile_view.dart';
import 'package:bizrato_owner/features/support/views/support_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainNavShellView extends GetView<MainNavController> {
  MainNavShellView({super.key});

  final List<Widget> _tabs = const <Widget>[
    SupportView(),
    LeadsView(),
    DashboardHomeTabView(),
    MessagesView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTokens.screenBackground,
      drawer: const DashboardDrawer(),
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: _MainBottomNav(controller: controller),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () => controller.changeTab(2),
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
            color: controller.currentIndex.value == 2
                ? AppTokens.white
                : AppTokens.white.withValues(alpha: 0.9),
          ),
        ),
      ),
    );
  }
}

class _MainBottomNav extends StatelessWidget {
  const _MainBottomNav({required this.controller});

  final MainNavController controller;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppTokens.white,
        boxShadow: [
          BoxShadow(
            color: AppTokens.surfaceInverse.withValues(alpha: 0.06),
            offset: const Offset(0, -2),
            blurRadius: 10.r,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66.h + (bottomInset > 0 ? 2.h : 0),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            shape: const CircularNotchedRectangle(),
            notchMargin: 7.r,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _NavItem(
                            width: 72.w,
                            iconPath: AppAssets.navBarAnalytics,
                            label: 'Support',
                            selected: controller.currentIndex.value == 0,
                            onTap: () => controller.changeTab(0),
                          ),
                          _NavItem(
                            width: 68.w,
                            iconPath: AppAssets.navBarMessages,
                            label: 'Leads',
                            selected: controller.currentIndex.value == 1,
                            onTap: () => controller.changeTab(1),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 56.w),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _NavItem(
                            width: 76.w,
                            iconPath: AppAssets.navBarMessages,
                            label: 'Messages',
                            selected: controller.currentIndex.value == 3,
                            onTap: () => controller.changeTab(3),
                          ),
                          _NavItem(
                            width: 68.w,
                            iconPath: AppAssets.navBarProfile,
                            label: 'Profile',
                            selected: controller.currentIndex.value == 4,
                            onTap: () => controller.changeTab(4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
    required this.width,
  });

  final String iconPath;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppImage(
                path: iconPath,
                width: 18.sp,
                height: 18.sp,
                fit: BoxFit.contain,
                showLoading: false,
                color: selected
                    ? AppTokens.brandPrimary
                    : AppTokens.textSecondary,
              ),
              SizedBox(height: 2.h),
              SizedBox(
                height: 14.h,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.noScaling,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      height: 1,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? AppTokens.brandPrimary
                          : AppTokens.textSecondary,
                    ),
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
