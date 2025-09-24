import 'package:flutter/material.dart';

class TTextStyles {
  // Font Family
  static const String _fontFamily = 'Urbanist'; //'IBMPlexSansArabic';

  // Heading Styles
  static TextStyle get heading1 => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get heading2 => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get heading3 => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get heading4 => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  // Body Styles
  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyXSmall => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // Button Styles
  static TextStyle get buttonLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get buttonMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get buttonSmall => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  // Label Styles
  static TextStyle get labelLarge => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.2,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.2,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.2,
      );

  // Caption Styles
  static TextStyle get caption => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );

  static TextStyle get overline => const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 1.5,
      );

  // Custom Weight Styles
  static TextStyle get thin => const TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w100,
      );

  static TextStyle get extraLight => const TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w200,
      );

  static TextStyle get light => const TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w300,
      );

  static TextStyle get regular => const TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get medium => const TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get semiBold => const TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bold => const TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
      );
}
