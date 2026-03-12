import 'package:bizrato_owner/core/widgets/custom_app_bar.dart';
import 'package:bizrato_owner/features/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Onboarding'),
      body: Center(
        child: Text('Onboarding Screen'),
      ),
    );
  }
}
