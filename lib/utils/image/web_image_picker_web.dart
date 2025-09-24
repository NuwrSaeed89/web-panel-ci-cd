import 'dart:async';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Web-specific implementation for image picker
class WebImagePickerWeb {
  static final ImagePicker _picker = ImagePicker();

  /// اختيار صورة واحدة من المعرض للويب
  static Future<XFile?> pickSingleImageWeb({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      if (kDebugMode) {
        print('🌐 Picking single image for web...');
      }

      // Create file input element
      final html.FileUploadInputElement input = html.FileUploadInputElement()
        ..accept = 'image/*'
        ..multiple = false;

      // Create a completer to handle the async file selection
      final completer = Completer<XFile?>();

      input.onChange.listen((event) {
        final files = input.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          if (kDebugMode) {
            print('📁 File selected: ${file.name} (${file.size} bytes)');
          }

          // Convert to XFile
          final reader = html.FileReader();
          reader.onLoad.listen((e) {
            final bytes = reader.result as Uint8List;
            final xFile = XFile.fromData(
              bytes,
              name: file.name,
            );
            completer.complete(xFile);
          });
          reader.onError.listen((e) {
            completer.completeError('Failed to read file: $e');
          });
          reader.readAsArrayBuffer(file);
        } else {
          completer.complete(null);
        }
      });

      // Trigger file selection
      input.click();

      return await completer.future;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Web image picker failed: $e');
      }

      // Fallback to standard image picker
      try {
        return await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: maxWidth?.toDouble(),
          maxHeight: maxHeight?.toDouble(),
          imageQuality: imageQuality,
          requestFullMetadata: false,
        );
      } catch (e2) {
        if (kDebugMode) {
          print('❌ Fallback image picker also failed: $e2');
        }
        rethrow;
      }
    }
  }

  /// اختيار عدة صور من المعرض للويب
  static Future<List<XFile>> pickMultipleImagesWeb({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      if (kDebugMode) {
        print('🌐 Picking multiple images for web...');
      }

      // Create file input element
      final html.FileUploadInputElement input = html.FileUploadInputElement()
        ..accept = 'image/*'
        ..multiple = true;

      // Create a completer to handle the async file selection
      final completer = Completer<List<XFile>>();

      input.onChange.listen((event) {
        final files = input.files;
        if (files != null && files.isNotEmpty) {
          if (kDebugMode) {
            print('📁 ${files.length} files selected');
          }

          final List<XFile> xFiles = [];
          int processedFiles = 0;

          for (int i = 0; i < files.length; i++) {
            final file = files[i];
            final reader = html.FileReader();

            reader.onLoad.listen((e) {
              final bytes = reader.result as Uint8List;
              final xFile = XFile.fromData(
                bytes,
                name: file.name,
              );
              xFiles.add(xFile);
              processedFiles++;

              if (processedFiles == files.length) {
                completer.complete(xFiles);
              }
            });

            reader.onError.listen((e) {
              processedFiles++;
              if (processedFiles == files.length) {
                completer.complete(xFiles);
              }
            });

            reader.readAsArrayBuffer(file);
          }
        } else {
          completer.complete([]);
        }
      });

      // Trigger file selection
      input.click();

      return await completer.future;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Web multi-image picker failed: $e');
      }

      // Fallback to standard image picker
      try {
        return await _picker.pickMultiImage(
          maxWidth: maxWidth?.toDouble(),
          maxHeight: maxHeight?.toDouble(),
          imageQuality: imageQuality,
          requestFullMetadata: false,
        );
      } catch (e2) {
        if (kDebugMode) {
          print('❌ Fallback multi-image picker also failed: $e2');
        }
        rethrow;
      }
    }
  }

  /// التحقق من دعم اختيار الصور في المتصفح
  static bool isImagePickerSupported() {
    try {
      // Check if FileUploadInputElement is supported
      html.FileUploadInputElement();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Image picker not supported in this browser: $e');
      }
      return false;
    }
  }

  /// الحصول على معلومات المتصفح
  static Map<String, String> getBrowserInfo() {
    try {
      final userAgent = html.window.navigator.userAgent;
      final platform = html.window.navigator.platform;

      return {
        'userAgent': userAgent,
        'platform': platform ?? 'Unknown',
        'language': html.window.navigator.language,
        'cookieEnabled': html.window.navigator.cookieEnabled.toString(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to get browser info: $e');
      }
      return {};
    }
  }
}
