import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashboardHeader extends GetView<DashboardController> {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTokens.brandPrimary,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar: logo + icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.menu, color: AppTokens.white, size: 22.sp),
              AppImage(
                path: AppAssets.appTextLogo,
                width: 90.w,
                height: 28.h,
                fit: BoxFit.fitWidth,
                showLoading: false,
              ),
              Row(
                children: [
                  _NotifIcon(icon: Icons.notifications_none_outlined),
                  SizedBox(width: 8.w),
                  _NotifIcon(icon: Icons.headset_mic_outlined),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Welcome to Haldiram',
            style: TextStyle(
              color: AppTokens.white.withValues(alpha: 0.85),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          // Business info card
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppTokens.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Obx(
              () => Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      width: 54.w,
                      height: 54.w,
                      color: AppTokens.white.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.storefront_outlined,
                        color: AppTokens.white,
                        size: 28.sp,
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
                            color: AppTokens.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          controller.businessType.value,
                          style: TextStyle(
                            color: AppTokens.white.withValues(alpha: 0.75),
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            _StatBadge(
                              icon: Icons.star_rounded,
                              value: controller.totalClickCount.value,
                              iconColor: AppTokens.star,
                            ),
                            SizedBox(width: 8.w),
                            _StatBadge(
                              icon: Icons.remove_red_eye,
                              iconColor: AppTokens.info,
                              value: controller.viewCount.value,
                            ),
                            SizedBox(width: 8.w),
                            _StatBadge(
                              icon: Icons.monitor_heart,
                              value: controller.likeCount.value,
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
    );
  }
}

class _NotifIcon extends StatelessWidget {
  const _NotifIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppTokens.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, color: AppTokens.white, size: 18.sp),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.value,
    this.iconColor,
  });

  final IconData icon;
  final String value;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11.sp, color: iconColor ?? AppTokens.white),
        SizedBox(width: 2.w),
        Text(
          value,
          style: TextStyle(
            color: AppTokens.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
