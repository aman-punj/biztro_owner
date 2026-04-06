import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/features/festival/controllers/festival_controller.dart';
import 'package:bizrato_owner/features/festival/data/repositories/festival_repository.dart';
import 'package:get/get.dart';

class FestivalBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }

    Get.lazyPut<FestivalRepository>(
      () => FestivalRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<FestivalController>(
      () => FestivalController(repository: Get.find<FestivalRepository>()),
    );
  }
}
