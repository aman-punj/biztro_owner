import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/features/course/data/models/course_model.dart';

class CourseRepository {
  CourseRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<AppResponse<List<CourseModel>>> getCourses() async {
    final response = await apiClient.get('/api/courses/GetCoursesList');

    if (!response.success || response.data is! Map<String, dynamic>) {
      return AppResponse<List<CourseModel>>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final result = _extractResult(response.data as Map<String, dynamic>);
    final courses = result.map(CourseModel.fromJson).toList();

    return AppResponse<List<CourseModel>>(
      success: true,
      data: courses,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  Future<AppResponse<List<CourseVideoModel>>> getCourseDetails(int courseId) async {
    final response = await apiClient.get('/api/courses/GetCourseDetails/$courseId');

    if (!response.success || response.data is! Map<String, dynamic>) {
      return AppResponse<List<CourseVideoModel>>.failure(
        message: response.message,
        statusCode: response.statusCode,
        data: response.data,
      );
    }

    final result = _extractResult(response.data as Map<String, dynamic>);
    final videos = result.map(CourseVideoModel.fromJson).toList();

    return AppResponse<List<CourseVideoModel>>(
      success: true,
      data: videos,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  List<Map<String, dynamic>> _extractResult(Map<String, dynamic> payload) {
    final data = payload['data'];
    if (data is! Map<String, dynamic>) {
      return <Map<String, dynamic>>[];
    }

    final result = data['Result'];
    if (result is! List) {
      return <Map<String, dynamic>>[];
    }

    return result.whereType<Map<String, dynamic>>().toList();
  }
}
