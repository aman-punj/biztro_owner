import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessHourDayRow extends StatelessWidget {
  const BusinessHourDayRow({
    required this.dayName,
    required this.openTime,
    required this.closeTime,
    required this.onOpenTimePressed,
    required this.onCloseTimePressed,
    super.key,
  });

  final String dayName;
  final String openTime;
  final String closeTime;
  final VoidCallback onOpenTimePressed;
  final VoidCallback onCloseTimePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 76.w,
            child: Text(
              dayName,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppTokens.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onOpenTimePressed,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTokens.surface,
                        border: Border.all(color: AppTokens.border),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        openTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppTokens.brandPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'to',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTokens.textSecondary,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: GestureDetector(
                    onTap: onCloseTimePressed,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTokens.surface,
                        border: Border.all(color: AppTokens.border),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        closeTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppTokens.brandPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
