import 'package:biztro_owner/core/theme/dimensions.dart';
import 'package:biztro_owner/core/widgets/app_text_field.dart';
import 'package:biztro_owner/core/widgets/primary_button.dart';
import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginStageView extends GetView<AuthController> {
  const LoginStageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.mail_outline_rounded),
          initialValue: controller.email.value,
          onChanged: controller.onEmailChanged,
        ),
        SizedBox(height: 12.h),
        Obx(
          () => AppTextField(
            hint: 'Password',
            obscureText: controller.isPasswordHidden.value,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              onPressed: controller.togglePasswordVisibility,
              icon: Icon(
                controller.isPasswordHidden.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
            initialValue: controller.password.value,
            onChanged: controller.onPasswordChanged,
          ),
        ),
        SizedBox(height: 6.h),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => controller.setStage(AuthStage.forgotPassword),
            child: const Text('Forgot Password?'),
          ),
        ),
        SizedBox(height: AppDimensions.sectionSpacing),
        PrimaryButton(label: 'Sign in', onPressed: controller.onSubmit),
        SizedBox(height: 12.h),
        TextButton(
          onPressed: () => controller.setStage(AuthStage.register),
          child: const Text('Don\'t have an account? Register Now'),
        ),
      ],
    );
  }
}
