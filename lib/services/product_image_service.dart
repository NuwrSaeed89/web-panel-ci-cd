import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ProductImageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// رفع صورة منتج إلى Firebase Storage
  static Future<String> uploadProductImage({
    required String imageData,
    String? fileName,
  }) async {
    try {
      if (kDebugMode) {
        print('🔄 Starting product image upload...');
        print(
            '   - Image data type: ${imageData.startsWith('data:image') ? 'base64' : 'other'}');
        print('   - Image data length: ${imageData.length}');
      }

      // إنشاء اسم ملف فريد
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final finalFileName = fileName ?? 'product_$timestamp.jpg';
      final storagePath = 'products/$finalFileName';

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
  static Future<String> uploadProductImageFromXFile({
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
          fileName ?? 'product_$timestamp.${xFile.name.split('.').last}';
      final storagePath = 'products/$finalFileName';

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

  /// رفع عدة صور منتج
  static Future<List<String>> uploadMultipleProductImages({
    required List<String> imageDataList,
    String? prefix,
  }) async {
    try {
      if (kDebugMode) {
        print('🔄 Starting multiple product images upload...');
        print('   - Images count: ${imageDataList.length}');
      }

      final List<String> uploadedUrls = [];
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      for (int i = 0; i < imageDataList.length; i++) {
        final imageData = imageDataList[i];
        final fileName = '${prefix ?? 'product'}_${timestamp}_$i.jpg';

        if (kDebugMode) {
          print(
              '📤 Uploading image ${i + 1}/${imageDataList.length}: $fileName');
        }

        final url = await uploadProductImage(
          imageData: imageData,
          fileName: fileName,
        );

        uploadedUrls.add(url);

        if (kDebugMode) {
          print('✅ Image ${i + 1} uploaded successfully');
        }
      }

      if (kDebugMode) {
        print('✅ All ${uploadedUrls.length} images uploaded successfully');
      }

      return uploadedUrls;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error uploading multiple images: $e');
      }
      throw 'Multiple upload error: $e';
    }
  }

  /// حذف صورة من Firebase Storage
  static Future<void> deleteProductImage(String imageUrl) async {
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

  /// حذف عدة صور
  static Future<void> deleteMultipleProductImages(
      List<String> imageUrls) async {
    try {
      if (kDebugMode) {
        print('🗑️ Starting multiple images deletion...');
        print('   - Images count: ${imageUrls.length}');
      }

      for (int i = 0; i < imageUrls.length; i++) {
        final imageUrl = imageUrls[i];

        if (kDebugMode) {
          print('🗑️ Deleting image ${i + 1}/${imageUrls.length}');
        }

        await deleteProductImage(imageUrl);

        if (kDebugMode) {
          print('✅ Image ${i + 1} deleted successfully');
        }
      }

      if (kDebugMode) {
        print('✅ All ${imageUrls.length} images deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting multiple images: $e');
      }
      throw 'Multiple deletion error: $e';
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

      final url = await uploadProductImage(imageData: base64Image);

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

  /// تحويل قائمة base64 إلى URLs
  static Future<List<String>> convertBase64ListToUrls(
      List<String> base64Images) async {
    try {
      if (kDebugMode) {
        print('🔄 Converting base64 list to URLs...');
        print('   - Images count: ${base64Images.length}');
      }

      final List<String> urls = [];

      for (int i = 0; i < base64Images.length; i++) {
        final base64Image = base64Images[i];

        if (kDebugMode) {
          print('🔄 Converting image ${i + 1}/${base64Images.length}');
        }

        if (base64Image.startsWith('data:image')) {
          final url = await convertBase64ToUrl(base64Image);
          urls.add(url);
        } else if (base64Image.startsWith('http')) {
          // إذا كان URL موجود بالفعل
          urls.add(base64Image);
        } else {
          // إذا كان مسار ملف
          final url = await uploadProductImage(imageData: base64Image);
          urls.add(url);
        }

        if (kDebugMode) {
          print('✅ Image ${i + 1} converted successfully');
        }
      }

      if (kDebugMode) {
        print('✅ All ${urls.length} images converted successfully');
      }

      return urls;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error converting base64 list to URLs: $e');
      }
      throw 'Base64 list conversion error: $e';
    }
  }
}
