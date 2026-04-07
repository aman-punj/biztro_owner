import 'package:bizrato_owner/core/notifications/app_toast_type.dart';

class AppNotification {
  const AppNotification({
    required this.title,
    required this.message,
    required this.type,
  });

  final String title;
  final String message;
  final AppToastType type;
}
