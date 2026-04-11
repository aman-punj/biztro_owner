import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/features/trusted_shield/controllers/trusted_shield_controller.dart';
import 'package:bizrato_owner/features/trusted_shield/data/repositories/trusted_shield_repository.dart';
import 'package:get/get.dart';

class TrustedShieldBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }

    Get.lazyPut<TrustedShieldRepository>(
      () => TrustedShieldRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<TrustedShieldController>(
      () => TrustedShieldController(
        repository: Get.find<TrustedShieldRepository>(),
      ),
    );
  }
}
