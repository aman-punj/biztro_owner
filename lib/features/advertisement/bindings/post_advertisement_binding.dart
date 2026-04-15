import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/features/advertisement/controllers/post_advertisement_controller.dart';
import 'package:bizrato_owner/features/advertisement/data/repositories/advertisement_repository.dart';
import 'package:get/get.dart';

class PostAdvertisementBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }

    if (!Get.isRegistered<AdvertisementRepository>()) {
      Get.put(AdvertisementRepository(apiClient: Get.find<ApiClient>()));
    }

    Get.lazyPut<PostAdvertisementController>(
      () => PostAdvertisementController(
        repository: Get.find<AdvertisementRepository>(),
      ),
    );
  }
}
