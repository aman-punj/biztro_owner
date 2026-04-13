import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/features/messages/controllers/messages_controller.dart';
import 'package:bizrato_owner/features/messages/data/repositories/chat_repository.dart';
import 'package:get/get.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatRepository(Get.find<ApiClient>()));
    Get.lazyPut(() => MessagesController(Get.find<ChatRepository>()));
  }
}
