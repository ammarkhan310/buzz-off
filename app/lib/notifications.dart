//Class containing notification initalization, setup and functionality

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  //Notification information
  var _notificationId = 100;
  final channelId = 'BuzzOff';
  final channelName = 'Mosquito Notifications';
  final channelDescription =
      'Buzz Off Mosquito Related Notifications Intended To Keep You Safe & Bite Free';
  NotificationDetails _platformChannelInfo;

  var _notificationPlugin;

  //Initialize notification plugin and set up notification channel for platform
  Future<void> init() async {
    _notificationPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _notificationPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );

    //Setup a notification channel
    var androidChannelInfo = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription,
      //Intened to be a low priority/silent notification
      importance: Importance.low,
      priority: Priority.low,
    );

    //Notification details containing android channel information
    _platformChannelInfo = NotificationDetails(android: androidChannelInfo);
  }

  //TODO - Here in case there may be selectable notifications in the future
  Future onSelectNotification(var payload) async {
    if (payload != null) {
      print('onSelectNotification::payload = $payload');
    }
  }

  //Zoned schedule function to show notification after a specified time
  sendNotificationLater(
      String title, String body, tz.TZDateTime when, String payload) {
    _notificationPlugin.zonedSchedule(
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
