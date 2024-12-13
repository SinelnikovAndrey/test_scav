import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:rxdart/subjects.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void backgroundNotificationHandler(NotificationResponse? details) async {}

Future<void> onNotificationTapped(NotificationResponse? payload) async {
}
class DevNNotificationService {
  static final DevNNotificationService _notificationService =
      DevNNotificationService._internal();

  factory DevNNotificationService() {
    return _notificationService;
  }

  static final onClickNotification = BehaviorSubject<String>();

  int generateUniqueId(int reminderId) {
    return reminderId;
  }

  Future<NotificationResponse?> getInitialNotification() async {
    final launchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      return NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          payload: launchDetails!.notificationResponse!.payload);
    }
    return null;
  }

  DevNNotificationService._internal();

  static const channelId = "1";
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    channelId,
    "randomString",
    channelDescription: "This channel is responsible for all the local notifications",
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  static const DarwinNotificationDetails _darwinNotificationDetails =
      DarwinNotificationDetails();

  final NotificationDetails notificationDetails = const NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _darwinNotificationDetails,
  );

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: initializationSettingsDarwin,
    );

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationHandler,
      onDidReceiveNotificationResponse: onNotificationTapped,
    );
  }

  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
            alert: true, badge: true, sound: true);
  }

  Future<void> requestAndroidPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
  }

  Future<void> requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
            alert: true, badge: true, sound: true);
  }

  Future<void> showNotification(
      int id, String title, String body, String payload) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> updateNotification(Reminder reminder) async {
    if (reminder.active) {
      await scheduleNotification(
          reminder.id,
          reminder.title,
          reminder.body ?? '',
          reminder.dateTime,
          TimeOfDay.fromDateTime(reminder.dateTime),
          'daily',
          'dailyReminderChannel',
          null);
    } else {
      await cancelNotification(reminder.id);
    }
  }

  Future<void> scheduleNotification(
      int id,
      String title,
      String body,
      DateTime eventDate,
      TimeOfDay eventTime,
      String payload,
      String time,
      int? hours,
      [DateTimeComponents? dateTimeComponents]) async {
    eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day);
    final scheduledTime = eventDate.add(Duration(
      hours: eventTime.hour,
      minutes: eventTime.minute,
    ));

    tz.TZDateTime nextInstanceOfTenAM() {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate =
          tz.TZDateTime.from(scheduledTime, tz.local);
      if (time == 'daily') {
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }
      } else if (time == 'hourly') {
        if (scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(Duration(hours: hours!));
        }
      }
      return scheduledDate;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      nextInstanceOfTenAM(),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents: dateTimeComponents,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

   Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  
}