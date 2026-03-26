import 'package:bizrato_owner/core/theme/colors.dart';
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
        gradient: const LinearGradient(
          colors: [Color(0xFF0B47AE), Color(0xFF1E6FFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
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
                    color: AppColors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'List Your Business for free!',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.8),
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.trustedShield),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBB13C),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Upgrade now',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Icon(
            Icons.rocket_launch_outlined,
            size: 60.sp,
            color: AppColors.white.withOpacity(0.35),
          ),
        ],
      ),
    );
  }
}
