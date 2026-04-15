import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: List.generate(
          totalSteps,
          (index) => Expanded(
            child: _buildStepDot(index, context),
          ),
        ),
      ),
    );
  }

  Widget _buildStepDot(int index, BuildContext context) {
    final isActive = index <= currentStep;
    final isCompleted = index < currentStep;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        height: 8.h,
        decoration: BoxDecoration(
          color: isActive ? AppTokens.brandPrimary : AppTokens.border,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }
}
