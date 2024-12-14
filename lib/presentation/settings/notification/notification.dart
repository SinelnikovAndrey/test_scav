import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
// import 'package:test_scav/data/models/reminder/reminder.dart';
// import 'package:test_scav/main.dart';
// import 'package:test_scav/presentation/notification/note_state.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


Future<void> emptyBackgroundHandler(NotificationResponse? details) async {}


class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  static final BehaviorSubject<String> onClickNotification =
      BehaviorSubject<String>();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int generateUniqueId(int reminderId) => reminderId;

  Future<NotificationResponse?> getInitialNotification() async {
    final launchDetails =
        await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      return launchDetails!.notificationResponse;
    }
    return null;
  }

  NotificationService._internal();

  static const channelId = '1'; 

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    channelId,
    'Daily Reminders', 
    channelDescription:
        'This channel is responsible for daily reminder notifications',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
    // sound: RawResourceAndroidNotificationSound('notification_sound'),
  );

  static const DarwinNotificationDetails _darwinNotificationDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  final NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _darwinNotificationDetails,
  );

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: initializationSettingsDarwin,
    );


    tz.initializeTimeZones();
    final String? currentTimeZone = await FlutterTimezone.getLocalTimezone();
    if(currentTimeZone != null){
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    }

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: _ReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: _ReceiveBackgroundNotification
      // onDidReceiveBackgroundNotificationResponse: null,
    );

     await _requestPermissions();

  }

   static void _ReceiveNotification(NotificationResponse? PayLoad){

    String? _actionId = PayLoad!.actionId;
    String _actionResult = " actionId => ";

    if(_actionId!=null)
      _actionResult += _actionId;
    else
      _actionResult += "Null";

    print(_actionResult);

    onClickNotification.add(PayLoad.payload!+_actionResult);

  }


  static void _ReceiveBackgroundNotification(NotificationResponse? PayLoad){

    String? _actionId = PayLoad!.actionId;
    String _actionResult = " actionId => ";

    if(_actionId!=null)
      _actionResult += _actionId;
    else
      _actionResult += "Null";

    print(_actionResult);

    onClickNotification.add(PayLoad.payload!+_actionResult);

  }

  Future<void> _requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidPlugin = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        if (androidPlugin != null) {
          await androidPlugin.requestNotificationsPermission();
        }
      } else if (Platform.isIOS) {
        final iosPlugin = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();
        if (iosPlugin != null) {
          await iosPlugin.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
        }
      }
    } catch (e) {
      print("Error requesting permissions: $e");
    }
  }


  Future<void> backgroundNotificationHandler(NotificationResponse? details) async {

    NotificationService.onClickNotification.add(details?.payload ?? '');
  print("Background notification received: ${details?.payload}");
}
Future<void> _onNotificationTapped(NotificationResponse details) async {
  onClickNotification.add(details.payload ?? ''); 
}

  Future<void> showNotification(
      int id, String title, String body, String payload) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }



  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }



   Future<void> scheduleNotification(
      int id,
      String title,
      String body,
      DateTime scheduledDate,
      TimeOfDay scheduledTime,
      String payload,
      String time,
      int? hours,
      [DateTimeComponents? dateTimeComponents]
      ) async {
    final scheduledDateTime = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    final tzDateTime = tz.TZDateTime.from(scheduledDateTime, tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }
 


}