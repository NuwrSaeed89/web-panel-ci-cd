import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

// Conditional imports for web-specific functionality
import 'package:brother_admin_panel/utils/image/web_image_picker_web.dart'
    if (dart.library.io) 'web_image_picker_mobile.dart' as web_impl;

/// خدمة اختيار الصور محسنة للويب (Chrome) - إصدار محسن
class WebImagePickerFixed {
  static final ImagePicker _picker = ImagePicker();

  /// اختيار صورة واحدة من المعرض للويب
  static Future<XFile?> pickSingleImageWeb({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    return web_impl.WebImagePickerWeb.pickSingleImageWeb(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
  }

  /// اختيار عدة صور من المعرض للويب
  static Future<List<XFile>> pickMultipleImagesWeb({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    return web_impl.WebImagePickerWeb.pickMultipleImagesWeb(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
  }

  /// اختيار صورة آمن للويب (بدون namespace issues)
  static Future<XFile?> pickImageWebSafe({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      if (kIsWeb) {
        return await pickSingleImageWeb(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );
      } else {
        return await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: maxWidth?.toDouble(),
          maxHeight: maxHeight?.toDouble(),
          imageQuality: imageQuality,
          requestFullMetadata: false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Safe web image picker failed: $e');
      }
      rethrow;
    }
  }

  /// اختيار عدة صور آمن للويب
  static Future<List<XFile>> pickMultipleImagesWebSafe({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      if (kIsWeb) {
        return await pickMultipleImagesWeb(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );
      } else {
        return await _picker.pickMultiImage(
          maxWidth: maxWidth?.toDouble(),
          maxHeight: maxHeight?.toDouble(),
          imageQuality: imageQuality,
          requestFullMetadata: false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Safe web multi-image picker failed: $e');
      }
      rethrow;
    }
  }

  /// التحقق من دعم اختيار الصور في المتصفح
  static bool isImagePickerSupported() {
    return web_impl.WebImagePickerWeb.isImagePickerSupported();
  }

  /// الحصول على معلومات المتصفح
  static Map<String, String> getBrowserInfo() {
    return web_impl.WebImagePickerWeb.getBrowserInfo();
  }
}
