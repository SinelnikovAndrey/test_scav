
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
static final NotificationService _instance =
      NotificationService._internal();
      factory NotificationService() => _instance;
      NotificationService._internal();


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

      Future<void> initialize() async {
    const AndroidInitializationSettings InitializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,

            );

                const InitializationSettings initializationSettings =
        InitializationSettings(
      android: InitializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

     await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  void _onNotificationTap(NotificationResponse response){
    print('Notification Clicled: ${response.payload}');

  }




  Future<void> showInstantNotification() async { 
  const AndroidNotificationDetails androidPlatformChannelSpecifies = AndroidNotificationDetails(
      'test_channel',
      'test Notifications',
      channelDescription: " Channel for instant,",
      importance: Importance.high,
      priority: Priority.high

  );

  const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifies);

    await flutterLocalNotificationsPlugin.show(
      0,
    "Test title",
    "Test body 😉",
    platformChannelSpecifics,
    payload: 'instant'

    );


  }


  Future<void> scheduleNotification(DateTime scheduleDateTime) async { 
  const AndroidNotificationDetails androidPlatformChannelSpecifies = AndroidNotificationDetails(
      'test_channel',
      'test Notifications',
      channelDescription: " Channel for instant,",
      importance: Importance.high,
      priority: Priority.high

  );

  const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifies);

    await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'scheduled title',
    'scheduled body',
    tz.TZDateTime.from(scheduleDateTime, tz.local),
    platformChannelSpecifics,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);


        


  }



   Future<void> cancelAll() async =>
      await flutterLocalNotificationsPlugin.cancelAll();
   Future<void> cancel(int id) async =>
      await flutterLocalNotificationsPlugin.cancel(id);




}