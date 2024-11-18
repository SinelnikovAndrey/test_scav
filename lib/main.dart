
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/services/hive_adapters.dart'; 

const String itemBoxName = 'itemsBox';
const String historyBoxName = 'places';
// final itemService = ItemService(itemBox); 


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  registerAdapters();

  await Hive.openBox<ItemData>(itemBoxName);
  await Hive.openBox<HistoryData>(historyBoxName);

  // ItemService.loadItems();

  runApp(
    const MyApp(),
  );
}