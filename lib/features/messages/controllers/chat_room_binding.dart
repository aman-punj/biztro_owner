import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/features/messages/controllers/chat_room_controller.dart';
import 'package:bizrato_owner/features/messages/data/repositories/chat_repository.dart';
import 'package:get/get.dart';

class ChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ChatRepository>()) {
      Get.lazyPut(() => ChatRepository(Get.find<ApiClient>()));
    }
    Get.lazyPut(() => ChatRoomController(Get.find<ChatRepository>()));
  }
}
