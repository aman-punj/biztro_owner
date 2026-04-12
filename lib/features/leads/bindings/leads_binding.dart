import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/features/leads/controllers/leads_controller.dart';
import 'package:bizrato_owner/features/leads/data/repositories/leads_repository.dart';
import 'package:get/get.dart';

class LeadsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadsRepository>(
      () => LeadsRepository(
        Get.find<ApiClient>(),
        Get.find<AuthStorage>(),
      ),
    );
    Get.lazyPut<LeadsController>(
      () => LeadsController(Get.find<LeadsRepository>()),
    );
  }
}
