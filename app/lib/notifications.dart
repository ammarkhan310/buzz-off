import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  final channelId = 'testNotifications';
  final channelName = 'Test Notifications';
  final channelDescription = 'Test Notification Channel';

  var _flutterLocalNotificationsPlugin;

  NotificationDetails _platformChannelInfo;
  var _notificationId = 100;

  Future<void> init() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // setup the notification plug-in
    var initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );

    // setup a notification channel
    var androidChannelInfo = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription,
      importance: Importance.low,
      priority: Priority.low,
    );

    _platformChannelInfo = NotificationDetails(android: androidChannelInfo);
  }

  Future onSelectNotification(var payload) async {
    if (payload != null) {
      print('onSelectNotification::payload = $payload');
    }
  }

  sendNotificationLater(
      String title, String body, tz.TZDateTime when, String payload) {
    _flutterLocalNotificationsPlugin.zonedSchedule(
      _notificationId++,
      title,
      body,
      when,
      _platformChannelInfo,
      payload: payload,
      uiLocalNotificationDateInterpretation: null,
      androidAllowWhileIdle: true,
    );
  }
}
