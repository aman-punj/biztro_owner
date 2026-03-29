import 'package:bizrato_owner/core/network/app_errors.dart';
import 'package:dio/dio.dart';

class AppResponse<T> {
  const AppResponse({
    required this.success,
    this.data,
    required this.message,
    this.statusCode,
  });

  factory AppResponse.fromResponse(Response<dynamic> response) {
    final statusCode = response.statusCode ?? 0;
    final success = statusCode >= 200 && statusCode < 300;
    final payload = response.data;
    final extractedMessage = extractMessage(payload);
    final fallbackMessage = response.statusMessage ?? AppErrors.unknown;

    return AppResponse(
      success: success,
      data: payload,
      message: success
          ? extractedMessage
          : (extractedMessage.isNotEmpty ? extractedMessage : fallbackMessage),
      statusCode: statusCode,
    );
  }

  factory AppResponse.failure({
    required String message,
    int? statusCode,
    dynamic data,
  }) =>
      AppResponse(
        success: false,
        message: message,
        statusCode: statusCode,
        data: data,
      );

  static String extractMessage(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      final messageValue =
          payload['message'] ?? payload['Message'] ?? payload['MessageText'];
      if (messageValue is String && messageValue.isNotEmpty) {
        return messageValue;
      }
    }
    return '';
  }

  final bool success;
  final T? data;
  final String message;
  final int? statusCode;
}
