import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/features/auth/data/models/login_request.dart';
import 'package:bizrato_owner/features/auth/data/models/otp_verification_request.dart';
import 'package:bizrato_owner/features/auth/data/models/signup_request.dart';

class AuthRepository {
  AuthRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<dynamic> getTestData() => apiClient.get('/api/auth/test');

  Future<dynamic> login(LoginRequest request) =>
      apiClient.post('/api/auth/login', data: request.toJson());

  Future<dynamic> signup(SignupRequest request) =>
      apiClient.post('/api/auth/signup', data: request.toJson());

  Future<dynamic> verifyOtp(OtpVerificationRequest request) =>
      apiClient.post('/api/auth/verify-otp', data: request.toJson());

  Future<dynamic> search(String term) => apiClient.get(
        '/api/auth/search',
        queryParameters: {'term': term},
      );

  Future<dynamic> getKeywords(String categoryId) => apiClient.get(
        '/api/auth/get-keywords',
        queryParameters: {'categoryId': categoryId},
      );
}
