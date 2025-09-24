import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brother_admin_panel/utils/image/robust_image_picker.dart';
import 'package:brother_admin_panel/utils/image/web_image_picker_fixed.dart';

/// خدمة موحدة لاختيار الصور تعمل على جميع المنصات
/// Unified image picker service that works across all platforms
class UnifiedImagePicker {
  /// اختيار صورة واحدة من المعرض
  /// Pick a single image from gallery
  static Future<XFile?> pickSingleImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = false,
  }) async {
    try {
      if (kIsWeb) {
        // استخدام WebImagePickerFixed للويب لتجنب مشاكل namespace
        // Use WebImagePickerFixed for web to avoid namespace issues
        if (kDebugMode) {
          print('🌐 Using web image picker for single image...');
        }
        return await WebImagePickerFixed.pickSingleImageWeb(
          maxWidth: maxWidth?.toInt(),
          maxHeight: maxHeight?.toInt(),
          imageQuality: imageQuality,
        );
      } else {
        // استخدام RobustImagePicker للمنصات الأخرى
        // Use RobustImagePicker for other platforms
        if (kDebugMode) {
          print('📱 Using robust image picker for single image...');
        }
        return await RobustImagePicker.pickSingleImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
          preferredCameraDevice: preferredCameraDevice,
          requestFullMetadata: requestFullMetadata,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unified image picker failed: $e');
        print('❌ Error type: ${e.runtimeType}');
        if (e is Error) {
          print('❌ Stack trace: ${e.stackTrace}');
        }
      }

      // Fallback: try with safe settings
      try {
        if (kIsWeb) {
          return await WebImagePickerFixed.pickImageWebSafe(
            maxWidth: maxWidth?.toInt(),
            maxHeight: maxHeight?.toInt(),
            imageQuality: imageQuality,
          );
        } else {
          return await RobustImagePicker.pickImageSafe(
            source: ImageSource.gallery,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
            preferredCameraDevice: preferredCameraDevice,
          );
        }
      } catch (e2) {
        if (kDebugMode) {
          print('❌ Fallback image picker also failed: $e2');
        }
        rethrow;
      }
    }
  }

  /// اختيار عدة صور من المعرض
  /// Pick multiple images from gallery
  static Future<List<XFile>> pickMultipleImages({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = false,
  }) async {
    try {
      if (kIsWeb) {
        // استخدام WebImagePickerFixed للويب
        // Use WebImagePickerFixed for web
        if (kDebugMode) {
          print('🌐 Using web image picker for multiple images...');
        }
        return await WebImagePickerFixed.pickMultipleImagesWeb(
          maxWidth: maxWidth?.toInt(),
          maxHeight: maxHeight?.toInt(),
          imageQuality: imageQuality,
        );
      } else {
        // استخدام RobustImagePicker للمنصات الأخرى
        // Use RobustImagePicker for other platforms
        if (kDebugMode) {
          print('📱 Using robust image picker for multiple images...');
        }
        return await RobustImagePicker.pickMultipleImages(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
          requestFullMetadata: requestFullMetadata,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unified multi-image picker failed: $e');
        print('❌ Error type: ${e.runtimeType}');
        if (e is Error) {
          print('❌ Stack trace: ${e.stackTrace}');
        }
      }

      // Fallback: try with safe settings
      try {
        if (kIsWeb) {
          return await WebImagePickerFixed.pickMultipleImagesWebSafe(
            maxWidth: maxWidth?.toInt(),
            maxHeight: maxHeight?.toInt(),
            imageQuality: imageQuality,
          );
        } else {
          return await RobustImagePicker.pickMultipleImagesSafe(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
          );
        }
      } catch (e2) {
        if (kDebugMode) {
          print('❌ Fallback multi-image picker also failed: $e2');
        }
        rethrow;
      }
    }
  }

  /// التقاط صورة من الكاميرا
  /// Take a photo from camera
  static Future<XFile?> takePhoto({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = false,
  }) async {
    try {
      if (kIsWeb) {
        // للويب، نستخدم اختيار الصور من المعرض بدلاً من الكاميرا
        // For web, we use gallery selection instead of camera
        if (kDebugMode) {
          print('🌐 Web platform: Using gallery instead of camera...');
        }
        return await WebImagePickerFixed.pickSingleImageWeb(
          maxWidth: maxWidth?.toInt(),
          maxHeight: maxHeight?.toInt(),
          imageQuality: imageQuality,
        );
      } else {
        // استخدام RobustImagePicker للمنصات الأخرى
        // Use RobustImagePicker for other platforms
        if (kDebugMode) {
          print('📷 Using robust image picker for camera...');
        }
        return await RobustImagePicker.takePhoto(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
          preferredCameraDevice: preferredCameraDevice,
          requestFullMetadata: requestFullMetadata,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unified camera picker failed: $e');
        print('❌ Error type: ${e.runtimeType}');
        if (e is Error) {
          print('❌ Stack trace: ${e.stackTrace}');
        }
      }

      // Fallback: try with safe settings
      try {
        if (kIsWeb) {
          return await WebImagePickerFixed.pickImageWebSafe(
            maxWidth: maxWidth?.toInt(),
            maxHeight: maxHeight?.toInt(),
            imageQuality: imageQuality,
          );
        } else {
          return await RobustImagePicker.pickImageSafe(
            source: ImageSource.camera,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
            preferredCameraDevice: preferredCameraDevice,
          );
        }
      } catch (e2) {
        if (kDebugMode) {
          print('❌ Fallback camera picker also failed: $e2');
        }
        rethrow;
      }
    }
  }

  /// التحقق من توفر اختيار الصور
  /// Check if image picking is available
  static Future<bool> isImagePickerAvailable() async {
    try {
      if (kIsWeb) {
        return WebImagePickerFixed.isImagePickerSupported();
      } else {
        return await RobustImagePicker.isGalleryAvailable();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Image picker availability check failed: $e');
      }
      return false;
    }
  }

  /// التحقق من توفر الكاميرا
  /// Check if camera is available
  static Future<bool> isCameraAvailable() async {
    try {
      if (kIsWeb) {
        // للويب، نعتبر أن "الكاميرا" متوفرة إذا كان اختيار الصور متوفر
        // For web, we consider "camera" available if image picking is supported
        return WebImagePickerFixed.isImagePickerSupported();
      } else {
        return await RobustImagePicker.isCameraAvailable();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Camera availability check failed: $e');
      }
      return false;
    }
  }

  /// الحصول على معلومات المنصة
  /// Get platform information
  static Map<String, dynamic> getPlatformInfo() {
    final info = <String, dynamic>{
      'isWeb': kIsWeb,
      'isDebug': kDebugMode,
    };

    if (kIsWeb) {
      info.addAll(WebImagePickerFixed.getBrowserInfo());
    }

    return info;
  }
}
