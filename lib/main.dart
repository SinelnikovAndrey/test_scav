

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'; 
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/data/models/item_data.dart';

import 'package:test_scav/data/models/tips/tips_data.dart';

import 'package:test_scav/my_app.dart';
import 'package:test_scav/data/services/hive_adapters.dart';
import 'package:test_scav/presentation/notification/notification.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';

import 'package:timezone/data/latest.dart' as tz;



const String itemBoxName = 'itemsBox';
const String historyBoxName = 'historyBox';
const String reminderBoxName = 'remindersBox';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  try {
    final appDocDir = await getApplicationDocumentsDirectory();
    await _initHive(appDocDir.path); // Pass the path directly
    tz.initializeTimeZones();
    runApp(const MyApp()); // Pass directly
  } catch (e) {
    // Handle initialization errors appropriately (log, display error message, etc.)
    print("Error during initialization: $e");
  } finally {
    // FlutterNativeSplash.remove();
  }
}

Future<void> _initHive(String appDocumentsDirPath) async { // Specify String type
  try {
    Hive.init(appDocumentsDirPath);
    registerAdapters(); // Call your adapter registration function

    await Future.wait([
      Hive.openBox<HistoryData>(historyBoxName),
      Hive.openBox<ItemData>(itemBoxName),
      Hive.openBox<Reminder>(reminderBoxName),
    ]);
  } catch (e) {
    // Handle Hive initialization errors
    print('Hive initialization error: $e');
    //Consider displaying an error message to the user.  Or take some other recovery action.
  }
}
