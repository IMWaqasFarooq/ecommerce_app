import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';

import '../preferences/notifications_preference_notifier.dart';
import '../storage/hive_boxes.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
}

abstract class PushNotificationService {
  Future<void> initialize();
}

class PushNotificationServiceImpl implements PushNotificationService {
  final _localNotifications = FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.requestPermission();

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    final token = await _fetchToken();
    debugPrint('FCM registration token: $token');
  }

  Future<String?> _fetchToken() async {
    try {
      if (Platform.isIOS && await FirebaseMessaging.instance.getAPNSToken() == null) {
        await Future<void>.delayed(const Duration(seconds: 2));
        if (await FirebaseMessaging.instance.getAPNSToken() == null) {
          debugPrint('No APNs token (simulator, or not registered yet); skipping FCM token fetch.');
          return null;
        }
      }
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('Failed to fetch FCM token: $e');
      return null;
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null || !_notificationsEnabled) return;

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('default_channel', 'General notifications'),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  bool get _notificationsEnabled {
    if (!Hive.isBoxOpen(HiveBoxes.preferences)) return true;
    final box = Hive.box<dynamic>(HiveBoxes.preferences);
    return (box.get(pushNotificationsPreferenceKey) as bool?) ?? true;
  }
}
