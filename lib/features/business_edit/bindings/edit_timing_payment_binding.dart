import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/features/business_edit/controllers/edit_timing_payment_controller.dart';
import 'package:bizrato_owner/features/business_edit/data/repositories/business_timing_repository.dart';
import 'package:get/get.dart';

class EditTimingPaymentBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }

    if (!Get.isRegistered<BusinessTimingRepository>()) {
      Get.put(BusinessTimingRepository(apiClient: Get.find<ApiClient>()));
    }

    Get.lazyPut<EditTimingPaymentController>(
      () => EditTimingPaymentController(
        repository: Get.find<BusinessTimingRepository>(),
      ),
    );
  }
}
