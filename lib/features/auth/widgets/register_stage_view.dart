import 'package:biztro_owner/core/theme/dimensions.dart';
import 'package:biztro_owner/core/widgets/app_text_field.dart';
import 'package:biztro_owner/core/widgets/primary_button.dart';
import 'package:biztro_owner/core/widgets/section_title.dart';
import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterStageView extends GetView<AuthController> {
  const RegisterStageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Create your account',
          subtitle: 'Join Biztro and continue your onboarding journey.',
        ),
        SizedBox(height: AppDimensions.sectionSpacing),
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
        SizedBox(height: 20.h),
        PrimaryButton(label: 'Create account', onPressed: controller.onSubmit),
        SizedBox(height: 14.h),
        Center(
          child: TextButton(
            onPressed: () => controller.setStage(AuthStage.login),
            child: const Text('Already have an account? Sign in'),
          ),
        ),
      ],
    );
  }
}
