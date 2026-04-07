import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/features/festival/data/models/festival_model.dart';
import 'package:bizrato_owner/features/festival/data/repositories/festival_repository.dart';
import 'package:bizrato_owner/features/festival/services/festival_download_service.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class FestivalController extends GetxController {
  FestivalController({
    required this.repository,
    required this.downloadService,
  });

  final FestivalRepository repository;
  final FestivalDownloadService downloadService;
  final AppToastService _toastService =
      Get.find<AppToastService>();
  final AuthStorage _authStorage = Get.find<AuthStorage>();

  final isLoading = true.obs;
  final isDetailsLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;
  final loaderMessage = RxnString();

  final festivals = <FestivalModel>[].obs;
  final festivalPosts = <FestivalPostModel>[].obs;
  final selectedFestival = Rxn<FestivalModel>();
  final downloadingPostIds = <int>{}.obs;

  bool get isBusy =>
      isLoading.value || isDetailsLoading.value || downloadingPostIds.isNotEmpty;

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
    loaderMessage.value = 'Loading festivals...';

    final response = await repository.getFestivals();
    if (!response.success) {
      hasError.value = true;
      errorMessage.value = response.message;
      isLoading.value = false;
      loaderMessage.value = null;
      return;
    }

    festivals.assignAll(response.data ?? <FestivalModel>[]);
    isLoading.value = false;
    loaderMessage.value = null;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  Future<void> openFestival(FestivalModel festival) async {
    selectedFestival.value = festival;
    isDetailsLoading.value = true;
    loaderMessage.value = 'Loading festival posts...';

    final response = await repository.getFestivalDetails(festival.festivalId);
    festivalPosts.assignAll(response.data ?? <FestivalPostModel>[]);
    isDetailsLoading.value = false;
    if (downloadingPostIds.isEmpty) {
      loaderMessage.value = null;
    }

    if (response.success) {
      Get.toNamed(AppRoutes.festivalDetails);
      return;
    }

    _toastService.error(response.message);
  }

  String buildImageUrl(String path) => repository.buildDownloadUrl(path);

  Map<String, String>? buildImageHeaders() {
    final token = _authStorage.token;
    if (token == null || token.isEmpty) {
      return null;
    }

    return <String, String>{
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> downloadFestivalPost(FestivalPostModel post) async {
    if (downloadingPostIds.contains(post.postId)) {
      return;
    }

    downloadingPostIds.add(post.postId);
    loaderMessage.value = 'Downloading image...';
    try {
      final response = await repository.downloadFestivalImage(post.postImageUrl);
      if (!response.success || response.data == null) {
        _toastService.error(response.message);
        return;
      }

      await downloadService.saveAndOpenImage(
        bytes: response.data!,
        fileName: 'festival_${post.postId}.jpg',
      );
    } finally {
      downloadingPostIds.remove(post.postId);
      if (downloadingPostIds.isEmpty) {
        loaderMessage.value = null;
      }
    }
  }
}
