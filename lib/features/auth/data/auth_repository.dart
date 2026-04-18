import 'dart:convert';

import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/features/auth/data/models/login_request.dart';
import 'package:bizrato_owner/features/auth/data/models/otp_verification_request.dart';
import 'package:bizrato_owner/features/auth/data/models/signup_request.dart';
import 'package:bizrato_owner/features/auth/data/models/user_model.dart';

class AuthRepository {
  AuthRepository({
    required this.apiClient,
    required this.authStorage,
  });

  final ApiClient apiClient;
  final AuthStorage authStorage;

  Future<AppResponse<dynamic>> getTestData() =>
      apiClient.get('/api/auth/test');

  Future<AppResponse<UserModel>> login(LoginRequest request) async {
    final response =
        await apiClient.post('/api/auth/login', data: request.toJson());

    if (!response.success) {
      return AppResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
      );
    }

    final payload = response.data;
    if (payload is! Map<String, dynamic>) {
      return AppResponse.failure(
        message: 'Invalid login response',
        statusCode: response.statusCode,
      );
    }

    final token = payload['Token']?.toString() ?? '';
    final userPayload = payload['User'];
    if (userPayload is! Map<String, dynamic>) {
      return AppResponse.failure(
        message: 'Invalid user data',
        statusCode: response.statusCode,
      );
    }

    final user = UserModel.fromJson(userPayload);
    await Future.wait([
      authStorage.saveToken(token),
      authStorage.saveMerchantId(user.merchantId),
      authStorage.saveBusinessId(user.businessId),
      authStorage.saveProfileStep(user.businessProfileStep),
      authStorage.saveUserJson(jsonEncode(user.toJson())),
    ]);

    return AppResponse<UserModel>(
      success: true,
      message: response.message,
      data: user,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<dynamic>> signup(SignupRequest request) =>
      apiClient.post('/api/auth/signup', data: request.toJson());

  Future<AppResponse<dynamic>> verifyOtp(OtpVerificationRequest request) =>
      apiClient.post('/api/auth/verify-otp', data: request.toJson());

  Future<AppResponse<dynamic>> search(String term) => apiClient.get(
        '/api/auth/search',
        queryParameters: {'term': term},
      );

  Future<AppResponse<dynamic>> getKeywords(String categoryId) =>
      apiClient.get(
        '/api/auth/get-keywords',
        queryParameters: {'categoryId': categoryId},
      );
}
