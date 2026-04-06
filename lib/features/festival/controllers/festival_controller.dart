import 'package:bizrato_owner/features/festival/data/models/festival_model.dart';
import 'package:bizrato_owner/features/festival/data/repositories/festival_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class FestivalController extends GetxController {
  FestivalController({required this.repository});

  final FestivalRepository repository;

  final isLoading = true.obs;
  final isDetailsLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;

  final festivals = <FestivalModel>[].obs;
  final festivalPosts = <FestivalPostModel>[].obs;
  final selectedFestival = Rxn<FestivalModel>();

  List<FestivalModel> get filteredFestivals {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return festivals;
    }

    return festivals
        .where((festival) => festival.festivalName.toLowerCase().contains(query))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadFestivals();
  }

  Future<void> loadFestivals() async {
    isLoading.value = true;
    hasError.value = false;

    final response = await repository.getFestivals();
    if (!response.success) {
      hasError.value = true;
      errorMessage.value = response.message;
      isLoading.value = false;
      return;
    }

    festivals.assignAll(response.data ?? <FestivalModel>[]);
    isLoading.value = false;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  Future<void> openFestival(FestivalModel festival) async {
    selectedFestival.value = festival;
    isDetailsLoading.value = true;

    final response = await repository.getFestivalDetails(festival.festivalId);
    festivalPosts.assignAll(response.data ?? <FestivalPostModel>[]);
    isDetailsLoading.value = false;

    if (response.success) {
      Get.toNamed(AppRoutes.festivalDetails);
      return;
    }

    Get.snackbar('Failed', response.message);
  }

  String buildImageUrl(String path) => repository.buildDownloadUrl(path);
}
