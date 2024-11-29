import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static Future showPeriodicNotifications({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel 2', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      title,
      body,
      RepeatInterval.everyMinute,
      notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<NotificationDetails?> notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_Id_1',
        'channel_Name_1',
        importance: Importance.high,
        priority: Priority.high,
        channelDescription: 'channel_Id_1_channel_Name_1',
        groupKey: 'channel_Id_1_channel_Name_1',
        setAsGroupSummary: true,
        actions: [
          AndroidNotificationAction('id_Open', 'Open',
              showsUserInterface: true),
          AndroidNotificationAction('id_Close', 'Close',
              showsUserInterface: true),
        ],
      ),
    );
  }

  static Future showScheduleNotification({
    required int id,
    required String title,
    required String body,
    required String primeTimes,
    required String payload,
  }) async {
    tz.initializeTimeZones();

    tz.TZDateTime payloadDateTime = tz.TZDateTime.parse(tz.local, primeTimes);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      payloadDateTime,
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'channel 3',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: BigTextStyleInformation(''),
      )),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  static Future<void> cancelAll() async =>
      await flutterLocalNotificationsPlugin.cancelAll();
  static Future<void> cancel(int id) async =>
      await flutterLocalNotificationsPlugin.cancel(id);
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
    print("Notification receive");
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

   static Future<bool> requestPermission() async {
    try{
        final granted = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
        return granted ?? false; 
    } catch (e){
      print("Error Requesting Permissions: $e");
      return false;
    }
  }

  static Future<bool> checkPermission() async {
    try{
      final granted = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled();
      return granted ?? false; 
    } catch (e){
      print("Error Checking Permissions: $e");
      return false;
    }
  }


  static Future<void> cancelDailyNotification(int id) async {
    await NotificationService.flutterLocalNotificationsPlugin.cancel(id);
  }
  static Future<void> cancelAll() async =>
      await flutterLocalNotificationsPlugin.cancelAll();
      static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }


  static Future<void> showInstantNotification(
      int id, String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('instant_notification_channel_id', 'Instant Notifications',
            channelDescription: 'Instant notifications channel.',
            importance: Importance.max,
            priority: Priority.high);
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics, payload: payload);
  }


     static Future<void> scheduleDailyNotification(
      int id, String title, String body, TimeOfDay time, String payload) async {
    tz.initializeTimeZones();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'daily_notification_channel_id',
      'Daily Notifications',
      channelDescription: 'Daily notifications channel.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,

    );
    
    final iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);


    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
