import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingSectionCard extends StatelessWidget {
  const OnboardingSectionCard({
    required this.child,
    super.key,
    this.title,
    this.subtitle,
    this.titleIcon,
  });

  final String? title;
  final String? subtitle;
  final Widget? titleIcon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null && title!.trim().isNotEmpty;
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTitle)
            Row(
              children: [
                if (titleIcon != null) ...[
                  titleIcon!,
                  SizedBox(width: 8.w),
                ],
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          if (hasSubtitle) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle!,
              style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondaryLight),
            ),
          ],
          if (hasTitle || hasSubtitle) SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}
