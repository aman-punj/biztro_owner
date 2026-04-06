import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/features/course/controllers/course_controller.dart';
import 'package:bizrato_owner/features/course/data/repositories/course_repository.dart';
import 'package:get/get.dart';

class CourseBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }

    Get.lazyPut<CourseRepository>(
      () => CourseRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<CourseController>(
      () => CourseController(repository: Get.find<CourseRepository>()),
    );
  }
}
