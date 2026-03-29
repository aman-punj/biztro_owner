import 'package:bizrato_owner/core/notifications/app_notification.dart';
import 'package:bizrato_owner/core/notifications/notification_service.dart';
import 'package:bizrato_owner/core/notifications/notification_type.dart';

extension NotificationServiceX on NotificationService {
  void success(String message, {String title = 'Success'}) =>
      show(AppNotification(title: title, message: message, type: NotificationType.success));

  void error(String message, {String title = 'Error'}) =>
      show(AppNotification(title: title, message: message, type: NotificationType.error));

  void warning(String message, {String title = 'Warning'}) =>
      show(AppNotification(title: title, message: message, type: NotificationType.warning));

  void info(String message, {String title = 'Info'}) =>
      show(AppNotification(title: title, message: message, type: NotificationType.info));
}
