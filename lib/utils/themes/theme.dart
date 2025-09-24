import 'package:flutter/material.dart';

import 'package:brother_admin_panel/utils/themes/appbar_theme.dart';
import 'package:brother_admin_panel/utils/themes/bottom_sheet_theme.dart';
import 'package:brother_admin_panel/utils/themes/checkbox_theme.dart';
import 'package:brother_admin_panel/utils/themes/elevated_button.theme.dart';
import 'package:brother_admin_panel/utils/themes/text_field_theme.dart';
import 'package:brother_admin_panel/utils/themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();
  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Urbanist',
      brightness: Brightness.light,
      primaryColor: const Color(0xFF0099ff),

      // primaryColor: TColors.primary,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TTextTheme.lightTextTheme,
      appBarTheme: TAppBarTheme.lightAppBarTheme,
      bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
      checkboxTheme: TCheckBoxTheme.lightCheckboxTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationThem);
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Urbanist',
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0055ff),
      // primaryColor: TColors.primary,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TTextTheme.darkTextTheme,
      appBarTheme: TAppBarTheme.darkAppBarTheme,
      bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
      checkboxTheme: TCheckBoxTheme.darkCheckboxTheme,
      elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationThem);
}
