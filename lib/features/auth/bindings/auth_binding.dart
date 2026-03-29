import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../data/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient());
    Get.lazyPut<AuthRepository>(() => AuthRepository(
          apiClient: Get.find(),
          authStorage: Get.find(),
        ));
    Get.lazyPut<AuthController>(() => AuthController(authRepository: Get.find()));
  }
}
