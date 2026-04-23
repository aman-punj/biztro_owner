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

  _AuthSession? _sessionFromPayload(dynamic payload) {
    if (payload is! Map<String, dynamic>) return null;

    final token = payload['Token']?.toString() ?? '';
    final userPayload = payload['User'];
    if (token.isEmpty || userPayload is! Map<String, dynamic>) return null;

    return _AuthSession(token: token, user: UserModel.fromJson(userPayload));
  }

  Future<void> _persistSession(_AuthSession session) async {
    final user = session.user;
    await Future.wait([
      authStorage.saveToken(session.token),
      authStorage.saveMerchantId(user.merchantId),
      authStorage.saveBusinessId(user.businessId),
      authStorage.saveProfileStep(user.businessProfileStep),
      authStorage.saveUserJson(jsonEncode(user.toJson())),
    ]);
  }

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

    final session = _sessionFromPayload(response.data);
    if (session == null) {
      return AppResponse.failure(
        message: 'Invalid login response',
        statusCode: response.statusCode,
      );
    }

    await _persistSession(session);

    return AppResponse<UserModel>(
      success: true,
      message: response.message,
      data: session.user,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<dynamic>> signup(SignupRequest request) =>
      apiClient.post('/api/auth/signup', data: request.toJson());

  Future<AppResponse<dynamic>> verifyOtp(OtpVerificationRequest request) =>
      apiClient.post('/api/auth/verify-otp', data: request.toJson());

  Future<AppResponse<UserModel>> verifyOtpAndHydrateSession({
    required OtpVerificationRequest request,
    required LoginRequest fallbackLoginRequest,
  }) async {
    final response =
        await apiClient.post('/api/auth/verify-otp', data: request.toJson());

    if (!response.success) {
      return AppResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final session = _sessionFromPayload(response.data);
    if (session != null) {
      await _persistSession(session);
      return AppResponse<UserModel>(
        success: true,
        message: response.message,
        data: session.user,
        statusCode: response.statusCode,
      );
    }

    // Backend doesn't provide auth session after OTP verification.
    // Perform background login so we persist token/merchant/business/profileStep like normal login.
    return login(fallbackLoginRequest);
  }

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

class _AuthSession {
  const _AuthSession({
    required this.token,
    required this.user,
  });

  final String token;
  final UserModel user;
}
