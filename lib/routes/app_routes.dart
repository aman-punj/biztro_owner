import 'package:flutter/widget_previews.dart';
import 'package:flutter/material.dart'; // For Material widgets

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
  static const messages = '/messages';
  static const editBusinessDetails = '/edit-business-details';
  static const editBusinessServices = '/edit-business-services';
  static const editLocationInfo = '/edit-location-info';
}
