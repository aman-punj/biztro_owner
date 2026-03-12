import 'package:biztro_owner/core/theme/dimensions.dart';
import 'package:biztro_owner/core/widgets/app_card.dart';
import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:biztro_owner/features/auth/widgets/auth_hero_section.dart';
import 'package:biztro_owner/features/auth/widgets/auth_stage_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AuthHeroSection(),
              Transform.translate(
                offset: Offset(0, -20.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontalPadding,
                  ),
                  child: AppCard(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                    child: Obx(
                      () => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        child: AuthStageContent(
                          key: ValueKey(controller.currentStage.value),
                          stage: controller.currentStage.value,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
