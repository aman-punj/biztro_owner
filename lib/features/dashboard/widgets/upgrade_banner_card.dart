import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpgradeBannerCard extends StatelessWidget {
  const UpgradeBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTokens.profileBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppTokens.profileBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(14.r),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start selling on\nBizrato today',
                  style: TextStyle(
                    color: AppTokens.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'List Your Business for free!',
                  style: TextStyle(
                    color: AppTokens.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                _UpgradeNowButton(
                  onTap: () => Get.toNamed(AppRoutes.trustedShield),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Icon(
            Icons.rocket_launch_outlined,
            size: 60.sp,
            color: AppTokens.brandAccent.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}

class _UpgradeNowButton extends StatelessWidget {
  const _UpgradeNowButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: AppTokens.brandAccent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          'Upgrade now',
          style: TextStyle(
            color: AppTokens.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
