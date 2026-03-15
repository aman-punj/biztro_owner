import 'package:bizrato_owner/core/widgets/app_scaffold_app_bar.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppScaffoldAppBar(title: 'Onboarding'),
      body: Center(child: Text('Onboarding UI coming soon')),
    );
  }
}
