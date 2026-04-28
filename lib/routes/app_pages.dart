import 'package:bizrato_owner/features/auth/bindings/auth_binding.dart';
import 'package:bizrato_owner/features/auth/views/login_view.dart';
import 'package:bizrato_owner/features/messages/controllers/messages_binding.dart';
import 'package:bizrato_owner/features/messages/views/messages_view.dart';
import 'package:bizrato_owner/features/messages/controllers/chat_room_binding.dart';
import 'package:bizrato_owner/features/messages/views/chat_room_view.dart';
import 'package:bizrato_owner/features/business_edit/bindings/edit_business_details_binding.dart';
import 'package:bizrato_owner/features/business_edit/bindings/edit_business_services_binding.dart';
import 'package:bizrato_owner/features/business_edit/bindings/edit_location_info_binding.dart';
import 'package:bizrato_owner/features/business_edit/bindings/edit_social_media_links_binding.dart';
import 'package:bizrato_owner/features/business_edit/bindings/edit_timing_payment_binding.dart';
import 'package:bizrato_owner/features/business_edit/views/edit_business_details_view.dart';
import 'package:bizrato_owner/features/business_edit/views/edit_business_services_view.dart';
import 'package:bizrato_owner/features/business_edit/views/edit_location_info_view.dart';
import 'package:bizrato_owner/features/business_edit/views/edit_social_media_links_view.dart';
import 'package:bizrato_owner/features/business_edit/views/edit_timing_payment_view.dart';
import 'package:bizrato_owner/features/onboarding/controllers/onboarding_binding.dart';
import 'package:bizrato_owner/features/onboarding/views/onboarding_view.dart';
import 'package:bizrato_owner/features/splash/views/splash_view.dart';
import 'package:bizrato_owner/features/trusted_shield/controllers/trusted_shield_binding.dart';
import 'package:bizrato_owner/features/trusted_shield/bindings/live_identity_verification_binding.dart';
import 'package:bizrato_owner/features/trusted_shield/views/live_identity_verification_view.dart';
import 'package:bizrato_owner/features/trusted_shield/views/trusted_shield_view.dart';
import 'package:bizrato_owner/features/course/bindings/course_binding.dart';
import 'package:bizrato_owner/features/course/views/course_details_view.dart';
import 'package:bizrato_owner/features/course/views/course_list_view.dart';
import 'package:bizrato_owner/features/course/views/course_video_player_view.dart';
import 'package:bizrato_owner/features/festival/bindings/festival_binding.dart';
import 'package:bizrato_owner/features/festival/views/festival_details_view.dart';
import 'package:bizrato_owner/features/festival/views/festival_list_view.dart';
import 'package:bizrato_owner/features/feedback/bindings/feedback_binding.dart';
import 'package:bizrato_owner/features/feedback/views/feedback_view.dart';
import 'package:bizrato_owner/features/leads/bindings/leads_binding.dart';
import 'package:bizrato_owner/features/leads/views/leads_view.dart';
import 'package:bizrato_owner/features/advertisement/bindings/post_advertisement_binding.dart';
import 'package:bizrato_owner/features/advertisement/views/post_advertisement_view.dart';
import 'package:bizrato_owner/features/main_nav/bindings/main_nav_binding.dart';
import 'package:bizrato_owner/features/main_nav/views/main_nav_shell_view.dart';
import 'package:bizrato_owner/features/profile/bindings/profile_binding.dart';
import 'package:bizrato_owner/features/profile/views/profile_view.dart';
import 'package:bizrato_owner/features/support/bindings/support_binding.dart';
import 'package:bizrato_owner/features/support/views/support_view.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage<dynamic>>[
    GetPage<SplashView>(
      name: AppRoutes.splash,
      page: SplashView.new,
    ),
    GetPage<LoginView>(
      name: AppRoutes.login,
      page: LoginView.new,
      binding: AuthBinding(),
    ),
    GetPage<OnboardingView>(
      name: AppRoutes.onboarding,
      page: OnboardingView.new,
      binding: OnboardingBinding(),
    ),
    GetPage<MainNavShellView>(
      name: AppRoutes.dashboard,
      page: MainNavShellView.new,
      binding: MainNavBinding(),
    ),
    GetPage<MainNavShellView>(
      name: AppRoutes.mainNav,
      page: MainNavShellView.new,
      binding: MainNavBinding(),
    ),
    GetPage<TrustedShieldView>(
      name: AppRoutes.trustedShield,
      page: TrustedShieldView.new,
      binding: TrustedShieldBinding(),
    ),
    GetPage<LiveIdentityVerificationView>(
      name: AppRoutes.liveIdentityVerification,
      page: LiveIdentityVerificationView.new,
      binding: LiveIdentityVerificationBinding(),
    ),
    GetPage<MessagesView>(
      name: AppRoutes.messages,
      page: MessagesView.new,
      binding: MessagesBinding(),
    ),
    GetPage<ChatRoomView>(
      name: AppRoutes.chatRoom,
      page: ChatRoomView.new,
      binding: ChatRoomBinding(),
    ),
    GetPage<EditBusinessDetailsView>(
      name: AppRoutes.editBusinessDetails,
      page: EditBusinessDetailsView.new,
      binding: EditBusinessDetailsBinding(),
    ),
    GetPage<EditBusinessServicesView>(
      name: AppRoutes.editBusinessServices,
      page: EditBusinessServicesView.new,
      binding: EditBusinessServicesBinding(),
    ),
    GetPage<EditLocationInfoView>(
      name: AppRoutes.editLocationInfo,
      page: EditLocationInfoView.new,
      binding: EditLocationInfoBinding(),
    ),
    GetPage<EditTimingPaymentView>(
      name: AppRoutes.editTimingPayment,
      page: EditTimingPaymentView.new,
      binding: EditTimingPaymentBinding(),
    ),
    GetPage<EditSocialMediaLinksView>(
      name: AppRoutes.editSocialMediaLinks,
      page: EditSocialMediaLinksView.new,
      binding: EditSocialMediaLinksBinding(),
    ),
    GetPage<FestivalListView>(
      name: AppRoutes.festivals,
      page: FestivalListView.new,
      binding: FestivalBinding(),
    ),
    GetPage<FestivalDetailsView>(
      name: AppRoutes.festivalDetails,
      page: FestivalDetailsView.new,
    ),
    GetPage<CourseListView>(
      name: AppRoutes.courses,
      page: CourseListView.new,
      binding: CourseBinding(),
    ),
    GetPage<CourseDetailsView>(
      name: AppRoutes.courseDetails,
      page: CourseDetailsView.new,
    ),
    GetPage<CourseVideoPlayerView>(
      name: AppRoutes.courseVideoPlayer,
      page: CourseVideoPlayerView.new,
    ),
    GetPage<LeadsView>(
      name: AppRoutes.leads,
      page: LeadsView.new,
      binding: LeadsBinding(),
    ),
    GetPage<SupportView>(
      name: AppRoutes.support,
      page: SupportView.new,
      binding: SupportBinding(),
    ),
    GetPage<ProfileView>(
      name: AppRoutes.profile,
      page: ProfileView.new,
      binding: ProfileBinding(),
    ),
    GetPage<FeedbackView>(
      name: AppRoutes.feedback,
      page: FeedbackView.new,
      binding: FeedbackBinding(),
    ),
    GetPage<PostAdvertisementView>(
      name: AppRoutes.postAdvertisement,
      page: PostAdvertisementView.new,
      binding: PostAdvertisementBinding(),
    ),
  ];
}
