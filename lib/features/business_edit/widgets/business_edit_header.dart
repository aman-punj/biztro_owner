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
    final bool showSubtitle = subtitle.trim().isNotEmpty;

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
        crossAxisAlignment: CrossAxisAlignment.start,
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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                      () => FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 260.w,
                      ),
                      child: Text(
                        businessName.value.trim().isNotEmpty
                            ? businessName.value
                            : 'Business Name',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTokens.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ),

                if (showSubtitle) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppTokens.brandPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}