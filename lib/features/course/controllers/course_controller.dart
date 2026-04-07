import 'package:bizrato_owner/core/notifications/app_toast_service.dart';
import 'package:bizrato_owner/core/notifications/app_toast_service_extension.dart';
import 'package:bizrato_owner/features/course/data/models/course_model.dart';
import 'package:bizrato_owner/features/course/data/repositories/course_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CourseController extends GetxController {
  CourseController({required this.repository});

  final CourseRepository repository;
  final AppToastService _notificationService =
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

    _notificationService.error(response.message);
  }

  Future<void> openYoutubeVideo(String url) async {
    final sanitizedUrl = url.trim();
    if (sanitizedUrl.isEmpty) {
      _notificationService.error('Video link is unavailable.');
      return;
    }

    final opened = await launchUrlString(
      sanitizedUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!opened) {
      _notificationService.error('Unable to open the video link.');
    }
  }
}
