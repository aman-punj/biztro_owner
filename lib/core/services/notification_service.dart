import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/features/auth/data/repositories/device_repository.dart';
import 'package:bizrato_owner/features/messages/data/models/chat_models.dart';
import 'package:bizrato_owner/firebase_options.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
}

class NotificationService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isPermissionRequestInProgress = false;
  bool _areInteractionsConfigured = false;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  Future<NotificationService> init() async {
    final authStorage = Get.find<AuthStorage>();
    if (authStorage.isLoggedIn) {
      await setup();
    }
    return this;
  }

  bool _isSetup = false;
  Future<void> setup() async {
    if (_isSetup) return;

    await _initializeFirebase();
    await _initializeLocalNotifications();
    _setupInteractions();
    _listenToTokenRefresh();

    _isSetup = true;
    log('NotificationService: Setup completed.');
  }

  Future<void> _initializeFirebase() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Get initial message if the app was opened from a terminated state
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final Map<String, dynamic> data = jsonDecode(response.payload!);
          _handleNotificationClick(data);
        }
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> requestPermissionAndUploadToken() async {
    final isAllowed = await requestPermission();
    if (!isAllowed) return;

    await uploadToken();
  }

  Future<bool> requestPermission() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return true;
    }

    if (_isPermissionRequestInProgress) {
      return false;
    }

    _isPermissionRequestInProgress = true;
    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      log('Notification permission status: ${settings.authorizationStatus}');
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      log('Error requesting notification permission: $e');
      return false;
    } finally {
      _isPermissionRequestInProgress = false;
    }
  }

  void _setupInteractions() {
    if (_areInteractionsConfigured) return;
    _areInteractionsConfigured = true;

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground message received: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // Handle background messages when app is opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification opened app from background: ${message.data}');
      _handleNotificationClick(message.data);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: android?.smallIcon,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  Future<void> showChatNotification({
    required String title,
    required String message,
    required String senderId,
    String attachmentUrl = '',
  }) async {
    final payload = <String, dynamic>{
      'route': AppRoutes.chatRoom,
      'senderId': senderId,
      'title': title,
      'message': message,
      'attachmentUrl': attachmentUrl,
      'messageType': attachmentUrl.isNotEmpty ? 'image' : 'text',
      'source': 'socket_chat',
    };

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(payload),
    );
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    log('Notification clicked with data: $data');
    final String? route = data['route'];
    if (route != null && route.isNotEmpty) {
      if (route == AppRoutes.chatRoom) {
        Get.toNamed(route, arguments: ConversationModel.fromNotificationData(data));
        return;
      }

      Get.toNamed(route, arguments: data);
    }
  }

  void _listenToTokenRefresh() {
    _fcm.onTokenRefresh.listen((newToken) {
      log('FCM Token Refreshed: $newToken');
      uploadToken(newToken);
    });
  }

  Future<void> uploadToken([String? token]) async {
    try {
      final fcmToken = token ?? await _fcm.getToken();
      if (fcmToken == null) return;

      log('FCM Token: $fcmToken');

      final authStorage = Get.find<AuthStorage>();
      if (!authStorage.isLoggedIn) return;

      final deviceRepo = Get.find<DeviceRepository>();
      final response = await deviceRepo.updateDeviceToken(
        fcmToken: fcmToken,
        deviceType: _deviceType,
      );

      if (response.success) {
        log('Device token updated successfully');
      } else {
        log('Failed to update device token: ${response.message}');
      }
    } catch (e) {
      log('Error uploading FCM token: $e');
    }
  }

  String get _deviceType {
    if (Platform.isIOS) return 'ios';
    return 'android';
  }
}
