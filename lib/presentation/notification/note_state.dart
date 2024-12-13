import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NotificationState with ChangeNotifier {
  final uuid = const Uuid(); //add uuid here
  int _notificationIdCounter = 0;
  final List<int> _scheduledNotificationIds = [];
  bool _permissionRequested = false;

  int get notificationIdCounter => _notificationIdCounter;
  List<int> get scheduledNotificationIds => _scheduledNotificationIds;
  bool get permissionRequested => _permissionRequested;

  set permissionRequested(bool value) {
    _permissionRequested = value;
    notifyListeners();
  }

  int generateUniqueId(int reminderId) {
    _notificationIdCounter = reminderId;
    return _notificationIdCounter;
  }

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
}