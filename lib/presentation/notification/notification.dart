import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
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
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
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

}


////////////////////////////////////////////////
///
///

class NotificationApi {
  static final notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future<void> init() async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: android);

    await notification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: receiveNotification,
      onDidReceiveBackgroundNotificationResponse: receiveBackgroundNotification,
    );

    await requestPermission();
  }

  static Future<void> requestPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      if (result != PermissionStatus.granted) {
        print('Notification permission denied.');
      }
    }
  }

  static void receiveNotification(NotificationResponse? payload) {
    final actionId = payload?.actionId ?? 'null';
    final message = payload?.payload ?? 'null';
    print('Notification received: $message Action: $actionId');
    onNotifications.add(message);
  }

  static void receiveBackgroundNotification(NotificationResponse? payload) {
    final actionId = payload?.actionId ?? 'null';
    final message = payload?.payload ?? 'null';
    print('Background Notification received: $message Action: $actionId');
    onNotifications.add(message);
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



  static Future<void> cancelAll() async => await notification.cancelAll();
  static Future<void> cancel(int id) async => await notification.cancel(id);
}


// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:rxdart/rxdart.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:test_scav/presentation/new_notification.dart/ModelDataBase/TableReminder.dart';


// class NotificationApi {
//   static final notification = FlutterLocalNotificationsPlugin();
//   static final onNotifications = BehaviorSubject<String?>();

//      static Future<NotificationDetails?> notificationDetails() async {
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

//    static Future<void> init() async {
//     const AndroidInitializationSettings android =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: android);

//     final details = await notification.getNotificationAppLaunchDetails();
//     if (details != null && details.didNotificationLaunchApp) {
//       receiveBackgroundNotification(details.notificationResponse);
//     }

//     await notification.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: receiveNotification,
//       onDidReceiveBackgroundNotificationResponse: receiveBackgroundNotification,
//     );

//     await requestPermission(); // Request permission after initialization
//   }

//   static Future<void> requestPermission() async {
//       var status = await Permission.notification.status;
//       if (!status.isGranted) {
//           final result = await Permission.notification.request();
//           if (result != PermissionStatus.granted) {
//               print('Notification permission denied.');
//           }
//       }
//   }


//   // static Future<void> scheduleNotification(
//   //     int id, Reminder reminder, String payload) async {
//   //   final details = await notificationDetails();
//   //   if (details != null) {
//   //     await notification.periodicallyShow(
//   //       id,
//   //       reminder.title,
//   //       'Reminder at ${DateFormat.jm().format(reminder.dateTime)}',
//   //       RepeatInterval.daily,
//   //       details,
//   //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//   //       payload: payload,
//   //     );
//   //   } else {
//   //     print('Failed to create notification details.');
//   //   }
//   // }

  

//   static Future<void> cancelAll() async => await notification.cancelAll();
//   static Future<void> cancel(int id) async => await notification.cancel(id);
// }





//////
// import 'dart:typed_data';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:path_provider/path_provider.dart'; //Needed for file storage
// import 'dart:io';

// import 'package:test_scav/presentation/new_notification.dart/ModelDataBase/TableReminder.dart';

// class NotificationApi {
//   static final _notification = FlutterLocalNotificationsPlugin();
//   static final onNotifications = BehaviorSubject<String?>();

//   // Download and cache icons
//   static Future<Uint8List?> _getIcon(String uri, String filename) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/$filename');
//     if (await file.exists()) {
//       return await file.readAsBytes(); // Use cached image
//     } else {
//       try {
//         final response = await http.get(Uri.parse(uri));
//         if (response.statusCode == 200) {
//           await file.writeAsBytes(response.bodyBytes);
//           return response.bodyBytes;
//         } else {
//           print('Error downloading icon: ${response.statusCode}');
//           return null;
//         }
//       } catch (e) {
//         print('Error downloading icon: $e');
//         return null;
//       }
//     }
//   }


//   static Future<NotificationDetails?> _notificationDetails() async {
//     final bigIcon = await _getIcon(
//         "YOUR_BIG_ICON_URL", "big_icon.png"); // Replace with your URL
//     final largeIcon = await _getIcon(
//         "YOUR_LARGE_ICON_URL", "large_icon.png"); // Replace with your URL

//     if (bigIcon == null || largeIcon == null) {
//       print("Failed to download icons");
//       return null;
//     }

//     final styleInformation = BigPictureStyleInformation(
//       ByteArrayAndroidBitmap(bigIcon),
//       largeIcon: ByteArrayAndroidBitmap(largeIcon),
//     );

//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channel_Id_1',
//         'channel_Name_1',
//         importance: Importance.high,
//         priority: Priority.high,
//         playSound: true,
//         sound: const RawResourceAndroidNotificationSound('abc'), // Use raw resource
//         styleInformation: styleInformation,
//         channelDescription: 'channel_Id_1_channel_Name_1',
//         groupKey: 'channel_Id_1_channel_Name_1',
//         setAsGroupSummary: true,
//         actions: [
//           const AndroidNotificationAction('id_Open', 'Open',showsUserInterface: true),
//           const AndroidNotificationAction('id_Close', 'Close',showsUserInterface: true),
//         ],
//       ),
//     );
//   }

