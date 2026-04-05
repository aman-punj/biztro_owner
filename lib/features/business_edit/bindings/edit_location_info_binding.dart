import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/features/business_edit/controllers/edit_location_info_controller.dart';
import 'package:bizrato_owner/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:get/get.dart';

class EditLocationInfoBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }

    if (!Get.isRegistered<OnboardingRepository>()) {
      Get.put(OnboardingRepository(apiClient: Get.find()));
    }

    Get.lazyPut<EditLocationInfoController>(
      () => EditLocationInfoController(
        repository: Get.find<OnboardingRepository>(),
      ),
    );
  }
}
