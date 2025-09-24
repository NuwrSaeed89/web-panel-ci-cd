import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobilePreviewController extends GetxController {
  // حالة إظهار/إخفاء شاشة الموبايل العائمة
  final RxBool isVisible = false.obs;

  // موضع شاشة الموبايل العائمة
  final Rx<Offset> position = const Offset(20, 100).obs;

  // حجم شاشة الموبايل العائمة
  final Rx<Size> size = const Size(370, 700).obs;

  // حالة السحب
  bool isDragging = false;

  // الحد الأدنى والأقصى للحجم
  static const double minWidth = 280;
  static const double maxWidth = 400;
  static const double minHeight = 500;
  static const double maxHeight = 800;

  // إظهار شاشة الموبايل العائمة
  void showMobilePreview() {
    isVisible.value = true;
  }

  // إخفاء شاشة الموبايل العائمة
  void hideMobilePreview() {
    isVisible.value = false;
  }

  // تبديل حالة الإظهار
  void toggleMobilePreview() {
    isVisible.value = !isVisible.value;
  }

  // تحديث موضع شاشة الموبايل العائمة
  void updatePosition(Offset newPosition) {
    position.value = newPosition;
  }

  // تحديث حجم شاشة الموبايل العائمة
  void updateSize(Size newSize) {
    // التأكد من أن الحجم ضمن الحدود المسموحة
    final constrainedWidth = newSize.width.clamp(minWidth, maxWidth);
    final constrainedHeight = newSize.height.clamp(minHeight, maxHeight);

    size.value = Size(constrainedWidth, constrainedHeight);
  }

  // بدء السحب
  void startDragging() {
    isDragging = true;
  }

  // إنهاء السحب
  void stopDragging() {
    isDragging = false;
  }

  // إعادة تعيين الموضع والحجم
  void reset() {
    position.value = const Offset(20, 100);
    size.value = const Size(320, 600);
  }
}
