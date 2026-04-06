import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/features/festival/data/models/festival_model.dart';

class FestivalRepository {
  FestivalRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<AppResponse<List<FestivalModel>>> getFestivals() async {
    final response = await apiClient.get('/api/festivals/GetFestivals');

    if (!response.success || response.data is! Map<String, dynamic>) {
      return AppResponse<List<FestivalModel>>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final result = _extractResult(response.data as Map<String, dynamic>);
    final festivals = result.map(FestivalModel.fromJson).toList();
    return AppResponse<List<FestivalModel>>(
      success: true,
      data: festivals,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<List<FestivalPostModel>>> getFestivalDetails(
    int festivalId,
  ) async {
    final response = await apiClient.get('/api/festivals/GetFestivalDetails/$festivalId');

    if (!response.success || response.data is! Map<String, dynamic>) {
      return AppResponse<List<FestivalPostModel>>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final result = _extractResult(response.data as Map<String, dynamic>);
    final details = result.map(FestivalPostModel.fromJson).toList();
    return AppResponse<List<FestivalPostModel>>(
      success: true,
      data: details,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  String buildDownloadUrl(String imagePath) {
    return '${apiClient.baseUrl}/api/festivals/DownloadFestivalImage?imagePath=$imagePath';
  }

  List<Map<String, dynamic>> _extractResult(Map<String, dynamic> payload) {
    final dynamic data = payload['data'];
    if (data is! Map<String, dynamic>) {
      return <Map<String, dynamic>>[];
    }

    final dynamic result = data['Result'];
    if (result is! List) {
      return <Map<String, dynamic>>[];
    }

    return result.whereType<Map<String, dynamic>>().toList();
  }
}
