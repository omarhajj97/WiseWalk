import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:wise_walk/main.dart';

class NotificationService {
static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
static int _notificationIdCounter = 0;



  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: android,
      iOS: iOS,);


    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response){
        if (response.payload != null) {
          try {
            final data = jsonDecode(response.payload!);
            final screen = data['screen'];
            navigatorKey.currentContext?.go(screen);
          } catch (e) {
            print('Error decoding notification payload: $e');
          }
        }
      },
    );
  }
  static Future<void> showSimulatedNotification({
    required String title, required String body, required String screen,
  }) async{

    const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'test',
          'Testing',
          channelDescription:
              'This channel is used for testing.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
    _notificationIdCounter++;
    final payload = jsonEncode({'screen': screen});

    await _flutterLocalNotificationsPlugin.show(_notificationIdCounter, title, body, notificationDetails,payload: payload);
  }

}
