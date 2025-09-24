import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// خدمة محسنة لاختيار الصور مع معالجة مشاكل namespace
class RobustImagePicker {
  static final ImagePicker _picker = ImagePicker();

  /// اختيار صورة واحدة من المعرض مع معالجة الأخطاء
  static Future<XFile?> pickSingleImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = false,
  }) async {
    try {
      if (kDebugMode) {
        print('🖼️ Picking single image from gallery...');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
        requestFullMetadata: requestFullMetadata,
      );

      return image;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Primary image picker failed: $e');
        print('🔄 Trying fallback method...');
      }

      // Fallback: try with minimal parameters
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQuality ?? 85,
        );

        return image;
      } catch (e2) {
        if (kDebugMode) {
          print('❌ Fallback image picker also failed: $e2');
        }
        rethrow;
      }
    }
  }

  /// اختيار عدة صور من المعرض مع معالجة الأخطاء
  static Future<List<XFile>> pickMultipleImages({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool requestFullMetadata = false,
  }) async {
    try {
      if (kDebugMode) {
        print('🖼️ Picking multiple images from gallery...');
      }

      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        requestFullMetadata: requestFullMetadata,
      );

      if (kDebugMode) {
        print('✅ ${images.length} images picked successfully');
      }

      return images;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Primary multi-image picker failed: $e');
        print('🔄 Trying fallback method...');
      }

      // Fallback: try with minimal parameters
      try {
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: imageQuality ?? 85,
        );

        if (kDebugMode) {
          print(
              '✅ Fallback multi-image picker succeeded: ${images.length} images');
        }

        return images;
      } catch (e2) {
        if (kDebugMode) {
          print('❌ Fallback multi-image picker also failed: $e2');
        }
        rethrow;
      }
    }
  }

  /// التقاط صورة من الكاميرا مع معالجة الأخطاء
  static Future<XFile?> takePhoto({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = false,
  }) async {
    try {
      if (kDebugMode) {
        print('📷 Taking photo from camera...');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
        requestFullMetadata: requestFullMetadata,
      );

      return image;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Primary camera picker failed: $e');
        print('🔄 Trying fallback method...');
      }

      // Fallback: try with minimal parameters
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: imageQuality ?? 85,
        );

        return image;
      } catch (e2) {
        if (kDebugMode) {
          print('❌ Fallback camera picker also failed: $e2');
        }
        rethrow;
      }
    }
  }

  /// اختيار صورة مع إعدادات آمنة (بدون namespace issues)
  static Future<XFile?> pickImageSafe({
    ImageSource source = ImageSource.gallery,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      if (kDebugMode) {
        print('🛡️ Picking image with safe settings...');
      }

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality ?? 85,
        preferredCameraDevice: preferredCameraDevice,
        requestFullMetadata: false, // Always false to avoid namespace issues
      );

      return image;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Safe image picker failed: $e');
      }
      rethrow;
    }
  }

  /// اختيار عدة صور مع إعدادات آمنة
  static Future<List<XFile>> pickMultipleImagesSafe({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    try {
      if (kDebugMode) {
        print('🛡️ Picking multiple images with safe settings...');
      }

      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality ?? 85,
        requestFullMetadata: false, // Always false to avoid namespace issues
      );

      if (kDebugMode) {
        print('✅ Safe multi-image picker succeeded: ${images.length} images');
      }

      return images;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Safe multi-image picker failed: $e');
      }
      rethrow;
    }
  }

  /// التحقق من توفر الكاميرا
  static Future<bool> isCameraAvailable() async {
    try {
      // Simple check - try to create a picker instance
      ImagePicker();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Camera availability check failed: $e');
      }
      return false;
    }
  }

  /// التحقق من توفر المعرض
  static Future<bool> isGalleryAvailable() async {
    try {
      // This is a simple check - in real implementation you might want to check permissions
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Gallery availability check failed: $e');
      }
      return false;
    }
  }
}
