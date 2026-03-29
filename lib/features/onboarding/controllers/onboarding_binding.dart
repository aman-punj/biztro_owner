import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/features/onboarding/controllers/onboarding_controller.dart';
import 'package:bizrato_owner/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:get/get.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient());
    Get.lazyPut<OnboardingRepository>(
      () => OnboardingRepository(apiClient: Get.find()),
    );
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(onboardingRepository: Get.find()),
    );
  }
}
