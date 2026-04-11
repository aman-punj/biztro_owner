import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/features/business_edit/data/models/business_timing_info_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/business_timing_master_data_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/save_business_timing_request.dart';

class BusinessTimingRepository {
  BusinessTimingRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<AppResponse<BusinessTimingMasterDataModel>> getMasterData() async {
    final response = await apiClient.get('/api/business/alltiminginfo');
    if (!response.success) {
      return AppResponse<BusinessTimingMasterDataModel>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data is! Map) {
      return AppResponse<BusinessTimingMasterDataModel>.failure(
        message: 'Timing master data is unavailable.',
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final payload = _forceMap(response.data as Map);
    final isSuccessful = _readBool(payload['IsSuccessful'], fallback: true);
    if (!isSuccessful) {
      return AppResponse<BusinessTimingMasterDataModel>.failure(
        message: _readString(payload['Message'], fallback: response.message),
        statusCode: response.statusCode,
        data: payload,
      );
    }

    return AppResponse<BusinessTimingMasterDataModel>(
      success: true,
      message: _readString(payload['Message'], fallback: response.message),
      data: BusinessTimingMasterDataModel.fromJson(payload),
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<BusinessTimingInfoModel?>> getTimingInfo(
    int merchantId,
  ) async {
    final response = await apiClient.get(
      '/api/business/timinginfo',
      queryParameters: <String, dynamic>{'MerchantId': merchantId},
    );
    if (!response.success) {
      return AppResponse<BusinessTimingInfoModel?>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data is! Map) {
      return AppResponse<BusinessTimingInfoModel?>.failure(
        message: 'Timing information is unavailable.',
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final payload = _forceMap(response.data as Map);
    final result = payload['Result'];
    final message = _readString(payload['Message'], fallback: response.message);
    final isSuccessful = _readBool(payload['IsSuccessful']);

    if (!isSuccessful || result == null) {
      return AppResponse<BusinessTimingInfoModel?>(
        success: true,
        message: message,
        data: null,
        statusCode: response.statusCode,
      );
    }

    return AppResponse<BusinessTimingInfoModel?>(
      success: true,
      message: message,
      data: BusinessTimingInfoModel.fromJson(payload),
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<void>> saveTimingInfo(
    SaveBusinessTimingRequest request,
  ) async {
    final response = await apiClient.post(
      '/api/business/aveBusinesstimingInfo',
      data: request.toJson(),
    );
    if (!response.success) {
      return AppResponse<void>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data is Map) {
      final payload = _forceMap(response.data as Map);
      final isSuccessful = _readBool(payload['IsSuccessful'], fallback: true);
      if (!isSuccessful) {
        return AppResponse<void>.failure(
          message: _readString(payload['Message'], fallback: response.message),
          statusCode: response.statusCode,
          data: response.data,
        );
      }

      return AppResponse<void>(
        success: true,
        message: _readString(payload['Message'], fallback: response.message),
        statusCode: response.statusCode,
      );
    }

    return AppResponse<void>(
      success: true,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Map<String, dynamic> _forceMap(Map raw) {
    return raw.cast<String, dynamic>();
  }

  bool _readBool(dynamic value, {bool fallback = false}) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final normalized = value?.toString().trim().toLowerCase() ?? '';
    if (normalized == 'true' || normalized == '1') {
      return true;
    }
    if (normalized == 'false' || normalized == '0') {
      return false;
    }
    return fallback;
  }

  String _readString(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }
}
