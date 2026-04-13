import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'My Sample Text')
Widget mySampleText() {
  return const Text('Hello, World!');
}

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const onboarding = '/onboarding';
  static const dashboard = '/dashboard';
  static const trustedShield = '/trusted-shield';
  static const liveIdentityVerification = '/live-identity-verification';
  static const messages = '/messages';
  static const chatRoom = '/chat-room';
  static const editBusinessDetails = '/edit-business-details';
  static const editBusinessServices = '/edit-business-services';

  static const editLocationInfo = '/edit-location-info';
  static const editTimingPayment = '/edit-timing-payment';
  static const editSocialMediaLinks = '/edit-social-media-links';
  static const festivals = '/festivals';
  static const festivalDetails = '/festival-details';
  static const courses = '/courses';
  static const courseDetails = '/course-details';
  static const leads = '/leads';
  static const feedback = '/feedback';
}
