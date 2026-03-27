import 'dart:io';

import 'package:bizrato_owner/core/network/app_errors.dart';
import 'package:dio/dio.dart';

class NetworkException implements Exception {
  NetworkException({
    this.statusCode,
    required this.message,
    this.isConnectionError = false,
  });

  factory NetworkException.fromDio(DioError error) {
    final statusCode = error.response?.statusCode;
    if (_isConnectionError(error)) {
      return NetworkException(
        statusCode: statusCode,
        message: AppErrors.noInternet,
        isConnectionError: true,
      );
    }

    final dynamic body = error.response?.data;
    final message = body is Map<String, dynamic>
        ? body['message']?.toString()
        : error.response?.statusMessage ?? error.message;

    final text = (message?.isEmpty ?? true) ? AppErrors.unknown : message!;
    return NetworkException(
      statusCode: statusCode,
      message: text,
    );
  }

  static bool _isConnectionError(DioError error) {
    final errorType = error.type;
    return errorType == DioErrorType.connectionTimeout ||
        errorType == DioErrorType.receiveTimeout ||
        errorType == DioErrorType.sendTimeout ||
        (errorType == DioErrorType.unknown && error.error is SocketException);
  }

  final int? statusCode;
  final String message;
  final bool isConnectionError;

  @override
  String toString() => 'NetworkException($statusCode): $message';
}
