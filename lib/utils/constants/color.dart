import 'package:flutter/material.dart';

class TColors {
  TColors._();

  //App basic colors
  static const Color primary = Color(0xFF0055ff);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFb0c7ff);
  // static const prm = primary ?? Color(0xFF0055ff);
  //Grandient colors
  static const Gradient linerGradient = LinearGradient(
      begin: Alignment(0.0, 0.0),
      end: Alignment(0.707, -0.707),
      colors: [Color(0xFFff9a9e), Color(0xFFfad0c4), Color(0xFFfad0c4)]);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6c757d);
  static const Color textWhite = Colors.white;

  //Background colors
  static const Color dark = Color(0xFF272727);
  static const Color light = Color(0xFFf6f6f6);
  static const Color darkCard = Color(0xFF1a1a2e);
  static const Color lightCard = Color.fromARGB(255, 231, 230, 230);
  static const Color primaryBackground = Color(0xFFf3f5ff);

  //Background containers colors
  static const Color lightContainer = Color(0xFFf6f6f6);
  static Color darkContainer = Colors.white.withValues(alpha: 0.1);
  //button colors
  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondery = Color(0xFF6c757d);
  static const Color buttonDisabled = Color(0xFFc4c4c4);
  //border Colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondery = Color(0xFFE6E6E6);
  //Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3c);
  static const Color warning = Color(0xFFF57c00);
  static const Color info = Color(0xFF1976d2);

  //Neutral Shdes Colors
  static const Color black = Color(0xFF232323);
  static const Color darkerGray = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightgrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFffffff);
  static Color shadow = const Color.fromARGB(
    255,
    157,
    153,
    153,
  ).withValues(alpha: .5);
  static List<BoxShadow> tboxShadow = [
    BoxShadow(
      color: TColors.shadow,
      spreadRadius: 0,
      blurRadius: 2,
      offset: const Offset(0, 3),
    ),
  ];
}
