import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BusinessEditHeader extends StatelessWidget {
  const BusinessEditHeader({
    super.key,
    required this.businessName,
    required this.subtitle,
  });

  final RxString businessName;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTokens.brandPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTokens.brandPrimary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppTokens.brandPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.storefront,
              color: AppTokens.brandPrimary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  businessName.value.isNotEmpty
                      ? businessName.value
                      : 'Business Name',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.textPrimary,
                  ),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppTokens.brandPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
