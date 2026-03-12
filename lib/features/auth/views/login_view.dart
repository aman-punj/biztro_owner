import 'package:biztro_owner/core/theme/dimensions.dart';
import 'package:biztro_owner/core/widgets/app_card.dart';
import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:biztro_owner/features/auth/widgets/auth_footer_text.dart';
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
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 390.w),
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
                      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 16.h),
                      child: Obx(
                        () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          child: AuthStageContent(
                            key: ValueKey(controller.currentStage.value),
                            stage: controller.currentStage.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: const AuthFooterText(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
