import 'package:biztro_owner/core/theme/dimensions.dart';
import 'package:biztro_owner/core/widgets/app_text_field.dart';
import 'package:biztro_owner/core/widgets/primary_button.dart';
import 'package:biztro_owner/core/widgets/section_title.dart';
import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordStageView extends GetView<AuthController> {
  const ForgotPasswordStageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Forgot Password',
          subtitle: 'Enter your email to receive a reset link.',
        ),
        SizedBox(height: AppDimensions.sectionSpacing),
        AppTextField(
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.mail_outline_rounded),
          initialValue: controller.email.value,
          onChanged: controller.onEmailChanged,
        ),
        SizedBox(height: 20.h),
        PrimaryButton(label: 'Send reset link', onPressed: controller.onSubmit),
        SizedBox(height: 14.h),
        Center(
          child: TextButton(
            onPressed: () => controller.setStage(AuthStage.login),
            child: const Text('Back to login'),
          ),
        ),
      ],
    );
  }
}
