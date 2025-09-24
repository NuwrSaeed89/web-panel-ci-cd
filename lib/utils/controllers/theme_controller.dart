import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  final _storage = GetStorage();
  final _key = 'isDarkMode';

  bool get isDarkMode {
    // الوضع الافتراضي هو dark إذا لم يتم حفظ تفضيل سابق
    final savedValue = _storage.read(_key);
    final result = savedValue ?? true;

    if (kDebugMode) {
      print(
          'ThemeController: Saved value: $savedValue, Default: true, Result: $result');
    }

    return result;
  }

  ThemeMode get themeMode {
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final newValue = !isDarkMode;
    _storage.write(_key, newValue);
    Get.changeThemeMode(newValue ? ThemeMode.dark : ThemeMode.light);

    if (kDebugMode) {
      print(
          'ThemeController: Theme toggled to: ${newValue ? "dark" : "light"}');
    }

    update(); // إخطار GetBuilder بالتغييرات
  }

  void setThemeMode(ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;
    _storage.write(_key, isDark);
    Get.changeThemeMode(mode);

    if (kDebugMode) {
      print('ThemeController: Theme set to: ${isDark ? "dark" : "light"}');
    }

    update(); // إخطار GetBuilder بالتغييرات
  }

  @override
  void onInit() {
    super.onInit();
    // تطبيق الوضع المحفوظ أو الافتراضي (dark) عند بدء التطبيق
    final mode = themeMode;
    Get.changeThemeMode(mode);

    if (kDebugMode) {
      print(
          'ThemeController: Initialized with theme mode: ${mode == ThemeMode.dark ? "dark" : "light"}');
    }
  }
}
