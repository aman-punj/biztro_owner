import 'package:biztro_owner/core/theme/colors.dart';
import 'package:biztro_owner/core/theme/dimensions.dart';
import 'package:biztro_owner/core/widgets/primary_button.dart';
import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OtpStageView extends GetView<AuthController> {
  const OtpStageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (index) => SizedBox(
              width: 60.w,
              height: 56.h,
              child: TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: const InputDecoration(counterText: ''),
                onChanged: (value) => controller.onOtpChanged(index, value),
              ),
            ),
          ),
        ),
        SizedBox(height: AppDimensions.sectionSpacing),
        PrimaryButton(label: 'Verify OTP', onPressed: controller.onSubmit),
        SizedBox(height: 10.h),
        TextButton(
          onPressed: controller.onSubmit,
          child: const Text('Resend OTP'),
        ),
        TextButton(
          onPressed: () => controller.setStage(AuthStage.login),
          child: Text(
            'Back to Login',
            style: TextStyle(color: AppColors.textSecondaryLight),
          ),
        ),
      ],
    );
  }
}
