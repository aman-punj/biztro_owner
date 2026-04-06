import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditPageAppBar({
    required this.title,
    this.onBack,
    this.onHelp,
    super.key,
  });

  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onHelp;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56.h,
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack ?? () => Get.back(),
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.white,
                    size: 16.sp,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onHelp,
                    child: Icon(
                      Icons.help_outline,
                      color: AppColors.white,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.play_circle_outline,
                    color: AppColors.white,
                    size: 20.sp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
