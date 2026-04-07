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
          children: List.generate(stages.length * 2 - 1, (i) {
            if (i.isEven) {
              final index = i ~/ 2;
              return GestureDetector(
                onTap: () => onStageTap?.call(index),
                child: _buildStageDot(index),
              );
            } else {
              final lineIndex = i ~/ 2;
              return Expanded(
                child: Container(
                  height: 1.5.h,
                  color: lineIndex < currentIndex
                      ? AppTokens.success
                      : AppTokens.border,
                ),
              );
            }
          }),
        ),
        SizedBox(height: 6.h),
        // ── Labels ────────────────────────────────────────────────
        // Each label is Expanded so it fills space between connectors.
        // First label aligns left, last aligns right, middle centered —
        // this keeps them visually over their dots without overflow.
        Row(
          children: List.generate(stages.length * 2 - 1, (i) {
            if (i.isEven) {
              final index = i ~/ 2;
              final bool isDone = index < currentIndex;
              final bool isActive = index == currentIndex;
              TextAlign align = TextAlign.center;
              if (index == 0) align = TextAlign.left;
              if (index == stages.length - 1) align = TextAlign.right;
              return Expanded(
                child: Text(
                  stages[index],
                  textAlign: align,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? AppTokens.brandPrimary
                        : isDone
                        ? AppTokens.success
                        : AppTokens.textSecondary,
                  ),
                ),
              );
            } else {
              return SizedBox(width: 4.w);
            }
          }),
        ),
      ],
    );
  }

  Widget _buildStageDot(int index) {
    final bool isActive = index == currentIndex;
    final bool isDone = index < currentIndex;

    return Container(
      width: 32.w,
      height: 32.w,
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
          width: 1,
        ),
      ),
      child: Center(
        child: isDone
            ? Icon(Icons.check, size: 14.sp, color: AppTokens.white)
            : Text(
          '${index + 1}',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: isActive
                ? AppTokens.white
                : AppTokens.textSecondary,
          ),
        ),
      ),
    );
  }
}
