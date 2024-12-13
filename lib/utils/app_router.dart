
import 'package:flutter/material.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/presentation/dev_notification/dev_reminder_body_list.dart';
import 'package:test_scav/presentation/dev_notification/dev_reminder_list.dart';
import 'package:test_scav/presentation/home/add_group.dart';
import 'package:test_scav/presentation/home/add_item.dart';
import 'package:test_scav/presentation/home/my_items_page.dart';
import 'package:test_scav/presentation/notification/reminder_body_list.dart';
import 'package:test_scav/presentation/notification/reminder_list.dart';


import 'package:test_scav/widgets/navigation_page.dart';
class AppRouter {
  static const String myItemsPageRoute = '/myItemsPage';
  static const String navigationPageRoute = '/navigationPage';
  static const String homeRoute = '/home';
  static const String onTappedUsRoute = '/splash';
  static const String notificationsRoute = '/notifications';
  static const String addItemRoute = '/addProduct';
  static const String reminderItemRoute = '/reminderAddItem';
  static const String reminderBodyRoute = '/reminderBodyList';
  static const String addGroupRoute = '/addGroup';
  static const String itemDetailRoute = '/itemDetail';
  static const String addPlaceRoute = '/addPlaceDetail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      case navigationPageRoute:
        final arguments = settings.arguments as Map<String, dynamic>?;
        final appDocumentsDirPath = arguments?['appDocumentsDirPath'] ?? '';
        return MaterialPageRoute<void>(
          builder: (_) => NavigationPage(
            appDocumentsDirPath: appDocumentsDirPath, 
            rootData: Root(),
          ),
        );
      case addItemRoute:
        return MaterialPageRoute<void>(builder: (_) => const AddItemPage());
      case reminderItemRoute:
        return MaterialPageRoute<void>(builder: (_) => const DevOldReminderList());
      case reminderBodyRoute:
        return MaterialPageRoute<void>(builder: (_) => const DevOldReminderBodyList());
      case addGroupRoute:
        return MaterialPageRoute<void>(builder: (_) => const AddGroupPage());
      
      case onTappedUsRoute:
        return MaterialPageRoute<void>(builder: (_) => const SplashPage());
      default:
        return MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('No route defined for ${settings.name ?? 'unknown route'}'),
            ),
          ),
        );
    }
  }
}

