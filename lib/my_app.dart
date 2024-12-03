

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/utils/assets.dart';
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppData>(
      create: (context) {
        final appData = AppData();
        appData.setAppDocumentsDirPath(widget.appDocumentsDirPath);
        return appData; //return the initialized AppData instance
      },
      child: MaterialApp(
            title: 'Scavenger',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              useMaterial3: true,
            ),
            onGenerateRoute: AppRouter.onGenerateRoute,
            home: SplashPage(), 
          ));
        }
      }





class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigator.pushReplacementNamed(
        context,
        AppRouter.navigationPageRoute,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              SvgAssets.splash,
              width: MediaQuery.of(context).size.width * 0.6,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 40),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Scavenger',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class AppData with ChangeNotifier {
  String _appDocumentsDirPath = '';
  String get appDocumentsDirPath => _appDocumentsDirPath;

  void setAppDocumentsDirPath(String path) {
    _appDocumentsDirPath = path;
    notifyListeners();
  }
}