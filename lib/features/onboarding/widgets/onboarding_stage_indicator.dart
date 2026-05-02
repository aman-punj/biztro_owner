import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingStageIndicator extends StatelessWidget {
  const OnboardingStageIndicator({
    required this.stages,
    required this.currentIndex,
    this.onStageTap,
    super.key,
  });

  final List<String> stages;
  final int currentIndex;
  final void Function(int index)? onStageTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(stages.length * 2 - 1, (index) {
            if (index.isEven) {
              final stageIndex = index ~/ 2;
              return GestureDetector(
                onTap: () => onStageTap?.call(stageIndex),
                child: _buildStageDot(stageIndex),
              );
            }

            final connectorIndex = index ~/ 2;
            return Expanded(
              child: Container(
                height: 1.h,
                color: connectorIndex < currentIndex
                    ? AppTokens.success
                    : AppTokens.border,
              ),
            );
          }),
        ),
        SizedBox(height: 4.h),
        Row(
          children: List.generate(stages.length * 2 - 1, (index) {
            if (index.isEven) {
              final stageIndex = index ~/ 2;
              final isDone = stageIndex < currentIndex;
              final isActive = stageIndex == currentIndex;

              TextAlign align = TextAlign.center;
              if (stageIndex == 0) align = TextAlign.left;
              if (stageIndex == stages.length - 1) align = TextAlign.right;

              return Expanded(
                child: Text(
                  stages[stageIndex],
                  textAlign: align,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? AppTokens.brandPrimary
                        : isDone
                            ? AppTokens.success
                            : AppTokens.textSecondary,
                  ),
                ),
              );
            }
            return SizedBox(width: 4.w);
          }),
        ),
      ],
    );
  }

  Widget _buildStageDot(int index) {
    final isActive = index == currentIndex;
    final isDone = index < currentIndex;

    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        color: isDone
            ? AppTokens.success
            : isActive
                ? AppTokens.brandPrimary
                : AppTokens.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDone
              ? AppTokens.success
              : isActive
                  ? AppTokens.brandPrimary
                  : AppTokens.border,
          width: 1.w,
        ),
      ),
      child: Center(
        child: isDone
            ? Icon(Icons.check, size: 12.sp, color: AppTokens.white)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color:
                      isActive ? AppTokens.white : AppTokens.textSecondary,
                ),
              ),
      ),
    );
  }
}
