import 'package:bizrato_owner/features/trusted_shield/controllers/live_identity_verification_controller.dart';
import 'package:get/get.dart';

class LiveIdentityVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LiveIdentityVerificationController>(
      LiveIdentityVerificationController.new,
    );
  }
}
