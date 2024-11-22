
import 'package:flutter/material.dart';
import 'package:test_scav/presentation/home/add_item.dart';
import 'package:test_scav/presentation/home/my_items_page.dart';
import 'package:test_scav/presentation/notification/add_group.dart';

class AppRouter {
  static const String myItemsPageRoute = '/myItemsPage';
  static const String homeRoute = '/home';
  static const String notificationsRoute = '/notifications';
  static const String addItemRoute = '/addItem';
  static const String addGroupRoute = '/addGroup';
  static const String itemDetailRoute = '/itemDetail';
  static const String addPlaceRoute = '/addPlaceDetail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case addItemRoute:
        return MaterialPageRoute<void>(builder: (_) => const AddItemPage());
      case addGroupRoute:
        return MaterialPageRoute<void>(builder: (_) => const AddGroupPage());
      case myItemsPageRoute:
        return MaterialPageRoute<void>(builder: (_) => const MyItemsPage());
      // case addPlaceRoute:
      //   return MaterialPageRoute<void>(builder: (_) => const AddPlacePage());
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

