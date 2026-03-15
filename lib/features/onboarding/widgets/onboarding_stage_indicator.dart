import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingStageIndicator extends StatelessWidget {
  const OnboardingStageIndicator({
    required this.stages,
    required this.currentIndex,
    super.key,
  });

  final List<String> stages;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: List.generate(
                  stages.length - 1,
                  (index) => Expanded(
                    child: Container(
                      height: 1.h,
                      color: index < currentIndex
                          ? AppColors.primary
                          : AppColors.borderLight,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                stages.length,
                (index) => _buildStageDot(index),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            stages.length,
            (index) => Expanded(
              child: Text(
                stages[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: index == currentIndex ? FontWeight.w600 : FontWeight.w400,
                  color: index == currentIndex
                      ? AppColors.primary
                      : AppColors.textSecondaryLight,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStageDot(int index) {
    final bool isActive = index == currentIndex;
    final bool isDone = index < currentIndex;

    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        color: isActive || isDone ? AppColors.primary : AppColors.surfaceLight,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive || isDone ? AppColors.primary : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Center(
        child: isDone
            ? Icon(Icons.check, size: 14.sp, color: AppColors.white)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.white : AppColors.textSecondaryLight,
                ),
              ),
      ),
    );
  }
}
