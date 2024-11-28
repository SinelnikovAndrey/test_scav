

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/widgets/navigation_page.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_router.dart';
class MyApp extends StatefulWidget {
  final String appDocumentsDirPath;
  const MyApp({super.key, required this.appDocumentsDirPath});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<Root> _rootDataFuture;

  @override
  void initState() {
    super.initState();
    _rootDataFuture = _loadRootData();
  }

  Future<Root> _loadRootData() async {
    final jsonData = await rootBundle.loadString('assets/en.json');
    return Root.fromJson(json.decode(jsonData));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Root>(
      future: _rootDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Center(
              child: Text('Error loading data: ${snapshot.error}'),
            ),
          );
        } else {
          return MaterialApp(
            title: 'Scavenger',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              useMaterial3: true,
            ),
            onGenerateRoute: AppRouter.onGenerateRoute,
            home: NavigationPage(rootData: snapshot.data!, appDocumentsDirPath: widget.appDocumentsDirPath),
          );
        }
      },
    );
  }
}


