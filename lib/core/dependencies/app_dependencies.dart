import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/core/storage/storage_service.dart';
import 'package:bizrato_owner/core/services/image_compression_service.dart';
import 'package:bizrato_owner/features/auth/services/logout_service.dart';
import 'package:bizrato_owner/core/services/chat_service.dart';
import 'package:bizrato_owner/core/services/notification_service.dart';
import 'package:bizrato_owner/features/auth/data/repositories/device_repository.dart';
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

    final authStorage =
        Get.put<AuthStorage>(AuthStorage(storageService), permanent: true);
    Get.put<LogoutService>(LogoutService(authStorage), permanent: true);
    Get.put<AppToastService>(AppToastService(), permanent: true);
    Get.put<ImageCompressionService>(ImageCompressionServiceImpl(),
        permanent: true);

    final apiClient = Get.put<ApiClient>(ApiClient(), permanent: true);
    Get.put<DeviceRepository>(DeviceRepository(apiClient), permanent: true);

    await Get.putAsync<NotificationService>(
      () => NotificationService().init(),
      permanent: true,
    );

    // Initialize ChatService with business ID if user is logged in
    if (authStorage.businessId != null && authStorage.businessId!.isNotEmpty) {
      print('Initializing ChatService with business ID: ${authStorage.businessId}');
      await Get.putAsync<ChatService>(
        () => ChatService().init(businessId: authStorage.businessId!),
        permanent: true,
      );
    } else {
      await Get.putAsync<ChatService>(
        () => ChatService().init(businessId: 'temp'),
        permanent: true,
      );
    }

    if (authStorage.isLoggedIn) {
      Get.find<NotificationService>().uploadToken();
    }

    _initialized = true;
  }
}
