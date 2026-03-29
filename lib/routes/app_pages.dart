import 'package:bizrato_owner/features/auth/bindings/auth_binding.dart';
import 'package:bizrato_owner/features/auth/views/login_view.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_binding.dart';
import 'package:bizrato_owner/features/dashboard/views/dashboard_view.dart';
import 'package:bizrato_owner/features/messages/controllers/messages_binding.dart';
import 'package:bizrato_owner/features/messages/views/messages_view.dart';
import 'package:bizrato_owner/features/onboarding/controllers/onboarding_binding.dart';
import 'package:bizrato_owner/features/onboarding/views/onboarding_view.dart';
import 'package:bizrato_owner/features/splash/views/splash_view.dart';
import 'package:bizrato_owner/features/trusted_shield/controllers/trusted_shield_binding.dart';
import 'package:bizrato_owner/features/trusted_shield/views/trusted_shield_view.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage<dynamic>>[
    GetPage<SplashView>(
      name: AppRoutes.splash,
      page: SplashView.new,
    ),
    GetPage<LoginView>(
      name: AppRoutes.login,
      page: LoginView.new,
      binding: AuthBinding(),
    ),
    GetPage<OnboardingView>(
      name: AppRoutes.onboarding,
      page: OnboardingView.new,
      binding: OnboardingBinding(),
    ),
    GetPage<DashboardView>(
      name: AppRoutes.dashboard,
      page: DashboardView.new,
      binding: DashboardBinding(),
    ),
    GetPage<TrustedShieldView>(
      name: AppRoutes.trustedShield,
      page: TrustedShieldView.new,
      binding: TrustedShieldBinding(),
    ),
    GetPage<MessagesView>(
      name: AppRoutes.messages,
      page: MessagesView.new,
      binding: MessagesBinding(),
    ),
  ];
}
