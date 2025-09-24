import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  /// عرض إشعار نجاح
  static void showSuccess({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: duration,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      // تخصيص العرض ليتناسب مع المحتوى
      maxWidth: Get.width * 0.9,
      // تخصيص الارتفاع ليتناسب مع المحتوى
      barBlur: 0,
      // إزالة الظل
      boxShadows: [],
      // تخصيص النص
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }

  /// عرض إشعار خطأ
  static void showError({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 5),
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: duration,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      // تخصيص العرض ليتناسب مع المحتوى
      maxWidth: Get.width * 0.9,
      // تخصيص الارتفاع ليتناسب مع المحتوى
      barBlur: 0,
      // إزالة الظل
      boxShadows: [],
      // تخصيص النص
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }

  /// عرض إشعار تحذير
  static void showWarning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: duration,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      // تخصيص العرض ليتناسب مع المحتوى
      maxWidth: Get.width * 0.9,
      // تخصيص الارتفاع ليتناسب مع المحتوى
      barBlur: 0,
      // إزالة الظل
      boxShadows: [],
      // تخصيص النص
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }

  /// عرض إشعار معلومات
  static void showInfo({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: duration,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      // تخصيص العرض ليتناسب مع المحتوى
      maxWidth: Get.width * 0.9,
      // تخصيص الارتفاع ليتناسب مع المحتوى
      barBlur: 0,
      // إزالة الظل
      boxShadows: [],
      // تخصيص النص
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }

  /// عرض إشعار مخصص
  static void showCustom({
    required String title,
    required String message,
    Color backgroundColor = Colors.black87,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: duration,
      snackPosition: position,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      // تخصيص العرض ليتناسب مع المحتوى
      maxWidth: Get.width * 0.9,
      // تخصيص الارتفاع ليتناسب مع المحتوى
      barBlur: 0,
      // إزالة الظل
      boxShadows: [],
      // تخصيص النص
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }
}
