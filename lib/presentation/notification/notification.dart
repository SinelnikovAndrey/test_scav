import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
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
          AndroidNotificationAction('id_Open', 'Open', showsUserInterface: true),
          AndroidNotificationAction('id_Close', 'Close', showsUserInterface: true),
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

  static Future<void> cancelAll() async => await flutterLocalNotificationsPlugin.cancelAll();
  static Future<void> cancel(int id) async => await flutterLocalNotificationsPlugin.cancel(id);
}


////////////////////////////////////////////////
///   version 2
///

// class NotificationApi {
//   static final notification = FlutterLocalNotificationsPlugin();
//   static final onNotifications = BehaviorSubject<String?>();

//   static Future<void> init() async {
//     const AndroidInitializationSettings android =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: android);

//     await notification.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: receiveNotification,
//       onDidReceiveBackgroundNotificationResponse: receiveBackgroundNotification,
//     );

//     await requestPermission();
//   }

//   static Future<void> requestPermission() async {
//     var status = await Permission.notification.status;
//     if (!status.isGranted) {
//       final result = await Permission.notification.request();
//       if (result != PermissionStatus.granted) {
//         print('Notification permission denied.');
//       }
//     }
//   }

//   static void receiveNotification(NotificationResponse? payload) {
//     final actionId = payload?.actionId ?? 'null';
//     final message = payload?.payload ?? 'null';
//     print('Notification received: $message Action: $actionId');
//     onNotifications.add(message);
//   }

//   static void receiveBackgroundNotification(NotificationResponse? payload) {
//     final actionId = payload?.actionId ?? 'null';
//     final message = payload?.payload ?? 'null';
//     print('Background Notification received: $message Action: $actionId');
//     onNotifications.add(message);
//   }

//   static Future<NotificationDetails?> notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channel_Id_1',
//         'channel_Name_1',
//         importance: Importance.high,
//         priority: Priority.high,
//         channelDescription: 'channel_Id_1_channel_Name_1',
//         groupKey: 'channel_Id_1_channel_Name_1',
//         setAsGroupSummary: true,
//         actions: [
//           AndroidNotificationAction('id_Open', 'Open', showsUserInterface: true),
//           AndroidNotificationAction('id_Close', 'Close', showsUserInterface: true),
//         ],
//       ),
//     );
//   }



//   static Future<void> cancelAll() async => await notification.cancelAll();
//   static Future<void> cancel(int id) async => await notification.cancel(id);
// }
