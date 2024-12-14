import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/main.dart';
import 'package:uuid/uuid.dart';


class NotificationState with ChangeNotifier {
  final uuid = const Uuid();
  final List<int> _scheduledNotificationIds = [];
  bool _globalActive = true;
  bool _permissionRequested = false;
  

  NotificationState({bool? initialGlobalActive}){
    if (initialGlobalActive != null) {
      _globalActive = initialGlobalActive;
      notifyListeners();
    }
  }


  bool get globalActive => _globalActive;

  set globalActive(bool value) {
    _globalActive = value;
        _saveGlobalActive(value);
    notifyListeners();
  }


  bool get permissionRequested => _permissionRequested;
  set permissionRequested(bool value) {
    _permissionRequested = value;
    notifyListeners();
  }

  List<int> get scheduledNotificationIds => _scheduledNotificationIds;
  void addScheduledNotificationId(int id) {
    _scheduledNotificationIds.add(id);
    notifyListeners();
  }
  void removeScheduledNotificationId(int id) {
    _scheduledNotificationIds.remove(id);
    notifyListeners();
  }
  void clearScheduledNotificationIds() {
    _scheduledNotificationIds.clear();
    notifyListeners();
  }
  int generateUniqueId() {
    return int.parse(uuid.v4().replaceAll('-', ''));
  }

    Future<void> _saveGlobalActive(bool value) async {
      final box = Hive.box(settingsBoxName);
        await box.put('globalActive', value);
    }
}