


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart'; 
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/data/services/hive_adapters.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/presentation/notification/note_state.dart';
import 'package:test_scav/presentation/notification/notification.dart';

import 'package:timezone/data/latest.dart' as tz;



const String itemBoxName = 'itemsBox';
const String historyBoxName = 'historyBox';
const String reminderBoxName = 'remindersBox';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  String appDocumentsDirPath = '';

  try {
    final appDocDir = await getApplicationDocumentsDirectory();
    appDocumentsDirPath = appDocDir.path; 
    await _initHive(appDocumentsDirPath);
    tz.initializeTimeZones();
  
  } on Exception catch (e) {
    debugPrint("Error during initialization: $e");
  
  } finally {
    FlutterNativeSplash.remove();
  }

  final jsonData = await rootBundle.loadString('assets/en.json');
  final rootData = Root.fromJson(json.decode(jsonData));

  
    runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => NotificationState()),
      Provider<NotificationService>(create: (_) => NotificationService()),
    ],
    child: MyApp(appDocumentsDirPath: appDocumentsDirPath, rootData: rootData),
  ),
);

}

Future<void> _initHive(String appDocumentsDirPath) async {
  try {
    await Hive.initFlutter(appDocumentsDirPath); 
    registerAdapters();
    try {
       await Hive.openBox<HistoryData>(historyBoxName);
    } catch (e) {
      debugPrint('Error opening history box: $e');
    }

    try {
       await Hive.openBox<ItemData>(itemBoxName);
    } catch (e) {
      debugPrint('Error opening items box: $e');
    }
    
    try {
       await Hive.openBox<Reminder>(reminderBoxName);
    } catch (e) {
      debugPrint('Error opening reminders box: $e');
    }

  } catch (e) {
    debugPrint('Hive initialization error: $e');
  }
}

void registerAdapters() {
    Hive.registerAdapter(HistoryDataAdapter());
    Hive.registerAdapter(ItemDataAdapter());
    Hive.registerAdapter(ReminderAdapter());
}