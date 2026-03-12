import 'package:biztro_owner/core/theme/colors.dart';
import 'package:biztro_owner/core/theme/dimensions.dart';
import 'package:biztro_owner/core/widgets/app_text_field.dart';
import 'package:biztro_owner/core/widgets/primary_button.dart';
import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              width: 38.w,
              child: AppTextField(
                hint: '',
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                height: 36.h,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => controller.onOtpChanged(index, value),
              ),
            ),
          ),
        ),
        SizedBox(height: AppDimensions.sectionSpacing),
        PrimaryButton(
          label: 'Verify & Proceed',
          showArrow: true,
          onPressed: controller.onSubmit,
        ),
        SizedBox(height: 12.h),
        Text(
          'Didn\'t receive the verification code ?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: controller.onSubmit,
          child: Text(
            'Resend Now',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
