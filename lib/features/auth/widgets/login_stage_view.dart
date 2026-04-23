import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/features/auth/controllers/auth_controller.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_bottom_prompt.dart';
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
          title: 'Mobile No.',
          keyboardType: TextInputType.number,
          prefixIcon: Icon(Icons.person_outline_rounded, size: 14.sp),
          initialValue: controller.mobile.value,
          onChanged: controller.onEmailChanged,
        ),
        SizedBox(height: 20.h),
        Obx(
          () => AppTextField(
            title: 'Password',
            obscureText: controller.isPasswordHidden.value,
            prefixIcon: Icon(Icons.lock_outline_rounded, size: 14.sp),
            suffixIcon: IconButton(
              onPressed: controller.togglePasswordVisibility,
              icon: Icon(
                controller.isPasswordHidden.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 14.sp,
                color: AppTokens.textSecondary,
              ),
            ),
            initialValue: controller.password.value,
            onChanged: controller.onPasswordChanged,
          ),
        ),
        SizedBox(height: 20.h),
        Obx(
          () => Row(
            children: [
              InkWell(
                onTap: controller.toggleRememberMe,
                child: Row(
                  children: [
                    Icon(
                      controller.rememberMe.value
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      size: 12.sp,
                      color: AppTokens.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Remember Me',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.setStage(AuthStage.forgotPassword),
                child: Text(
                  'Forgot Password',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTokens.brandPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20.h),
        // SizedBox(height: AppDimensions.sectionSpacing),
        Obx(
          () => PrimaryButton(
            label: 'Secure Login',
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
                    color: AppTokens.error,
                  ),
                ),
        ),
        SizedBox(height: 12.h),
        AuthBottomPrompt(
          question: 'Don\'t have an account ?',
          actionText: 'Sign Up Now',
          onTap: () => controller.setStage(AuthStage.register),
        ),
      ],
    );
  }
}
