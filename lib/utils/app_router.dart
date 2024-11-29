
import 'package:flutter/material.dart';
import 'package:test_scav/presentation/home/add_group.dart';
import 'package:test_scav/presentation/home/add_item.dart';
// import 'package:test_scav/presentation/home/add_item.dart';
import 'package:test_scav/presentation/home/my_items_page.dart';

// import 'package:test_scav/presentation/home/add_group.dart';
// import 'package:test_scav/presentation/home/test_add_item.dart';
import 'package:test_scav/presentation/notification/reminder_body_list.dart';
import 'package:test_scav/presentation/notification/reminder_list.dart';
class AppRouter {
  static const String myItemsPageRoute = '/myItemsPage';
  static const String navigationPageRoute = '/navigationPage';
  static const String homeRoute = '/home';
  static const String rateUsRoute = '/myHomePage';
  static const String notificationsRoute = '/notifications';
  static const String addItemRoute = '/addProduct';
  static const String reminderItemRoute = '/reminderAddItem';
  static const String reminderBodyRoute = '/reminderBodyList';
  static const String addGroupRoute = '/addGroup';
  static const String itemDetailRoute = '/itemDetail';
  static const String addPlaceRoute = '/addPlaceDetail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      // case myItemsPageRoute:
      //   return MaterialPageRoute<void>(builder: (_) => const MyItemsPage());
        // case itemDetailRoute:
        // return MaterialPageRoute<void>(builder: (_) => const ProductDetailPage(productId: '',));
      case addItemRoute:
        return MaterialPageRoute<void>(builder: (_) => const AddItemPage());
      case reminderItemRoute:
        return MaterialPageRoute<void>(builder: (_) => const ReminderList());
      case reminderBodyRoute:
        return MaterialPageRoute<void>(builder: (_) => const ReminderBodyList());
      case addGroupRoute:
        return MaterialPageRoute<void>(builder: (_) => const AddGroupPage());
      
      // case rateUsRoute:
      //   return MaterialPageRoute<void>(builder: (_) => const MyHomePage());
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

