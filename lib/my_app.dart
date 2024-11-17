
import 'package:flutter/material.dart';
import 'package:test_scav/presentation/navigation_page.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_router.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});


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
      home: const NavigationPage(),
 
    );
  }
}


