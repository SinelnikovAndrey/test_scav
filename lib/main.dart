

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'; 
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/data/models/item_data.dart';

import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/data/product.dart';
import 'package:test_scav/data/services/image_saver.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/data/services/hive_adapters.dart';
import 'package:test_scav/presentation/notification/notification.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';

import 'package:timezone/data/latest.dart' as tz;


// Hive box names
const String itemBoxName = 'itemsBox';
const String historyBoxName = 'historyBox';
const String reminderBoxName = 'remindersBox';
const String productBoxName = 'product';

String appDocumentsDirPath = ''; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocumentsDirPath = appDocDir.path;
  

  await _initHive(appDocumentsDirPath); // Initialize Hive asynchronously
  await ImageSaver.init(); //Initialize Image Saver
  tz.initializeTimeZones();

  runApp(MyApp(appDocumentsDirPath: appDocumentsDirPath));
  FlutterNativeSplash.remove();
}

Future<void> _initHive(appDocumentsDirPath) async {
  Hive.init(appDocumentsDirPath);
  registerAdapters(); //This function should register adapters
  Hive.registerAdapter(ProductAdapter()); //Register adapter

  await Future.wait([
    Hive.openBox<ItemData>(itemBoxName),
    Hive.openBox<HistoryData>(historyBoxName),
    Hive.openBox<Reminder>(reminderBoxName),
    Hive.openBox<Product>(productBoxName),
  ]);
}
