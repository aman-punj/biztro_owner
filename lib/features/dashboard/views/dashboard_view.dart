import 'package:biztro_owner/core/widgets/app_scaffold_app_bar.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppScaffoldAppBar(title: 'Dashboard'),
      body: Center(child: Text('Dashboard UI coming soon')),
    );
  }
}
