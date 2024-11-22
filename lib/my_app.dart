

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart'; 
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/notification/reminder/reminder.dart'; 

import 'package:test_scav/widgets/navigation_page.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_router.dart';
void main() async { //Use async for main
  WidgetsFlutterBinding.ensureInitialized();

  final jsonData = await rootBundle.loadString('assets/en.json');
  final rootData = Root.fromJson(json.decode(jsonData));

  runApp(MyApp(rootData: rootData,));
}

class MyApp extends StatelessWidget {
  final Root rootData;
  const MyApp({super.key, required this.rootData,});

  // ... rest of your MyApp widget ...

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scavenger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: NavigationPage(rootData: rootData), // Pass rootData here
    );
  }
}


