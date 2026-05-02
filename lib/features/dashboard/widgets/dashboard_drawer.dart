import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/features/auth/services/logout_service.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashboardDrawer extends StatefulWidget {
  const DashboardDrawer({super.key});

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  late final ScrollController _scrollController;
  bool _showBottomFade = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateBottomFade);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateBottomFade());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateBottomFade);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateBottomFade() {
    if (!_scrollController.hasClients) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    final nextShow = maxScroll > 0 && current < (maxScroll - 1);
    if (nextShow != _showBottomFade) {
      setState(() {
        _showBottomFade = nextShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    return Drawer(
      backgroundColor: AppTokens.white,
      child: Column(
        children: [
          _buildHeader(controller),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(0.w, 10.h, 0.w, 20.h),
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
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.editTimingPayment);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.share,
                      text: 'Social Media Link',
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.editSocialMediaLinks);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.school,
                      text: 'Course',
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.courses);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.celebration,
                      text: 'Festival',
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.festivals);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.people,
                      text: 'Leads',
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.leads);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.star,
                      text: 'Review & Rating',
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.feedback);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.ad_units,
                      text: 'Advertisement',
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.postAdvertisement);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.headset_mic,
                      text: 'Support',
                      onTap: () {},
                    ),
                  ],
                ),
                if (_showBottomFade)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        height: 24.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              AppTokens.white.withValues(alpha: 0),
                              AppTokens.white,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.h, top: 10.h),
              child: _DrawerItem(
                icon: Icons.logout,
                text: 'Sign Out',
                textColor: AppTokens.error,
                iconColor: AppTokens.error,
                onTap: () async {
                  await Get.find<LogoutService>().logout();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(DashboardController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 54.h, 20.w, 24.h),
      decoration: const BoxDecoration(
        color: AppTokens.brandPrimary,
      ),
      child: Row(
        children: [
          Obx(
            () {
              final name = controller.businessName.value.trim();
              final initial =
                  name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'B';
              return CircleAvatar(
                radius: 26.r,
                backgroundColor: AppTokens.white.withValues(alpha: 0.2),
                child: Text(
                  initial,
                  style: TextStyle(
                    color: AppTokens.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Obx(
              () {
                final businessName = controller.businessName.value.trim();
                final businessType = controller.businessType.value.trim();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      businessName.isNotEmpty ? businessName : 'Business',
                      style: TextStyle(
                        color: AppTokens.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      businessType.isNotEmpty ? businessType : 'Business Partner',
                      style: TextStyle(
                        color: AppTokens.white.withValues(alpha: 0.9),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                );
              },
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
              color: iconColor ?? AppTokens.textSecondary,
            ),
            SizedBox(width: 16.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: textColor ?? AppTokens.surfaceInverse,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
