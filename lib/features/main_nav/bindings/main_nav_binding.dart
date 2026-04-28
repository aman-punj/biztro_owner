import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:bizrato_owner/features/leads/controllers/leads_controller.dart';
import 'package:bizrato_owner/features/leads/data/repositories/leads_repository.dart';
import 'package:bizrato_owner/features/main_nav/controllers/main_nav_controller.dart';
import 'package:bizrato_owner/features/messages/controllers/messages_controller.dart';
import 'package:bizrato_owner/features/messages/data/repositories/chat_repository.dart';
import 'package:bizrato_owner/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:get/get.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());

    if (!Get.isRegistered<OnboardingRepository>()) {
      Get.lazyPut<OnboardingRepository>(
        () => OnboardingRepository(apiClient: Get.find<ApiClient>()),
      );
    }

    if (!Get.isRegistered<DashboardController>()) {
      Get.lazyPut<DashboardController>(
        () => DashboardController(
          apiClient: Get.find<ApiClient>(),
          authStorage: Get.find<AuthStorage>(),
          onboardingRepository: Get.find<OnboardingRepository>(),
        ),
      );
    }

    if (!Get.isRegistered<LeadsRepository>()) {
      Get.lazyPut<LeadsRepository>(
        () => LeadsRepository(
          Get.find<ApiClient>(),
          Get.find<AuthStorage>(),
        ),
      );
    }

    if (!Get.isRegistered<LeadsController>()) {
      Get.lazyPut<LeadsController>(
        () => LeadsController(Get.find<LeadsRepository>()),
      );
    }

    if (!Get.isRegistered<ChatRepository>()) {
      Get.lazyPut<ChatRepository>(() => ChatRepository(Get.find<ApiClient>()));
    }

    if (!Get.isRegistered<MessagesController>()) {
      Get.lazyPut<MessagesController>(
        () => MessagesController(Get.find<ChatRepository>()),
      );
    }
  }
}
