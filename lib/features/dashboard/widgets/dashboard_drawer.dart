import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/features/auth/services/logout_service.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              children: [
                _DrawerItem(
                  icon: Icons.home_filled,
                  text: 'Dashboard',
                  onTap: () {
                    Get.back();
                  },
                ),
                _DrawerItem(
                  icon: Icons.shield,
                  text: 'Trusted Shield',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.trustedShield);
                  },
                ),
                _DrawerItem(
                  icon: Icons.chat_bubble,
                  text: 'Chat',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.messages);
                  },
                ),
                _DrawerItem(
                  icon: Icons.work,
                  text: 'Business Info',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.editBusinessDetails);
                  },
                ),
                _DrawerItem(
                  icon: Icons.layers,
                  text: 'Business Service',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.editBusinessServices);
                  },
                ),
                _DrawerItem(
                  icon: Icons.location_on,
                  text: 'Location Info',
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.editLocationInfo);
                  },
                ),
                _DrawerItem(
                  icon: Icons.access_time_filled,
                  text: 'Timing Info',
                  onTap: () {},
                ),
                _DrawerItem(
                  icon: Icons.share,
                  text: 'Social Media Link',
                  onTap: () {},
                ),
                _DrawerItem(
                  icon: Icons.school,
                  text: 'Course',
                  onTap: () {},
                ),
                _DrawerItem(
                  icon: Icons.celebration,
                  text: 'Festival',
                  onTap: () {},
                ),
                _DrawerItem(
                  icon: Icons.people,
                  text: 'Leads',
                  onTap: () {},
                ),
                _DrawerItem(
                  icon: Icons.star,
                  text: 'Review & Rating',
                  onTap: () {},
                ),
                _DrawerItem(
                  icon: Icons.ad_units,
                  text: 'Advertisement',
                  onTap: () {},
                ),
                _DrawerItem(
                  icon: Icons.headset_mic,
                  text: 'Support',
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.h, top: 10.h),
            child: _DrawerItem(
              icon: Icons.logout,
              text: 'Sign Out',
              textColor: AppColors.error,
              iconColor: AppColors.error,
              onTap: () async {
                await Get.find<LogoutService>().logout();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 54.h, 20.w, 24.h),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26.r,
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=11',
            ),
            backgroundColor: AppColors.white.withOpacity(0.2),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Singh Brother's",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Business Partner',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.9),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.text,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: iconColor ?? AppColors.textSecondaryLight,
            ),
            SizedBox(width: 16.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: textColor ?? AppColors.surfaceDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