//   static void _receiveNotification(NotificationResponse? payload) {
//     final actionId = payload?.actionId ?? 'null';
//     final message = payload?.payload ?? 'null';
//     print('Notification received: $message Action: $actionId');
//     onNotifications.add(message); // Update the subject
//   }

//   static void _receiveBackgroundNotification(NotificationResponse? payload) {
//     final actionId = payload?.actionId ?? 'null';
//     final message = payload?.payload ?? 'null';
//     print('Background Notification received: $message Action: $actionId');
//     onNotifications.add(message); // Update the subject
//   }

//   static Future<void> init() async {
//     const AndroidInitializationSettings android =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: android);

//     final details = await _notification.getNotificationAppLaunchDetails();
//     if (details != null && details.didNotificationLaunchApp) {
//       _receiveBackgroundNotification(details.notificationResponse);
//     }

//     await _notification.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _receiveNotification,
//       onDidReceiveBackgroundNotificationResponse: _receiveBackgroundNotification,
//     );
//   }

//    static Future<void> scheduleNotification(
//       int id, Reminder reminder, String payload) async {
//     final details = await _notificationDetails();
//     if (details != null) {
//       await _notification.periodicallyShow(
//         id,
//         reminder.title,
//         'Reminder at ${DateFormat.jm().format(reminder.dateTime)}',
//         RepeatInterval.daily,
//         details,
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         payload: payload, // Add payload for identification later
//       );
//     } else {
//       print('Failed to create notification details.');
//     }
//   }

//   static Future<void> cancelAll() async => await _notification.cancelAll();
//   static Future<void> cancel(int id) async => await _notification.cancel(id);
// }







// import 'dart:typed_data';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart';
// import 'package:rxdart/rxdart.dart';

// int id = 0;

// class NotificationApi {

//   static final _notification = FlutterLocalNotificationsPlugin();
//   static final onNotifications = BehaviorSubject<String?>();

//   static Future<Uint8List> _downloadFile(String uri) async => (await get(Uri.parse(uri))).bodyBytes;

//   static Future _notificationDetails() async {

//     final _url1 = "";
//     final _url2 = "";

//     final bigIcon = await _downloadFile(_url1);
//     final largIcon = await _downloadFile(_url2);

//     final styleInformation = BigPictureStyleInformation(
//       ByteArrayAndroidBitmap(bigIcon),
//       largeIcon: ByteArrayAndroidBitmap(largIcon),
//     );

//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//           'channel_Id_1',
//           'channel_Name_1',
//           importance: Importance.high,
//           priority: Priority.high,
//           playSound: true,
//           sound: UriAndroidNotificationSound("assets/sound/abc.mp3"),
//           styleInformation: styleInformation,
//           channelDescription: 'channel_Id_1_channel_Name_1',
//           groupKey: 'channel_Id_1_channel_Name_1',
//           setAsGroupSummary: true,
//           // audioAttributesUsage: AudioAttributesUsage.media,
//           // channelAction: AndroidNotificationChannelAction.update,
//           actions: [
//             AndroidNotificationAction('id_Open', 'Open',showsUserInterface: true),
//             AndroidNotificationAction('id_Close', 'Close',showsUserInterface: true),
//           ]
//       ),
//     );

//   }

//   static void _ReceiveNotification(NotificationResponse? PayLoad){

//     String? _actionId = PayLoad!.actionId;
//     String _actionResult = " actionId => ";

//     if(_actionId!=null)
//       _actionResult += _actionId;
//     else
//       _actionResult += "Null";

//     print(_actionResult);

//     onNotifications.add(PayLoad.payload!+_actionResult);

//   }

//   @pragma('vm:entry-point')
//   static void _ReceiveBackgroundNotification(NotificationResponse? PayLoad){

//     String? _actionId = PayLoad!.actionId;
//     String _actionResult = " actionId => ";

//     if(_actionId!=null)
//       _actionResult += _actionId;
//     else
//       _actionResult += "Null";

//     print(_actionResult);

//     onNotifications.add(PayLoad.payload!+_actionResult);

//   }
//   static Future init() async {

//     final android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final setting = InitializationSettings(android: android);

//     // When app is Closed
//     final details = await _notification.getNotificationAppLaunchDetails();
//     if(details!=null && details.didNotificationLaunchApp){
//       // onNotifications.add(details.notificationResponse!.payload);
//       _ReceiveBackgroundNotification(details.notificationResponse);
//     }

//     await _notification.initialize(
//       setting,
//       onDidReceiveNotificationResponse: _ReceiveNotification,
//       onDidReceiveBackgroundNotificationResponse: _ReceiveBackgroundNotification,
//     );

//   }

//   Future<void> repeatNotification() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             'repeating channel id', 'repeating channel name',
//             channelDescription: 'repeating description');
//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await _notification.periodicallyShow(
//       id++,
//       'repeating title',
//       'repeating body',
//       RepeatInterval.daily,
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }
//   static Future CancellAll() async => await _notification.cancelAll();

//   static Future Cancel(int id) async => await _notification.cancel(id);

// }