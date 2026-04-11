import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/widgets/secondary_button.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/business_edit/controllers/edit_social_media_links_controller.dart';
import 'package:bizrato_owner/features/business_edit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditSocialMediaLinksView extends StatefulWidget {
  const EditSocialMediaLinksView({super.key});

  @override
  State<EditSocialMediaLinksView> createState() =>
      _EditSocialMediaLinksViewState();
}

class _EditSocialMediaLinksViewState extends State<EditSocialMediaLinksView> {
  final EditSocialMediaLinksController controller =
      Get.find<EditSocialMediaLinksController>();

  late final TextEditingController _facebookController;
  late final TextEditingController _instagramController;
  late final TextEditingController _twitterController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _justdialController;
  late final TextEditingController _indiamartController;
  late final TextEditingController _websiteController;
  late final TextEditingController _youtubeController;

  final List<Worker> _workers = <Worker>[];

  @override
  void initState() {
    super.initState();
    _facebookController =
        TextEditingController(text: controller.facebookUrl.value);
    _instagramController =
        TextEditingController(text: controller.instagramUrl.value);
    _twitterController =
        TextEditingController(text: controller.twitterUrl.value);
    _linkedinController =
        TextEditingController(text: controller.linkedinUrl.value);
    _justdialController =
        TextEditingController(text: controller.justdialUrl.value);
    _indiamartController =
        TextEditingController(text: controller.indiamartUrl.value);
    _websiteController =
        TextEditingController(text: controller.websiteUrl.value);
    _youtubeController =
        TextEditingController(text: controller.youTubeUrl.value);

    _workers.addAll([
      ever<String>(
        controller.facebookUrl,
        (value) => _syncController(_facebookController, value),
      ),
      ever<String>(
        controller.instagramUrl,
        (value) => _syncController(_instagramController, value),
      ),
      ever<String>(
        controller.twitterUrl,
        (value) => _syncController(_twitterController, value),
      ),
      ever<String>(
        controller.linkedinUrl,
        (value) => _syncController(_linkedinController, value),
      ),
      ever<String>(
        controller.justdialUrl,
        (value) => _syncController(_justdialController, value),
      ),
      ever<String>(
        controller.indiamartUrl,
        (value) => _syncController(_indiamartController, value),
      ),
      ever<String>(
        controller.websiteUrl,
        (value) => _syncController(_websiteController, value),
      ),
      ever<String>(
        controller.youTubeUrl,
        (value) => _syncController(_youtubeController, value),
      ),
    ]);
  }

  @override
  void dispose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    _facebookController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _linkedinController.dispose();
    _justdialController.dispose();
    _indiamartController.dispose();
    _websiteController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Social Media & Links',
      child: Obx(
        () {
          if (controller.isLoadingPage.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OnboardingSectionCard(
                  title: 'SOCIAL LINKS',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage the public links shown for your business.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTokens.textSecondary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Obx(
                        () => SocialMediaLinkInputField(
                          label: 'Facebook URL',
                          controller: _facebookController,
                          iconPath: AppAssets.socialFacebookIcon,
                          hint: 'https://facebook.com/acmesolutions',
                          errorText: controller.facebookUrlError.value,
                          onChanged: (value) =>
                              controller.facebookUrl.value = value,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Obx(
                        () => SocialMediaLinkInputField(
                          label: 'Twitter URL',
                          controller: _twitterController,
                          iconPath: AppAssets.socialTwitterIcon,
                          hint: 'https://twitter.com/acme_solutions',
                          errorText: controller.twitterUrlError.value,
                          onChanged: (value) =>
                              controller.twitterUrl.value = value,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Obx(
                        () => SocialMediaLinkInputField(
                          label: 'Instagram URL',
                          controller: _instagramController,
                          iconPath: AppAssets.socialInstagramIcon,
                          hint: 'https://instagram.com/acmesolutions',
                          errorText: controller.instagramUrlError.value,
                          onChanged: (value) =>
                              controller.instagramUrl.value = value,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Obx(
                        () => SocialMediaLinkInputField(
                          label: 'Linkedin URL',
                          controller: _linkedinController,
                          iconPath: AppAssets.socialLinkedinIcon,
                          hint: 'https://linkedin.com/company/acme-solutions',
                          errorText: controller.linkedinUrlError.value,
                          onChanged: (value) =>
                              controller.linkedinUrl.value = value,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Obx(
                        () => SocialMediaLinkInputField(
                          label: 'Justdial URL',
                          controller: _justdialController,
                          iconPath: AppAssets.socialJustdialIcon,
                          hint: 'https://www.justdial.com/your-business',
                          errorText: controller.justdialUrlError.value,
                          onChanged: (value) =>
                              controller.justdialUrl.value = value,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Obx(
                        () => SocialMediaLinkInputField(
                          label: 'Indiamart URL',
                          controller: _indiamartController,
                          iconPath: AppAssets.socialIndiamartIcon,
                          hint: 'https://www.indiamart.com/your-business',
                          errorText: controller.indiamartUrlError.value,
                          onChanged: (value) =>
                              controller.indiamartUrl.value = value,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Obx(
                        () => SocialMediaLinkInputField(
                          label: 'Website URL',
                          controller: _websiteController,
                          iconPath: AppAssets.socialWebsiteIcon,
                          hint: 'https://www.acmesolutions.com',
                          errorText: controller.websiteUrlError.value,
                          onChanged: (value) =>
                              controller.websiteUrl.value = value,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Obx(
                        () => SocialMediaLinkInputField(
                          label: 'YouTube URL',
                          controller: _youtubeController,
                          iconPath: AppAssets.socialYoutubeIcon,
                          hint: 'https://youtube.com/@acmesolutions',
                          errorText: controller.youTubeUrlError.value,
                          onChanged: (value) =>
                              controller.youTubeUrl.value = value,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: 'Discard',
                          onPressed: controller.resetForm,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Obx(
                          () => PrimaryButton(
                            label: 'SAVE LINKS',
                            isLoading: controller.isSaving.value,
                            onPressed: controller.saveAndUpdate,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          );
        },
      ),
    );
  }

  void _syncController(TextEditingController textController, String value) {
    if (textController.text == value) {
      return;
    }

    textController.value = textController.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }
}
