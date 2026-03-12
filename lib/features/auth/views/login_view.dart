import 'package:biztro_owner/core/theme/dimensions.dart';
import 'package:biztro_owner/core/widgets/app_card.dart';
import 'package:biztro_owner/core/widgets/app_scaffold_app_bar.dart';
import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:biztro_owner/features/auth/widgets/auth_logo_section.dart';
import 'package:biztro_owner/features/auth/widgets/auth_stage_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppScaffoldAppBar(title: 'Login', showBack: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
            vertical: 20.h,
          ),
          child: Column(
            children: [
              const AuthLogoSection(),
              AppCard(
                padding: EdgeInsets.all(18.w),
                child: Obx(
                  () => AuthStageContent(stage: controller.currentStage.value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
