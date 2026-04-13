import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/core/storage/storage_service.dart';
import 'package:bizrato_owner/core/services/image_compression_service.dart';
import 'package:bizrato_owner/features/auth/services/logout_service.dart';
import 'package:bizrato_owner/core/services/chat_service.dart';
import 'package:get/get.dart';

class AppDependencies {
  AppDependencies._();

  static bool _initialized = false;

  static Future<void> init({bool force = false}) async {
    if (_initialized && !force) return;
    if (force) {
      _initialized = false;
    }

    final storageService = await Get.putAsync<StorageService>(
      () => StorageService().init(),
      permanent: true,
    );

    Get.put<AuthStorage>(AuthStorage(storageService), permanent: true);
    Get.put<LogoutService>(LogoutService(Get.find<AuthStorage>()), permanent: true);
    Get.put<AppToastService>(AppToastService(), permanent: true);
    Get.put<ImageCompressionService>(ImageCompressionServiceImpl(), permanent: true);
    
    Get.putAsync<ChatService>(
      () => ChatService().init(),
      permanent: true,
    );

    _initialized = true;
  }
}
