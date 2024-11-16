
import 'package:flutter/material.dart';
import 'package:test_scav/presentation/add_item.dart';
import 'package:test_scav/presentation/my_items_page.dart';

class AppRouter {
  static const String myItemsPageRoute = '/myItemsPage';
  static const String homeRoute = '/home';
  static const String notificationsRoute = '/notifications';
  static const String addItemRoute = '/addItem';
  static const String itemDetailRoute = '/itemDetail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case addItemRoute:
        return MaterialPageRoute<void>(builder: (_) => const AddItemPage());
      case myItemsPageRoute:
        return MaterialPageRoute<void>(builder: (_) => const MyItemsPage());
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

