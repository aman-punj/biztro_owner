import 'package:bizrato_owner/features/trusted_shield/controllers/trusted_shield_controller.dart';
import 'package:get/get.dart';

class TrustedShieldBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrustedShieldController>(TrustedShieldController.new);
  }
}
