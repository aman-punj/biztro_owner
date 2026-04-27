import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/core/widgets/app_status_dialog.dart';
import 'package:bizrato_owner/features/business_edit/data/models/save_social_media_request.dart';
import 'package:bizrato_owner/features/business_edit/data/models/social_media_links_model.dart';
import 'package:bizrato_owner/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class EditSocialMediaLinksController extends GetxController {
  EditSocialMediaLinksController({required this.repository});

  final OnboardingRepository repository;
  final AuthStorage _authStorage = Get.find<AuthStorage>();
  final AppToastService _toastService = Get.find<AppToastService>();

  final RxString facebookUrl = ''.obs;
  final RxString twitterUrl = ''.obs;
  final RxString instagramUrl = ''.obs;
  final RxString linkedinUrl = ''.obs;
  final RxString justdialUrl = ''.obs;
  final RxString indiamartUrl = ''.obs;
  final RxString websiteUrl = ''.obs;
  final RxString youTubeUrl = ''.obs;
  final RxBool isPubliclyVisible = true.obs;

  final RxString facebookUrlError = ''.obs;
  final RxString twitterUrlError = ''.obs;
  final RxString instagramUrlError = ''.obs;
  final RxString linkedinUrlError = ''.obs;
  final RxString justdialUrlError = ''.obs;
  final RxString indiamartUrlError = ''.obs;
  final RxString websiteUrlError = ''.obs;
  final RxString youTubeUrlError = ''.obs;

  final RxBool isLoadingPage = false.obs;
  final RxBool isSaving = false.obs;

  String _initialFacebookUrl = '';
  String _initialTwitterUrl = '';
  String _initialInstagramUrl = '';
  String _initialLinkedinUrl = '';
  String _initialJustdialUrl = '';
  String _initialIndiamartUrl = '';
  String _initialWebsiteUrl = '';
  String _initialYouTubeUrl = '';
  bool _initialIsPubliclyVisible = true;

  @override
  void onInit() {
    super.onInit();
    loadExistingData();
  }

  Future<void> loadExistingData() async {
    isLoadingPage.value = true;
    try {
      final merchantId = _authStorage.merchantId;
      if (merchantId == null || merchantId == 0) {
        _toastService.error('Merchant ID is not available.');
        return;
      }

      final AppResponse<SocialMediaLinksModel> response =
          await repository.getSocialMediaLinks(merchantId);
      if (!response.success || response.data == null) {
        _toastService.error(
          response.message.isNotEmpty
              ? response.message
              : 'Unable to load social media links.',
        );
        return;
      }

      _applyLoadedData(response.data!.data);
    } finally {
      isLoadingPage.value = false;
    }
  }

  void _applyLoadedData(SocialMediaLinksData data) {
    facebookUrl.value = data.facebookUrl;
    twitterUrl.value = data.twitterUrl;
    instagramUrl.value = data.instagramUrl;
    linkedinUrl.value = data.linkedinUrl;
    justdialUrl.value = data.justdialUrl;
    indiamartUrl.value = data.indiamartUrl;
    websiteUrl.value = data.websiteUrl;
    youTubeUrl.value = data.youTubeUrl;
    isPubliclyVisible.value = data.isPubliclyVisible;

    _initialFacebookUrl = data.facebookUrl;
    _initialTwitterUrl = data.twitterUrl;
    _initialInstagramUrl = data.instagramUrl;
    _initialLinkedinUrl = data.linkedinUrl;
    _initialJustdialUrl = data.justdialUrl;
    _initialIndiamartUrl = data.indiamartUrl;
    _initialWebsiteUrl = data.websiteUrl;
    _initialYouTubeUrl = data.youTubeUrl;
    _initialIsPubliclyVisible = data.isPubliclyVisible;
  }

  void resetForm() {
    facebookUrl.value = _initialFacebookUrl;
    twitterUrl.value = _initialTwitterUrl;
    instagramUrl.value = _initialInstagramUrl;
    linkedinUrl.value = _initialLinkedinUrl;
    justdialUrl.value = _initialJustdialUrl;
    indiamartUrl.value = _initialIndiamartUrl;
    websiteUrl.value = _initialWebsiteUrl;
    youTubeUrl.value = _initialYouTubeUrl;
    isPubliclyVisible.value = _initialIsPubliclyVisible;
    clearValidationErrors();
  }

  void clearValidationErrors() {
    facebookUrlError.value = '';
    twitterUrlError.value = '';
    instagramUrlError.value = '';
    linkedinUrlError.value = '';
    justdialUrlError.value = '';
    indiamartUrlError.value = '';
    websiteUrlError.value = '';
    youTubeUrlError.value = '';
  }

  bool validateForm() {
    clearValidationErrors();

    facebookUrl.value = _normalizeUrl(facebookUrl.value);
    twitterUrl.value = _normalizeUrl(twitterUrl.value);
    instagramUrl.value = _normalizeUrl(instagramUrl.value);
    linkedinUrl.value = _normalizeUrl(linkedinUrl.value);
    justdialUrl.value = _normalizeUrl(justdialUrl.value);
    indiamartUrl.value = _normalizeUrl(indiamartUrl.value);
    websiteUrl.value = _normalizeUrl(websiteUrl.value);
    youTubeUrl.value = _normalizeUrl(youTubeUrl.value);

    final hasAtLeastOneLink = <String>[
      facebookUrl.value,
      twitterUrl.value,
      instagramUrl.value,
      linkedinUrl.value,
      justdialUrl.value,
      indiamartUrl.value,
      websiteUrl.value,
      youTubeUrl.value,
    ].any((value) => value.trim().isNotEmpty);

    if (!hasAtLeastOneLink) {
      _toastService.error('Please add at least one social media link.');
      return false;
    }

    var hasErrors = false;
    hasErrors = _validateUrl(
          value: facebookUrl.value,
          error: facebookUrlError,
          fieldLabel: 'Facebook',
        ) ||
        hasErrors;
    hasErrors = _validateUrl(
          value: twitterUrl.value,
          error: twitterUrlError,
          fieldLabel: 'Twitter / X',
        ) ||
        hasErrors;
    hasErrors = _validateUrl(
          value: instagramUrl.value,
          error: instagramUrlError,
          fieldLabel: 'Instagram',
        ) ||
        hasErrors;
    hasErrors = _validateUrl(
          value: linkedinUrl.value,
          error: linkedinUrlError,
          fieldLabel: 'LinkedIn',
        ) ||
        hasErrors;
    hasErrors = _validateUrl(
          value: justdialUrl.value,
          error: justdialUrlError,
          fieldLabel: 'Justdial',
        ) ||
        hasErrors;
    hasErrors = _validateUrl(
          value: indiamartUrl.value,
          error: indiamartUrlError,
          fieldLabel: 'Indiamart',
        ) ||
        hasErrors;
    hasErrors = _validateUrl(
          value: websiteUrl.value,
          error: websiteUrlError,
          fieldLabel: 'Website',
        ) ||
        hasErrors;
    hasErrors = _validateUrl(
          value: youTubeUrl.value,
          error: youTubeUrlError,
          fieldLabel: 'YouTube',
        ) ||
        hasErrors;

    if (hasErrors) {
      _toastService.error('Please enter valid social media links.');
    }

    return !hasErrors;
  }

  bool _validateUrl({
    required String value,
    required RxString error,
    required String fieldLabel,
  }) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      error.value = '';
      return false;
    }

    final uri = Uri.tryParse(trimmed);
    final isValid = uri != null &&
        uri.hasScheme &&
        uri.hasAuthority &&
        uri.host.isNotEmpty &&
        uri.host.contains('.') &&
        (uri.scheme == 'http' || uri.scheme == 'https');
    if (!isValid) {
      error.value = 'Enter a valid $fieldLabel URL';
      return true;
    }

    error.value = '';
    return false;
  }

  String _normalizeUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    final parsed = Uri.tryParse(trimmed);
    if (parsed != null && parsed.hasScheme) {
      return trimmed;
    }

    return 'https://$trimmed';
  }

  Future<void> saveAndUpdate() async {
    if (!validateForm()) {
      return;
    }

    final merchantId = _authStorage.merchantId;
    if (merchantId == null || merchantId == 0) {
      _toastService.error('Merchant ID is unavailable.');
      return;
    }

    final request = SaveSocialMediaRequest(
      merchantId: merchantId,
      facebookUrl: facebookUrl.value.trim(),
      instagramUrl: instagramUrl.value.trim(),
      twitterUrl: twitterUrl.value.trim(),
      linkedinUrl: linkedinUrl.value.trim(),
      justdialUrl: justdialUrl.value.trim(),
      indiamartUrl: indiamartUrl.value.trim(),
      websiteUrl: websiteUrl.value.trim(),
      youTubeUrl: youTubeUrl.value.trim(),
      isPubliclyVisible: isPubliclyVisible.value,
    );

    isSaving.value = true;
    try {
      final AppResponse<void> response = await repository.saveSocialMedia(
        request,
      );
      if (!response.success) {
        await AppStatusDialog.show(
          dialog: AppStatusDialog.error(
            message: response.message.isNotEmpty
                ? response.message
                : 'Unable to update social media links.',
          ),
        );
        return;
      }

      await AppStatusDialog.show(
        dialog: AppStatusDialog.success(
          message: 'Social media links updated successfully.',
        ),
        onDismissed: () => Get.offAllNamed(AppRoutes.dashboard),
      );
    } finally {
      isSaving.value = false;
    }
  }
}
