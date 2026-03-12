import 'package:biztro_owner/core/theme/colors.dart';
import 'package:biztro_owner/core/theme/dimensions.dart';
import 'package:biztro_owner/core/widgets/app_text_field.dart';
import 'package:biztro_owner/core/widgets/primary_button.dart';
import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:biztro_owner/features/auth/widgets/auth_bottom_prompt.dart';
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
          prefixIcon: Icon(Icons.storefront_outlined, size: 14.sp),
          initialValue: controller.businessName.value,
          onChanged: controller.onBusinessNameChanged,
        ),
        SizedBox(height: 8.h),
        AppTextField(
          hint: 'Mobile No.',
          keyboardType: TextInputType.phone,
          prefixIcon: Icon(Icons.phone_android_rounded, size: 14.sp),
          initialValue: controller.mobile.value,
          onChanged: controller.onMobileChanged,
        ),
        SizedBox(height: 8.h),
        AppTextField(
          hint: 'Email ID',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(Icons.mail_outline_rounded, size: 14.sp),
          initialValue: controller.email.value,
          onChanged: controller.onEmailChanged,
        ),
        SizedBox(height: 8.h),
        Obx(
          () => AppTextField(
            hint: 'Password',
            obscureText: controller.isPasswordHidden.value,
            prefixIcon: Icon(Icons.lock_outline_rounded, size: 14.sp),
            suffixIcon: IconButton(
              onPressed: controller.togglePasswordVisibility,
              icon: Icon(
                controller.isPasswordHidden.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 14.sp,
              ),
            ),
            initialValue: controller.password.value,
            onChanged: controller.onPasswordChanged,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => AppTextField(
            hint: 'Confirm Password',
            obscureText: controller.isConfirmPasswordHidden.value,
            prefixIcon: Icon(Icons.lock_outline_rounded, size: 14.sp),
            suffixIcon: IconButton(
              onPressed: controller.toggleConfirmPasswordVisibility,
              icon: Icon(
                controller.isConfirmPasswordHidden.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 14.sp,
              ),
            ),
            initialValue: controller.confirmPassword.value,
            onChanged: controller.onConfirmPasswordChanged,
          ),
        ),
        SizedBox(height: 8.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: const [
              TextSpan(text: 'By signing up, I agree to the '),
              TextSpan(
                text: 'Terms of\nService',
                style: TextStyle(color: AppColors.primary),
              ),
              TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy.',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.sectionSpacing),
        PrimaryButton(
          label: 'Send OTP',
          showArrow: true,
          onPressed: () => controller.setStage(AuthStage.otpVerification),
        ),
        SizedBox(height: 10.h),
        AuthBottomPrompt(
          question: 'Already have an account ?',
          actionText: 'Login Now',
          onTap: () => controller.setStage(AuthStage.login),
        ),
      ],
    );
  }
}
