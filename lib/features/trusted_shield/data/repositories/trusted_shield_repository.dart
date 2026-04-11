import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/features/trusted_shield/data/models/trusted_shield_kyc_model.dart';
import 'package:dio/dio.dart';

class TrustedShieldRepository {
  TrustedShieldRepository({required this.apiClient});

  final ApiClient apiClient;
  static const String _imageHost = 'https://mybizimages.in';

  Future<AppResponse<TrustedShieldKycModel?>> getKycDetails(
    int merchantId,
  ) async {
    final response = await _getKycDetailsResponse(merchantId);

    if (!response.success) {
      return AppResponse<TrustedShieldKycModel?>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    if (response.data is! Map<String, dynamic>) {
      return AppResponse<TrustedShieldKycModel?>.failure(
        message: 'Unable to load KYC details.',
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final payload = response.data as Map<String, dynamic>;
    final nested = _extractDataMap(payload);
    final message = _extractNestedMessage(payload, response.message);
    final isSuccessful = nested['IsSuccessful'] == true;

    if (!isSuccessful) {
      return AppResponse<TrustedShieldKycModel?>(
        success: true,
        data: null,
        message: message,
        statusCode: response.statusCode,
      );
    }

    final result = nested['Result'];
    if (result is! Map<String, dynamic>) {
      return AppResponse<TrustedShieldKycModel?>(
        success: true,
        data: null,
        message: message,
        statusCode: response.statusCode,
      );
    }

    return AppResponse<TrustedShieldKycModel?>(
      success: true,
      data: TrustedShieldKycModel.fromJson(result),
      message: message,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<dynamic>> _getKycDetailsResponse(int merchantId) async {
    final attempts = <Future<AppResponse<dynamic>> Function()>[
      () => apiClient.get(
            '/api/trustedshield/GetKycDetails',
            queryParameters: <String, dynamic>{'merchantId': merchantId},
          ),
      () => apiClient.get('/api/trustedshield/GetKycDetails/$merchantId'),
      () => apiClient.get(
            '/api/TrustedShield/GetKycDetails',
            queryParameters: <String, dynamic>{'merchantId': merchantId},
          ),
      () => apiClient.get('/api/TrustedShield/GetKycDetails/$merchantId'),
    ];

    AppResponse<dynamic>? lastResponse;
    for (final attempt in attempts) {
      final response = await attempt();
      if (response.success) {
        return response;
      }

      lastResponse = response;
      if (response.statusCode != 404) {
        return response;
      }
    }

    return lastResponse ??
        AppResponse<dynamic>.failure(
          message: 'Unable to load KYC details.',
        );
  }

  Future<AppResponse<void>> saveKyc({
    required String merchantId,
    required String bizId,
    required String firmName,
    required String gstNumber,
    required String panNumber,
    required String aadhaarNumber,
    String? gstImagePath,
    String? panImagePath,
    String? aadhaarFrontImagePath,
    String? aadhaarBackImagePath,
    String? liveImagePath,
    String? oldGstPath,
    String? oldPanPath,
    String? oldAadharFrontPath,
    String? oldAadharBackPath,
    String? oldLivePath,
  }) async {
    try {
      final formData = FormData();
      formData.fields.addAll(<MapEntry<String, String>>[
        MapEntry<String, String>('MerchantId', merchantId),
        MapEntry<String, String>('BizId', bizId),
        MapEntry<String, String>('FirmName', firmName),
        MapEntry<String, String>('GstNumber', gstNumber),
        MapEntry<String, String>('PanNumber', panNumber),
        MapEntry<String, String>('AadhaarNumber', aadhaarNumber),
      ]);

      _addOldPathField(formData, 'OldGstPath', oldGstPath);
      _addOldPathField(formData, 'OldPanPath', oldPanPath);
      _addOldPathField(formData, 'OldAadharFrontPath', oldAadharFrontPath);
      _addOldPathField(formData, 'OldAadharBackPath', oldAadharBackPath);
      _addOldPathField(formData, 'OldLivePath', oldLivePath);

      await _addFileIfPresent(formData, 'GstImagePath', gstImagePath);
      await _addFileIfPresent(formData, 'PanImagePath', panImagePath);
      await _addFileIfPresent(
        formData,
        'AadharFrontImagePath',
        aadhaarFrontImagePath,
      );
      await _addFileIfPresent(
        formData,
        'AadhaarBackImagePath',
        aadhaarBackImagePath,
      );
      await _addFileIfPresent(formData, 'LiveImagePath', liveImagePath);

      final response = await apiClient.post(
        '/api/trustedshield/SaveKyc',
        data: formData,
      );

      if (!response.success) {
        return AppResponse<void>.failure(
          message: response.message,
          statusCode: response.statusCode,
          data: response.data,
        );
      }

      if (response.data is! Map<String, dynamic>) {
        return AppResponse<void>.failure(
          message: 'Unable to save KYC details.',
          statusCode: response.statusCode,
          data: response.data,
        );
      }

      final payload = response.data as Map<String, dynamic>;
      final nested = _extractDataMap(payload);
      final message = _extractNestedMessage(payload, response.message);
      final isSuccessful =
          nested.isEmpty ? payload['success'] == true : nested['IsSuccessful'] == true;

      if (!isSuccessful) {
        return AppResponse<void>.failure(
          message: message,
          statusCode: response.statusCode,
          data: response.data,
        );
      }

      return AppResponse<void>(
        success: true,
        message: message,
        statusCode: response.statusCode,
      );
    } catch (_) {
      return AppResponse<void>.failure(message: 'Unable to save KYC details.');
    }
  }

  String buildImageUrl(String path) {
    final normalizedPath = path.trim();
    if (normalizedPath.isEmpty) {
      return '';
    }

    if (normalizedPath.startsWith('http://') ||
        normalizedPath.startsWith('https://')) {
      return normalizedPath;
    }

    final sanitizedPath = normalizedPath.replaceFirst(RegExp(r'^/+'), '');
    return '$_imageHost/$sanitizedPath';
  }

  Map<String, dynamic> _extractDataMap(Map<String, dynamic> payload) {
    final data = payload['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }

    return <String, dynamic>{};
  }

  String _extractNestedMessage(
    Map<String, dynamic> payload,
    String fallbackMessage,
  ) {
    final nested = _extractDataMap(payload);
    final nestedMessage = nested['Message']?.toString() ?? '';
    if (nestedMessage.isNotEmpty) {
      return nestedMessage;
    }

    return fallbackMessage;
  }

  Future<void> _addFileIfPresent(
    FormData formData,
    String fieldName,
    String? filePath,
  ) async {
    if (filePath == null || filePath.isEmpty) {
      return;
    }

    formData.files.add(
      MapEntry<String, MultipartFile>(
        fieldName,
        await MultipartFile.fromFile(filePath),
      ),
    );
  }

  void _addOldPathField(
    FormData formData,
    String fieldName,
    String? path,
  ) {
    if (path == null || path.isEmpty) {
      return;
    }

    formData.fields.add(MapEntry<String, String>(fieldName, path));
  }
}
