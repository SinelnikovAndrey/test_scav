

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_scav/data/models/tips/tips_data.dart';
import 'package:test_scav/utils/assets.dart';
import 'package:test_scav/widgets/navigation_page.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_router.dart';
class MyApp extends StatefulWidget {
  const MyApp({super.key, });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

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
            home: const SplashPage(),
          );
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
    // after 1 seconds, navigate to onboarding page
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigator.pushReplacementNamed(
        context,
        AppRouter.navigationPageRoute,
      ),
    );
    super.initState();
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


