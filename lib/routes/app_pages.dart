import 'package:biztro_owner/features/auth/bindings/auth_binding.dart';
import 'package:biztro_owner/features/auth/views/login_view.dart';
import 'package:biztro_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:biztro_owner/features/dashboard/views/dashboard_view.dart';
import 'package:biztro_owner/features/onboarding/controllers/onboarding_controller.dart';
import 'package:biztro_owner/features/onboarding/views/onboarding_view.dart';
import 'package:biztro_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage<LoginView>(
      name: AppRoutes.login,
      page: LoginView.new,
      binding: AuthBinding(),
    ),
    GetPage<OnboardingView>(
      name: AppRoutes.onboarding,
      page: OnboardingView.new,
      binding: BindingsBuilder(
        () => Get.lazyPut<OnboardingController>(OnboardingController.new),
      ),
    ),
    GetPage<DashboardView>(
      name: AppRoutes.dashboard,
      page: DashboardView.new,
      binding: BindingsBuilder(
        () => Get.lazyPut<DashboardController>(DashboardController.new),
      ),
    ),
  ];
}
