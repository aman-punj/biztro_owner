import 'package:biztro_owner/core/theme/dimensions.dart';
import 'package:biztro_owner/core/widgets/app_text_field.dart';
import 'package:biztro_owner/core/widgets/primary_button.dart';
import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterStageView extends GetView<AuthController> {
  const RegisterStageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          hint: 'Business Name',
          prefixIcon: const Icon(Icons.business_outlined),
          initialValue: controller.fullName.value,
          onChanged: controller.onFullNameChanged,
        ),
        SizedBox(height: 10.h),
        AppTextField(
          hint: 'Mobile Number',
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(Icons.call_outlined),
          initialValue: controller.mobile.value,
          onChanged: controller.onMobileChanged,
        ),
        SizedBox(height: 10.h),
        AppTextField(
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.mail_outline_rounded),
          initialValue: controller.email.value,
          onChanged: controller.onEmailChanged,
        ),
        SizedBox(height: 10.h),
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
        SizedBox(height: 10.h),
        Obx(
          () => AppTextField(
            hint: 'Confirm Password',
            obscureText: controller.isConfirmPasswordHidden.value,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              onPressed: controller.toggleConfirmPasswordVisibility,
              icon: Icon(
                controller.isConfirmPasswordHidden.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
            initialValue: controller.confirmPassword.value,
            onChanged: controller.onConfirmPasswordChanged,
          ),
        ),
        SizedBox(height: AppDimensions.sectionSpacing),
        PrimaryButton(
          label: 'Create Account',
          onPressed: () => controller.setStage(AuthStage.otpVerification),
        ),
        SizedBox(height: 10.h),
        TextButton(
          onPressed: () => controller.setStage(AuthStage.login),
          child: const Text('Already have account? Sign in'),
        ),
      ],
    );
  }
}
