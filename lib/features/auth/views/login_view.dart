import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:bizrato_owner/core/widgets/app_card.dart';
import 'package:bizrato_owner/features/auth/controllers/auth_controller.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_footer_text.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_hero_section.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_stage_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  const AuthHeroSection(),
                  Padding(
                    padding: EdgeInsets.only(top: 275.h),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: AppDimensions.maxContentWidth,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenHorizontalPadding,
                          ),
                          child: AppCard(
                            padding:
                                EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 8.h),
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
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              const AuthFooterText(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
