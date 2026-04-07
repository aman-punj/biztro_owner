import 'package:bizrato_owner/core/app_toast/app_toast_type.dart';

class AppToast {
  const AppToast({
    required this.title,
    required this.message,
    required this.type,
  });

  final String title;
  final String message;
  final AppToastType type;
}
