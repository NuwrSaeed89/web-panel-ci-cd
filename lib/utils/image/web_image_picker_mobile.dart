import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Mobile/Desktop implementation for image picker (fallback)
class WebImagePickerWeb {
  static final ImagePicker _picker = ImagePicker();

  /// اختيار صورة واحدة من المعرض للويب (fallback for mobile)
  static Future<XFile?> pickSingleImageWeb({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    if (kDebugMode) {
      print('📱 Using mobile fallback for image picker');
    }

    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
        requestFullMetadata: false,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Mobile image picker failed: $e');
      }
      rethrow;
    }
  }

  /// اختيار عدة صور من المعرض للويب (fallback for mobile)
  static Future<List<XFile>> pickMultipleImagesWeb({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    if (kDebugMode) {
      print('📱 Using mobile fallback for multi-image picker');
    }

    try {
      return await _picker.pickMultiImage(
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
        requestFullMetadata: false,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Mobile multi-image picker failed: $e');
      }
      rethrow;
    }
  }

  /// التحقق من دعم اختيار الصور في المتصفح (always true for mobile)
  static bool isImagePickerSupported() {
    return true;
  }

  /// الحصول على معلومات المتصفح (empty for mobile)
  static Map<String, String> getBrowserInfo() {
    return {};
  }
}
