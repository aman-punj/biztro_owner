import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:bizrato_owner/core/widgets/app_card.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:bizrato_owner/core/widgets/custom_app_bar.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/core/widgets/section_title.dart';
import 'package:bizrato_owner/features/auth/controllers/login_controller.dart';
import 'package:bizrato_owner/features/auth/widgets/login_footer.dart';
import 'package:bizrato_owner/features/auth/widgets/login_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Sign In'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
            vertical: AppDimensions.screenVerticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 8.h),
              const LoginLogo(),
              SizedBox(height: 30.h),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SectionTitle(
                      title: 'Welcome back',
                      subtitle: 'Sign in to manage your business dashboard',
                    ),
                    SizedBox(height: 20.h),
                    AppTextField(
                      controller: controller.emailController,
                      hintText: 'Email address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => AppTextField(
                        controller: controller.passwordController,
                        hintText: 'Password',
                        obscureText: controller.isPasswordHidden.value,
                        textInputAction: TextInputAction.done,
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20.sp,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: controller.onForgotPasswordTap,
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    PrimaryButton(
                      label: 'Sign In',
                      onPressed: controller.onSignInTap,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              LoginFooter(
                onRegisterTap: controller.onRegisterTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
