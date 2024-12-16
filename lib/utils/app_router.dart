import 'package:flutter/material.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/presentation/history/add_place.dart';
import 'package:test_scav/presentation/home/add_group.dart';
import 'package:test_scav/presentation/home/add_item.dart';
import 'package:test_scav/presentation/settings/notification/notification_page.dart';
import 'package:test_scav/presentation/settings/notification/reminder_body_list.dart';
import 'package:test_scav/presentation/settings/notification/reminder_list.dart';
import 'package:test_scav/widgets/navigation_page.dart';



class AppRouter {
  static const String myItemsPageRoute = '/myItemsPage';
  static const String navigationPageRoute = '/navigationPage';
  static const String homeRoute = '/home';
  static const String onTappedUsRoute = '/splash';
  static const String addItemRoute = '/addProduct';
  static const String reminderItemRoute = '/reminderItem';
  static const String reminderBodyRoute = '/reminderBodyList';
  static const String addGroupRoute = '/addGroup';
  static const String itemDetailRoute = '/itemDetail';
  static const String addPlaceRoute = '/addPlaceDetail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case navigationPageRoute:
        final arguments = settings.arguments as Map<String, dynamic>?;
        final appDocumentsDirPath = arguments?['appDocumentsDirPath'] as String? ?? '';
          final initialIndex = arguments?['selectedIndex'] as int? ?? 0;
        return MaterialPageRoute<void>(
          builder: (_) => NavigationPage(
            appDocumentsDirPath: appDocumentsDirPath,
            rootData: Root(),
            initialIndex: initialIndex,
          ),
          
        );
      case addPlaceRoute:
      final arguments = settings.arguments as Map<String, dynamic>?;
       final itemId = arguments?['itemId'] as String? ?? '';
        return MaterialPageRoute<void>(builder: (_) =>  AddPlacePage(itemId: itemId,));

        case addItemRoute:
        return MaterialPageRoute<void>(builder: (_) => const AddItemPage());
        
      case reminderItemRoute:
        return MaterialPageRoute<void>(builder: (_) => const ReminderList());

      case reminderBodyRoute:
        return MaterialPageRoute<void>(
            builder: (_) => const ReminderBodyList());
      case addGroupRoute:
        return MaterialPageRoute<void>(builder: (_) => const AddGroupPage());

      default:
        return MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text(
                  'No route defined for ${settings.name ?? 'unknown route'}'),
            ),
          ),
        );
    }
  }
}
