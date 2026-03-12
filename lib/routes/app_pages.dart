import 'package:bizrato_owner/features/auth/controllers/login_binding.dart';
import 'package:bizrato_owner/features/auth/views/login_view.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_binding.dart';
import 'package:bizrato_owner/features/dashboard/views/dashboard_view.dart';
import 'package:bizrato_owner/features/onboarding/controllers/onboarding_binding.dart';
import 'package:bizrato_owner/features/onboarding/views/onboarding_view.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<LoginView>(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage<OnboardingView>(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage<DashboardView>(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
  ];
}
