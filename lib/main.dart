

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart'; 
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/data/models/item_data.dart';

import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/data/services/hive_adapters.dart';
import 'package:test_scav/presentation/notification/notification.dart';
import 'package:test_scav/presentation/notification/reminder/reminder.dart';

import 'package:timezone/data/latest.dart' as tz;


const String itemBoxName = 'itemsBox';
const String historyBoxName = 'places';
const String reminderBoxName = 'remindersBox';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  registerAdapters();
  Hive.registerAdapter(ReminderAdapter());

  LocalNotifications.init();
  
 
  tz.initializeTimeZones();

  await Hive.openBox<ItemData>(itemBoxName);
  await Hive.openBox<HistoryData>(historyBoxName);
  await Hive.openBox<Reminder>(reminderBoxName);

  final jsonData = await rootBundle.loadString('assets/en.json');
  final rootData = Root.fromJson(json.decode(jsonData));


  runApp(MyApp(rootData: rootData));
}