import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService extends GetxService {
  static FirebaseStorageService get instance => Get.find();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// رفع صورة واحدة إلى Firebase Storage
  Future<String> uploadImage({
    required String imagePath,
    required String folder,
    String? fileName,
  }) async {
    try {
      // إنشاء اسم فريد للملف
      final fileExtension = imagePath.split('.').last;
      final uniqueFileName = fileName ?? '${_uuid.v4()}.$fileExtension';
      final storagePath = '$folder/$uniqueFileName';

      if (kDebugMode) {
        print('📤 FirebaseStorageService: Starting upload to $storagePath');
      }

      // إنشاء مرجع للملف
      final ref = _storage.ref().child(storagePath);

      // رفع الملف
      final uploadTask = ref.putFile(
        imagePath.contains('http')
            ? await _downloadFileFromUrl(imagePath)
            : await _getFileFromPath(imagePath),
      );

      // مراقبة التقدم
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (kDebugMode) {
          print(
              '📤 Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes * 100).toStringAsFixed(1)}%');
        }
      });

      // انتظار اكتمال الرفع
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print('✅ FirebaseStorageService: Upload completed - $downloadUrl');
      }

      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('❌ FirebaseStorageService: Upload failed - $e');
      }
      rethrow;
    }
  }

  /// رفع عدة صور إلى Firebase Storage
  Future<List<String>> uploadMultipleImages({
    required List<String> imagePaths,
    required String folder,
    Function(double progress)? onProgress,
  }) async {
    try {
      final List<String> downloadUrls = [];
      final totalImages = imagePaths.length;

      for (int i = 0; i < imagePaths.length; i++) {
        final imagePath = imagePaths[i];

        if (kDebugMode) {
          print(
              '📤 FirebaseStorageService: Uploading image ${i + 1}/$totalImages');
        }

        try {
          final downloadUrl = await uploadImage(
            imagePath: imagePath,
            folder: folder,
          );
          downloadUrls.add(downloadUrl);

          // تحديث التقدم
          final progress = (i + 1) / totalImages;
          onProgress?.call(progress);

          if (kDebugMode) {
            print(
                '✅ FirebaseStorageService: Image ${i + 1} uploaded successfully');
          }
        } catch (e) {
          if (kDebugMode) {
            print(
                '❌ FirebaseStorageService: Failed to upload image ${i + 1}: $e');
          }
          // يمكن إضافة الصورة إلى قائمة الأخطاء بدلاً من إيقاف العملية
          continue;
        }
      }

      if (kDebugMode) {
        print(
            '✅ FirebaseStorageService: All images uploaded - ${downloadUrls.length}/$totalImages');
      }

      return downloadUrls;
    } catch (e) {
      if (kDebugMode) {
        print('❌ FirebaseStorageService: Multiple upload failed - $e');
      }
      rethrow;
    }
  }

  /// رفع بيانات صورة (bytes) إلى Firebase Storage
  Future<String> uploadImageBytes({
    required Uint8List imageBytes,
    required String folder,
    String? fileName,
    String fileExtension = 'jpg',
  }) async {
    try {
      // إنشاء اسم فريد للملف
      final uniqueFileName = fileName ?? '${_uuid.v4()}.$fileExtension';
      final storagePath = '$folder/$uniqueFileName';

      if (kDebugMode) {
        print(
            '📤 FirebaseStorageService: Starting bytes upload to $storagePath');
      }

      // إنشاء مرجع للملف
      final ref = _storage.ref().child(storagePath);

      // رفع البيانات
      final uploadTask = ref.putData(imageBytes);

      // مراقبة التقدم
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (kDebugMode) {
          print(
              '📤 Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes * 100).toStringAsFixed(1)}%');
        }
      });

      // انتظار اكتمال الرفع
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print(
            '✅ FirebaseStorageService: Bytes upload completed - $downloadUrl');
      }

      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('❌ FirebaseStorageService: Bytes upload failed - $e');
      }
      rethrow;
    }
  }

  /// رفع عدة صور كـ bytes
  Future<List<String>> uploadMultipleImageBytes({
    required List<Uint8List> imageBytesList,
    required String folder,
    Function(double progress)? onProgress,
  }) async {
    try {
      final List<String> downloadUrls = [];
      final totalImages = imageBytesList.length;

      for (int i = 0; i < imageBytesList.length; i++) {
        final imageBytes = imageBytesList[i];

        if (kDebugMode) {
          print(
              '📤 FirebaseStorageService: Uploading bytes ${i + 1}/$totalImages');
        }

        try {
          final downloadUrl = await uploadImageBytes(
            imageBytes: imageBytes,
            folder: folder,
          );
          downloadUrls.add(downloadUrl);

          // تحديث التقدم
          final progress = (i + 1) / totalImages;
          onProgress?.call(progress);

          if (kDebugMode) {
            print(
                '✅ FirebaseStorageService: Bytes ${i + 1} uploaded successfully');
          }
        } catch (e) {
          if (kDebugMode) {
            print(
                '❌ FirebaseStorageService: Failed to upload bytes ${i + 1}: $e');
          }
          continue;
        }
      }

      if (kDebugMode) {
        print(
            '✅ FirebaseStorageService: All bytes uploaded - ${downloadUrls.length}/$totalImages');
      }

      return downloadUrls;
    } catch (e) {
      if (kDebugMode) {
        print('❌ FirebaseStorageService: Multiple bytes upload failed - $e');
      }
      rethrow;
    }
  }

  /// حذف صورة من Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();

      if (kDebugMode) {
        print('✅ FirebaseStorageService: Image deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ FirebaseStorageService: Failed to delete image - $e');
      }
      rethrow;
    }
  }

  /// حذف عدة صور من Firebase Storage
  Future<void> deleteMultipleImages(List<String> imageUrls) async {
    try {
      final futures = imageUrls.map(deleteImage);
      await Future.wait(futures);

      if (kDebugMode) {
        print('✅ FirebaseStorageService: All images deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ FirebaseStorageService: Failed to delete some images - $e');
      }
      rethrow;
    }
  }

  /// مساعد: تحميل ملف من URL (للصور الموجودة على الإنترنت)
  Future<File> _downloadFileFromUrl(String url) async {
    // هذا يتطلب تنفيذ إضافي لتحميل الملف من URL
    // يمكن استخدام http package لتحميل الملف
    throw UnimplementedError('Download from URL not implemented yet');
  }

  /// مساعد: الحصول على File من المسار
  Future<File> _getFileFromPath(String path) async {
    // هذا يتطلب تنفيذ إضافي للحصول على File من المسار
    // يمكن استخدام path_provider package
    return File(path);
  }
}
