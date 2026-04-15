import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/network/app_response.dart';

class DeviceRepository {
  DeviceRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<AppResponse<dynamic>> updateDeviceToken({
    required String fcmToken,
    String deviceType = 'android',
  }) async {
    return _apiClient.post(
      '/api/UserDevice/UpdateDeviceToken',
      data: {
        'FCMToken': fcmToken,
        'DeviceType': deviceType,
      },
    );
  }
}
