import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/features/auth/controllers/auth_controller.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_bottom_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordStageView extends GetView<AuthController> {
  const ForgotPasswordStageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          hint: 'Email ID/Mobile No.',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(Icons.person_outline_rounded, size: 14.sp),
          initialValue: controller.email.value,
          onChanged: controller.onEmailChanged,
        ),
        SizedBox(height: AppDimensions.sectionSpacing),
        Obx(
          () => PrimaryButton(
            label: 'Get Password',
            showArrow: true,
            isLoading: controller.isSubmitting.value,
            onPressed: controller.onSubmit,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => controller.formError.value.isEmpty
              ? const SizedBox.shrink()
              : Text(
                  controller.formError.value,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.redAccent,
                  ),
                ),
        ),
        SizedBox(height: AppDimensions.sectionSpacing),
        AuthBottomPrompt(
          question: 'Don\'t have an account ?',
          actionText: 'Sign Up Now',
          onTap: () => controller.setStage(AuthStage.register),
        ),
      ],
    );
  }
}
