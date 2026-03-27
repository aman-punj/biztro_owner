import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import 'network_exception.dart';

class ApiClient extends GetxService {
  ApiClient({
    Dio? dio,
    this.baseUrl = 'https://merchantapi.bizrato.com',
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
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
  }

  final String baseUrl;
  final Dio _dio;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _send(() => _dio.get(path, queryParameters: queryParameters));
  }

  Future<dynamic> post(
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

  Future<dynamic> _send(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      return _handleResponse(response);
    } on DioError catch (error) {
      throw NetworkException.fromDio(error);
    }
  }

  dynamic _handleResponse(Response<dynamic> response) {
    final statusCode = response.statusCode ?? 0;
    if (statusCode >= 200 && statusCode < 300) {
      return response.data;
    }
    throw NetworkException(
      statusCode: statusCode,
      message: response.statusMessage ?? 'Unknown server failure',
    );
  }
}
