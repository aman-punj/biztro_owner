import 'dart:io';

import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/features/auth/services/logout_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import 'package:bizrato_owner/core/network/app_errors.dart';
import 'package:bizrato_owner/core/network/app_response.dart';

class ApiClient extends GetxService {
  ApiClient({
    Dio? dio,
    this.baseUrl = 'https://merchantapi.bizrato.com',
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
  }) : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: connectTimeout,
              receiveTimeout: receiveTimeout,
              responseType: ResponseType.json,
            )) {
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
      responseHeader: false,
      requestBody: true,
      requestHeader: false,
    ));
    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) {
        final authStorage = Get.find<AuthStorage>();
        final token = authStorage.token;
        if (token?.isNotEmpty ?? false) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onResponse: (response, handler) => handler.next(response),
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final authStorage = Get.find<AuthStorage>();
          final hasToken = (authStorage.token?.isNotEmpty ?? false);
          if (hasToken) {
            await authStorage.clear();
            // Future: attempt token refresh here before logout
            await Get.find<LogoutService>().logout();
            return;
          }
        }
        handler.next(error);
      },
    ));
  }

  final String baseUrl;
  final Dio _dio;

  Future<AppResponse<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _send(() => _dio.get(path, queryParameters: queryParameters));
  }

  Future<AppResponse<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _send(() => _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
        ));
  }

  Future<AppResponse<List<int>>> getBytes(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        path,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.bytes),
      );

      final statusCode = response.statusCode ?? 0;
      final success = statusCode >= 200 && statusCode < 300;
      final bytes = response.data;

      if (!success || bytes == null) {
        return AppResponse<List<int>>.failure(
          message: response.statusMessage ?? AppErrors.unknown,
          statusCode: statusCode,
          data: bytes,
        );
      }

      return AppResponse<List<int>>(
        success: true,
        data: bytes,
        message: response.statusMessage ?? '',
        statusCode: statusCode,
      );
    } on DioException catch (error) {
      return AppResponse<List<int>>.failure(
        message: _messageFromDioException(error),
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
    } catch (_) {
      return AppResponse<List<int>>.failure(message: AppErrors.unknown);
    }
  }

  Future<AppResponse<dynamic>> _send(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      return AppResponse.fromResponse(response);
    } on DioException catch (error) {
      return AppResponse.failure(
        message: _messageFromDioException(error),
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
    } catch (_) {
      return AppResponse.failure(message: AppErrors.unknown);
    }
  }

  String _messageFromDioException(DioException error) {
    if (_isNoInternet(error)) {
      return AppErrors.noInternet;
    }

    if (_isConnectionIssue(error)) {
      return AppErrors.noInternet;
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return AppErrors.serverNotResponding;
    }

    final serverMessage = AppResponse.extractMessage(error.response?.data);
    if (serverMessage.isNotEmpty) {
      return serverMessage;
    }

    return error.response?.statusMessage ?? error.message ?? AppErrors.unknown;
  }

  bool _isConnectionIssue(DioException error) {
    final errorType = error.type;
    final message = (error.message ?? '').toLowerCase();

    return errorType == DioExceptionType.connectionError ||
        message.contains('socketexception') ||
        message.contains('connection error') ||
        message.contains('failed host lookup') ||
        message.contains('network is unreachable') ||
        message.contains('network unreachable') ||
        message.contains('connection refused');
  }

  bool _isNoInternet(DioException error) {
    final errorType = error.type;
    return errorType == DioExceptionType.unknown &&
        error.error is SocketException;
  }
}
