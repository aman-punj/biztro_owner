import 'package:bizrato_owner/core/notifications/app_notification.dart';
import 'package:bizrato_owner/core/notifications/app_toast_service.dart';
import 'package:bizrato_owner/core/notifications/app_toast_type.dart';

extension AppToastServiceX on AppToastService {
  void success(String message, {String title = 'Success'}) =>
      show(AppNotification(title: title, message: message, type: AppToastType.success));

  void error(String message, {String title = 'Error'}) =>
      show(AppNotification(title: title, message: message, type: AppToastType.error));

  void warning(String message, {String title = 'Warning'}) =>
      show(AppNotification(title: title, message: message, type: AppToastType.warning));

  void info(String message, {String title = 'Info'}) =>
      show(AppNotification(title: title, message: message, type: AppToastType.info));
}
