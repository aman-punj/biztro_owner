import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient());
    Get.lazyPut<OnboardingRepository>(
      () => OnboardingRepository(apiClient: Get.find()),
    );
    Get.lazyPut<DashboardController>(
      () => DashboardController(
        apiClient: Get.find(),
        authStorage: Get.find(),
        onboardingRepository: Get.find(),
      ),
    );
  }
}
