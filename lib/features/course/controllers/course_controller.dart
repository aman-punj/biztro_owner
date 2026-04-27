import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';
import 'package:bizrato_owner/features/course/data/models/course_model.dart';
import 'package:bizrato_owner/features/course/data/repositories/course_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class CourseController extends GetxController {
  CourseController({required this.repository});

  final CourseRepository repository;
  final AppToastService _toastService =
      Get.find<AppToastService>();

  final isLoading = true.obs;
  final isDetailsLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;

  final courses = <CourseModel>[].obs;
  final courseVideos = <CourseVideoModel>[].obs;
  final selectedCourse = Rxn<CourseModel>();

  List<CourseModel> get filteredCourses {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) {
      return courses;
    }

    return courses
        .where((course) => course.courseName.toLowerCase().contains(query))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadCourses();
  }

  Future<void> loadCourses() async {
    isLoading.value = true;
    hasError.value = false;

    final response = await repository.getCourses();
    if (!response.success) {
      hasError.value = true;
      errorMessage.value = response.message;
      isLoading.value = false;
      return;
    }

    courses.assignAll(response.data ?? <CourseModel>[]);
    isLoading.value = false;
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  Future<void> openCourse(CourseModel course) async {
    selectedCourse.value = course;
    isDetailsLoading.value = true;

    final response = await repository.getCourseDetails(course.courseId);
    courseVideos.assignAll(response.data ?? <CourseVideoModel>[]);
    isDetailsLoading.value = false;

    if (response.success) {
      Get.toNamed(AppRoutes.courseDetails);
      return;
    }

    _toastService.error(response.message);
  }

  void openYoutubeVideo({
    required String url,
    required String title,
  }) {
    final sanitizedUrl = url.trim();
    if (sanitizedUrl.isEmpty) {
      _toastService.error('Video link is unavailable.');
      return;
    }

    final videoId = _extractYoutubeVideoId(sanitizedUrl);
    if (videoId == null || videoId.isEmpty) {
      _toastService.error('Invalid YouTube link.');
      return;
    }

    Get.toNamed(
      AppRoutes.courseVideoPlayer,
      arguments: <String, String>{
        'videoId': videoId,
        'title': title.trim().isEmpty ? 'Video Lecture' : title.trim(),
      },
    );
  }

  String? _extractYoutubeVideoId(String inputUrl) {
    final uri = Uri.tryParse(inputUrl);
    if (uri == null) return null;

    String? videoId;
    final host = uri.host.toLowerCase();

    if (host.contains('youtu.be')) {
      final path = uri.pathSegments;
      if (path.isNotEmpty) {
        videoId = path.first;
      }
    } else if (host.contains('youtube.com')) {
      final queryId = uri.queryParameters['v'];
      if (queryId != null && queryId.isNotEmpty) {
        videoId = queryId;
      } else {
        final segments = uri.pathSegments;
        final embedIndex = segments.indexOf('embed');
        if (embedIndex != -1 && embedIndex + 1 < segments.length) {
          videoId = segments[embedIndex + 1];
        } else {
          final shortsIndex = segments.indexOf('shorts');
          if (shortsIndex != -1 && shortsIndex + 1 < segments.length) {
            videoId = segments[shortsIndex + 1];
          }
        }
      }
    }

    return videoId;
  }
}
