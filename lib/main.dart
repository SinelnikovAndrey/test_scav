
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/models/item_data.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/services/hive_adapters.dart'; // Import Provider

// const String itemsBoxName = 'itemBox';
const String placeBoxName = 'places';
const String itemBoxName = 'itemsBox';
// final itemService = ItemService(itemBox); 


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  registerAdapters();

  await Hive.openBox<ItemData>(itemBoxName);

  // ItemService.loadItems();

  runApp(
    const MyApp(),
  );
}