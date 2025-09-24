import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class BannerImageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// رفع صورة بانر إلى Firebase Storage
  static Future<String> uploadBannerImage({
    required String imageData,
    String? fileName,
  }) async {
    try {
      if (kDebugMode) {
        print('🔄 Starting banner image upload...');
        print(
            '   - Image data type: ${imageData.startsWith('data:image') ? 'base64' : 'other'}');
        print('   - Image data length: ${imageData.length}');
      }

      // إنشاء اسم ملف فريد
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final finalFileName = fileName ?? 'banner_$timestamp.jpg';
      final storagePath = 'banners/$finalFileName';

      if (kDebugMode) {
        print('📁 Storage path: $storagePath');
      }

      // إنشاء مرجع Firebase Storage
      final Reference ref = _storage.ref().child(storagePath);

      // تحديد نوع الملف
      final metadata = SettableMetadata(
        contentType: _getContentType(finalFileName),
        cacheControl: 'public, max-age=31536000', // cache لمدة سنة
      );

      String downloadUrl;

      if (imageData.startsWith('data:image')) {
        // معالجة base64
        if (kDebugMode) {
          print('📱 Processing base64 image...');
        }

        final base64String = imageData.split(',')[1];
        final bytes = base64Decode(base64String);

        if (kDebugMode) {
          print('📊 Decoded bytes length: ${bytes.length}');
        }

        // رفع الـ bytes مباشرة
        await ref.putData(Uint8List.fromList(bytes), metadata);
        downloadUrl = await ref.getDownloadURL();

        if (kDebugMode) {
          print('✅ Base64 image uploaded successfully');
        }
      } else if (imageData.startsWith('http')) {
        // إذا كان URL موجود بالفعل، إرجاعه
        if (kDebugMode) {
          print('🔗 Image is already a URL, returning as is');
        }
        return imageData;
      } else {
        // معالجة مسار الملف
        if (kDebugMode) {
          print('📁 Processing file path...');
        }

        final file = File(imageData);
        if (!await file.exists()) {
          throw Exception('File does not exist: $imageData');
        }

        await ref.putFile(file, metadata);
        downloadUrl = await ref.getDownloadURL();

        if (kDebugMode) {
          print('✅ File image uploaded successfully');
        }
      }

      if (kDebugMode) {
        print('🔗 Download URL: $downloadUrl');
      }

      return downloadUrl;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error during upload: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw 'Firebase error: ${e.message}';
    } catch (e) {
      if (kDebugMode) {
        print('❌ General error during upload: $e');
        print('❌ Error type: ${e.runtimeType}');
      }
      throw 'Upload error: $e';
    }
  }

  /// رفع صورة من XFile
  static Future<String> uploadBannerImageFromXFile({
    required XFile xFile,
    String? fileName,
  }) async {
    try {
      if (kDebugMode) {
        print('🔄 Starting XFile upload...');
        print('   - File name: ${xFile.name}');
        print('   - File path: ${xFile.path}');
      }

      // إنشاء اسم ملف فريد
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final finalFileName =
          fileName ?? 'banner_$timestamp.${xFile.name.split('.').last}';
      final storagePath = 'banners/$finalFileName';

      if (kDebugMode) {
        print('📁 Storage path: $storagePath');
      }

      // إنشاء مرجع Firebase Storage
      final Reference ref = _storage.ref().child(storagePath);

      // تحديد نوع الملف
      final metadata = SettableMetadata(
        contentType: _getContentType(finalFileName),
        cacheControl: 'public, max-age=31536000',
      );

      String downloadUrl;

      if (kIsWeb) {
        // للويب - قراءة bytes
        final bytes = await xFile.readAsBytes();
        await ref.putData(Uint8List.fromList(bytes), metadata);
        downloadUrl = await ref.getDownloadURL();

        if (kDebugMode) {
          print('✅ Web XFile upload completed');
        }
      } else {
        // للموبايل/سطح المكتب - استخدام File
        final file = File(xFile.path);
        await ref.putFile(file, metadata);
        downloadUrl = await ref.getDownloadURL();

        if (kDebugMode) {
          print('✅ Mobile/Desktop XFile upload completed');
        }
      }

      if (kDebugMode) {
        print('🔗 Download URL: $downloadUrl');
      }

      return downloadUrl;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error during XFile upload: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw 'Firebase error: ${e.message}';
    } catch (e) {
      if (kDebugMode) {
        print('❌ General error during XFile upload: $e');
        print('❌ Error type: ${e.runtimeType}');
      }
      throw 'XFile upload error: $e';
    }
  }

  /// حذف صورة من Firebase Storage
  static Future<void> deleteBannerImage(String imageUrl) async {
    try {
      if (kDebugMode) {
        print('🗑️ Starting image deletion...');
        print('   - Image URL: $imageUrl');
      }

      // استخراج مسار الصورة من URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      if (pathSegments.length < 2) {
        throw Exception('Invalid image URL format');
      }

      // إنشاء مسار Firebase Storage
      final storagePath = pathSegments.sublist(1).join('/');

      if (kDebugMode) {
        print('📁 Storage path to delete: $storagePath');
      }

      // حذف الصورة
      final Reference ref = _storage.ref().child(storagePath);
      await ref.delete();

      if (kDebugMode) {
        print('✅ Image deleted successfully');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error during deletion: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw 'Firebase deletion error: ${e.message}';
    } catch (e) {
      if (kDebugMode) {
        print('❌ General error during deletion: $e');
        print('❌ Error type: ${e.runtimeType}');
      }
      throw 'Deletion error: $e';
    }
  }

  /// تحديد نوع الملف
  static String _getContentType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      default:
        return 'image/jpeg'; // افتراضي
    }
  }

  /// التحقق من صحة URL
  static bool isValidImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// استخراج اسم الملف من URL
  static String getFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      return pathSegments.isNotEmpty ? pathSegments.last : 'unknown';
    } catch (e) {
      return 'unknown';
    }
  }

  /// تحويل base64 إلى URL
  static Future<String> convertBase64ToUrl(String base64Image) async {
    try {
      if (kDebugMode) {
        print('🔄 Converting base64 to Firebase Storage URL...');
      }

      final url = await uploadBannerImage(imageData: base64Image);

      if (kDebugMode) {
        print('✅ Base64 converted to URL: $url');
      }

      return url;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error converting base64 to URL: $e');
      }
      throw 'Base64 conversion error: $e';
    }
  }
}
