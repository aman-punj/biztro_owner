import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:bizrato_owner/core/widgets/app_card.dart';
import 'package:bizrato_owner/features/auth/controllers/auth_controller.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_footer_text.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_hero_section.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_stage_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Center(
          child: SizedBox(
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const AuthHeroSection(),
                      Transform.translate(
                        offset: Offset(0, -70.h),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenHorizontalPadding,
                          ),
                          child: AppCard(
                            padding:
                                EdgeInsets.fromLTRB(14.w, 20.h, 14.w, 16.h),
                            child: Obx(
                              () => AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                switchInCurve: Curves.easeOutQuint,
                                switchOutCurve: Curves.easeInQuint,
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.05),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutQuad,
                                      )),
                                      child: child,
                                    ),
                                  );
                                },
                                child: AuthStageContent(
                                  key: ValueKey(controller.currentStage.value),
                                  stage: controller.currentStage.value,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: const AuthFooterText(),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
