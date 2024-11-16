import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6CB1FF);
  static const Color primaryDark = Color(0xFF489E67);
  static const Color darkText = Color(0xFF1C1D20);
  static const Color gray = Color(0xFFC9C9C9);
  static const Color darkGray = Color(0xFF181725);
  static const Color lightGray = Color(0xFF7C7C7C);
  static const Color darkBorderGray = Color(0xFFF0F0F0);
  static const Color lightBorderGray = Color(0xFFE2E2E2);
  static const Color grayishLimeGreen = Color(0xFFF2F3F2);
  static const Color star = Color(0xFFF3603F);
  static const Color googleBlue = Color(0xFF5383EC);
  static const Color facebookBlue = Color(0xFF4A66AC);
  static const Color error = Color(0xFFD0421B);
}

 String selectedColorName = 'Grey'; 
  final Map<String, Color> colorMap = {
    'Red': Colors.red,
    'Grey': Colors.grey,
    'Black': Colors.black,
    'Brown': Colors.brown,
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Yellow': Colors.yellow,
  };