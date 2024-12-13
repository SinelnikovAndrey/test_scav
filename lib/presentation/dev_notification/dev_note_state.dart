import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class DevNotificationState with ChangeNotifier {
  // Используем UUID для генерации уникальных ID уведомлений
  final uuid = const Uuid();

  // Список ID запланированных уведомлений.  Используем List<int>, потому что ID - целые числа.
  final List<int> _scheduledNotificationIds = [];

  // Флаг, указывающий, включены ли глобально уведомления.  По умолчанию - включены.
  bool _globalActive = false;

  // Флаг, указывающий, запрашивались ли уже права на отображение уведомлений.
  // Это нужно для того, чтобы не запрашивать права много раз.
  bool _permissionRequested = false;


  // Геттер для доступа к значению globalActive.  Он не изменяет состояние.
  bool get globalActive => _globalActive;

  // Сеттер для изменения значения globalActive.  Он вызывает notifyListeners(),
  // чтобы уведомить все виджеты, использующие этот провайдер, об изменении состояния.
  set globalActive(bool value) {
    _globalActive = value;
    notifyListeners();
  }

  // Геттер для доступа к значению permissionRequested.
  bool get permissionRequested => _permissionRequested;

  // Сеттер для изменения значения permissionRequested.
  set permissionRequested(bool value) {
    _permissionRequested = value;
    notifyListeners();
  }


  // Геттер для доступа к списку scheduledNotificationIds.
  List<int> get scheduledNotificationIds => _scheduledNotificationIds;


  // Добавляет ID уведомления в список.  Вызывает notifyListeners().
  void addScheduledNotificationId(int id) {
    _scheduledNotificationIds.add(id);
    notifyListeners();
  }

  // Удаляет ID уведомления из списка.  Вызывает notifyListeners().
  void removeScheduledNotificationId(int id) {
    _scheduledNotificationIds.remove(id);
    notifyListeners();
  }

  // Очищает список scheduledNotificationIds.  Вызывает notifyListeners().
  void clearScheduledNotificationIds() {
    _scheduledNotificationIds.clear();
    notifyListeners();
  }

  //Генерирует уникальный ID, используя UUID. Преобразует строку UUID в число.
  int generateUniqueId() {
    return int.parse(uuid.v4().replaceAll('-', ''));
  }
}