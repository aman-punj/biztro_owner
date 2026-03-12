import 'package:bizrato_owner/core/widgets/custom_app_bar.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Dashboard'),
      body: Center(
        child: Text('Dashboard Screen'),
      ),
    );
  }
}
