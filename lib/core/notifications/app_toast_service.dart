import 'package:bizrato_owner/core/notifications/app_notification.dart';
import 'package:bizrato_owner/core/notifications/app_toast_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppToastService {
  // USAGE — call sites look like this forever, regardless of implementation:
  //
  // final notify = Get.find<NotificationService>();
  // notify.success('Login successful');
  // notify.error(response.message);
  // notify.warning('Session expiring soon');
  // notify.info('Profile updated');
  //
  // Or with custom title:
  // notify.error('Try again', title: 'Payment Failed');

  void show(AppNotification notification) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    _showGetSnackbar(notification);
  }

  void _showGetSnackbar(AppNotification notification) {
    final data = _resolveStyle(notification.type);
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
        backgroundColor: data.color,
        // : Colors.white,
        icon: Icon(data.icon, color: Colors.white),
        isDismissible: true,
        titleText: Text(
          notification.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          notification.message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // void _showToast(AppNotification notification) { }
  // Future swap point: replace _showGetSnackbar call with _showToast
  // if switching to another package. No call sites change.

  _NotificationStyle _resolveStyle(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return _NotificationStyle(
          color: Colors.green.shade700,
          icon: Icons.check_circle_outline,
        );
      case AppToastType.error:
        return _NotificationStyle(
          color: Colors.red.shade700,
          icon: Icons.error_outline,
        );
      case AppToastType.warning:
        return _NotificationStyle(
          color: Colors.orange.shade700,
          icon: Icons.warning_amber_outlined,
        );
      case AppToastType.info:
        return _NotificationStyle(
          color: Colors.blue.shade700,
          icon: Icons.info_outline,
        );
    }
  }
}

class _NotificationStyle {
  const _NotificationStyle({
    required this.color,
    required this.icon,
  });

  final Color color;
  final IconData icon;
}
