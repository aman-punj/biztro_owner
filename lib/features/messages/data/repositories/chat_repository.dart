import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:dio/dio.dart';

class ChatRepository {
  final ApiClient _apiClient;

  ChatRepository(this._apiClient);

  Future<AppResponse<dynamic>> getChatList() async {
    return await  _apiClient.get('/api/chat/GetChatList');
  }

  Future<AppResponse<dynamic>> getChatHistory(String userId) async {
    return _apiClient.get('/api/chat/GetChatHistory', queryParameters: {'userId': userId});
  }

  Future<AppResponse<dynamic>> uploadAttachment(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    return _apiClient.post(
      '/api/chat/upload-attachment',
      data: formData,
    );
  }
}
