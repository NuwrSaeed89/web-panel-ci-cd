import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/image/image_crop_service.dart';

class EnhancedImageUploadService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadSingleImage({
    required String folderPath,
    required dynamic
        imageData, // يمكن أن يكون File أو List<int> أو String (path)
    String? fileName,
    CropParameters? cropParameters, // معاملات الاقتصاص
    Function(double progress)? onProgress,
    Function(String error)? onError,
  }) async {
    try {
      if (kDebugMode) {
        print('🚀 Starting single image upload...');
        print('📁 Folder: $folderPath');
        print('📊 Image data type: ${imageData.runtimeType}');
      }

      // إنشاء اسم فريد للملف
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final finalFileName = fileName ?? 'image_$timestamp.jpg';
      final fullPath = '$folderPath/$finalFileName';

      if (kDebugMode) {
        print('📁 Full path: $fullPath');
        print('📁 File name: $finalFileName');
      }

      // معالجة الصورة (اقتصاص إذا لزم الأمر)
      Uint8List processedImageBytes;
      if (cropParameters != null) {
        if (kDebugMode) {
          print('✂️ Applying crop parameters...');
        }

        // تحويل البيانات إلى Uint8List
        Uint8List imageBytes;
        if (imageData is File) {
          imageBytes = await imageData.readAsBytes();
        } else if (imageData is List<int>) {
          imageBytes = Uint8List.fromList(imageData);
        } else if (imageData is String) {
          final file = File(imageData);
          if (await file.exists()) {
            imageBytes = await file.readAsBytes();
          } else {
            throw Exception('File not found: $imageData');
          }
        } else {
          throw Exception(
              'Unsupported image data type: ${imageData.runtimeType}');
        }

        // تطبيق الاقتصاص
        processedImageBytes = await ImageCropService.cropImage(
          imageBytes: imageBytes,
          parameters: cropParameters,
        );

        if (kDebugMode) {
          print('✅ Image cropped successfully');
          print('📊 Original size: ${imageBytes.length} bytes');
          print('📊 Cropped size: ${processedImageBytes.length} bytes');
        }
      } else {
        // بدون اقتصاص
        if (imageData is File) {
          processedImageBytes = await imageData.readAsBytes();
        } else if (imageData is List<int>) {
          processedImageBytes = Uint8List.fromList(imageData);
        } else if (imageData is String) {
          final file = File(imageData);
          if (await file.exists()) {
            processedImageBytes = await file.readAsBytes();
          } else {
            throw Exception('File not found: $imageData');
          }
        } else {
          throw Exception(
              'Unsupported image data type: ${imageData.runtimeType}');
        }
      }

      // إنشاء مرجع Firebase Storage
      final ref = _storage.ref().child(fullPath);

      // تحديد metadata للصورة
      final metadata = SettableMetadata(
        contentType: _getContentType(finalFileName),
        cacheControl: 'public, max-age=31536000', // cache لمدة سنة
      );

      // رفع الصورة المعالجة
      final uploadTask = ref.putData(processedImageBytes, metadata);

      // تتبع التقدم
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        if (onProgress != null) {
          onProgress(progress);
        }
        if (kDebugMode) {
          print('📊 Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
        }
      });

      // انتظار اكتمال الرفع
      final snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final downloadUrl = await snapshot.ref.getDownloadURL();

        if (kDebugMode) {
          print('✅ Image uploaded successfully');
          print('🔗 Download URL: $downloadUrl');
        }

        return downloadUrl;
      } else {
        throw Exception('Upload failed with state: ${snapshot.state}');
      }
    } catch (e) {
      if (onError != null) {
        onError(e.toString());
      }

      return null;
    }
  }

  /// رفع عدة صور مع تتبع التقدم
  /// Returns: قائمة URLs الصور المرفوعة
  static Future<List<String>> uploadMultipleImages({
    required String folderPath,
    required List<dynamic> imagesData,
    CropParameters? cropParameters, // معاملات الاقتصاص
    Function(double progress)? onProgress,
    Function(String error)? onError,
    Function(int completed, int total)? onImageCompleted,
  }) async {
    final uploadedUrls = <String>[];
    int completed = 0;

    try {
      if (kDebugMode) {
        print('🚀 Starting multiple images upload...');
        print('📁 Folder: $folderPath');
        print('📊 Images count: ${imagesData.length}');
      }

      for (int i = 0; i < imagesData.length; i++) {
        final imageData = imagesData[i];

        if (kDebugMode) {
          print('📤 Uploading image ${i + 1}/${imagesData.length}');
        }

        final url = await uploadSingleImage(
          folderPath: folderPath,
          imageData: imageData,
          fileName: 'image_${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
          cropParameters: cropParameters,
          onProgress: (progress) {
            // حساب التقدم الإجمالي
            final totalProgress = (completed + progress) / imagesData.length;
            if (onProgress != null) {
              onProgress(totalProgress);
            }
          },
          onError: onError,
        );

        if (url != null) {
          uploadedUrls.add(url);
          completed++;

          if (onImageCompleted != null) {
            onImageCompleted(completed, imagesData.length);
          }

          if (kDebugMode) {
            print('✅ Image ${i + 1} uploaded successfully');
          }
        } else {
          if (kDebugMode) {
            print('❌ Failed to upload image ${i + 1}');
          }
        }
      }

      if (kDebugMode) {
        print('🎉 Multiple images upload completed');
        print(
            '📊 Successfully uploaded: ${uploadedUrls.length}/${imagesData.length}');
      }

      return uploadedUrls;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in multiple images upload: $e');
      }

      if (onError != null) {
        onError(e.toString());
      }

      return uploadedUrls; // إرجاع الصور المرفوعة حتى لو فشل البعض
    }
  }

  /// حذف صورة من Firebase Storage
  static Future<bool> deleteImage(String imageUrl) async {
    try {
      if (kDebugMode) {
        print('🗑️ Deleting image: $imageUrl');
      }

      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();

      if (kDebugMode) {
        print('✅ Image deleted successfully');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting image: $e');
      }
      return false;
    }
  }

  /// حذف عدة صور
  static Future<int> deleteMultipleImages(List<String> imageUrls) async {
    int deletedCount = 0;

    for (final url in imageUrls) {
      final success = await deleteImage(url);
      if (success) {
        deletedCount++;
      }
    }

    if (kDebugMode) {
      print('🗑️ Deleted $deletedCount/${imageUrls.length} images');
    }

    return deletedCount;
  }

  /// التحقق من صحة الملف
  static bool isValidImageFile(dynamic file) {
    if (file is File) {
      final validExtensions = [
        '.jpg',
        '.jpeg',
        '.png',
        '.gif',
        '.webp',
        '.bmp'
      ];
      final fileName = file.path.toLowerCase();
      return validExtensions.any(fileName.endsWith);
    } else if (file is String) {
      final validExtensions = [
        '.jpg',
        '.jpeg',
        '.png',
        '.gif',
        '.webp',
        '.bmp'
      ];
      final fileName = file.toLowerCase();
      return validExtensions.any(fileName.endsWith);
    }
    return false;
  }

  /// الحصول على حجم الملف بالميجابايت
  static Future<double> getFileSizeInMB(dynamic file) async {
    if (file is File) {
      final bytes = await file.length();
      return bytes / (1024 * 1024);
    } else if (file is List<int>) {
      return file.length / (1024 * 1024);
    } else if (file is String) {
      final fileObj = File(file);
      if (await fileObj.exists()) {
        final bytes = await fileObj.length();
        return bytes / (1024 * 1024);
      }
    }
    return 0.0;
  }

  /// التحقق من حجم الملف
  static Future<bool> isFileSizeValid(dynamic file,
      {double maxSizeMB = 10.0}) async {
    final fileSizeMB = await getFileSizeInMB(file);
    return fileSizeMB <= maxSizeMB;
  }

  /// تحديد نوع الملف الصحيح
  static String _getContentType(String fileName) {
    final extension =
        fileName.toLowerCase().substring(fileName.lastIndexOf('.'));
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.bmp':
        return 'image/bmp';
      default:
        return 'image/jpeg';
    }
  }

  /// ضغط الصورة قبل الرفع (اختياري)
  static Future<Uint8List> compressImage(Uint8List imageBytes,
      {int quality = 85}) async {
    // يمكن إضافة مكتبة ضغط الصور هنا مثل flutter_image_compress
    // للآن نعيد نفس البيانات
    return imageBytes;
  }

  /// إنشاء thumbnail للصورة (اختياري)
  static Future<Uint8List> createThumbnail(Uint8List imageBytes,
      {int size = 200}) async {
    // يمكن إضافة مكتبة إنشاء thumbnails هنا
    // للآن نعيد نفس البيانات
    return imageBytes;
  }
}

/// Controller لإدارة حالة رفع الصور
class ImageUploadController extends GetxController {
  final _isUploading = false.obs;
  final _uploadProgress = 0.0.obs;
  final _uploadedUrls = <String>[].obs;
  final _errors = <String>[].obs;

  bool get isUploading => _isUploading.value;
  double get uploadProgress => _uploadProgress.value;
  List<String> get uploadedUrls => _uploadedUrls;
  List<String> get errors => _errors;

  /// رفع صورة واحدة
  Future<String?> uploadSingleImage({
    required String folderPath,
    required dynamic imageData,
    String? fileName,
    CropParameters? cropParameters,
  }) async {
    _isUploading.value = true;
    _uploadProgress.value = 0.0;
    _errors.clear();

    try {
      final url = await EnhancedImageUploadService.uploadSingleImage(
        folderPath: folderPath,
        imageData: imageData,
        fileName: fileName,
        cropParameters: cropParameters,
        onProgress: (progress) {
          _uploadProgress.value = progress;
        },
        onError: (error) {
          _errors.add(error);
        },
      );

      if (url != null) {
        _uploadedUrls.add(url);
      }

      return url;
    } finally {
      _isUploading.value = false;
    }
  }

  /// رفع عدة صور
  Future<List<String>> uploadMultipleImages({
    required String folderPath,
    required List<dynamic> imagesData,
    CropParameters? cropParameters,
  }) async {
    _isUploading.value = true;
    _uploadProgress.value = 0.0;
    _errors.clear();

    try {
      final urls = await EnhancedImageUploadService.uploadMultipleImages(
        folderPath: folderPath,
        imagesData: imagesData,
        cropParameters: cropParameters,
        onProgress: (progress) {
          _uploadProgress.value = progress;
        },
        onError: (error) {
          _errors.add(error);
        },
        onImageCompleted: (completed, total) {
          if (kDebugMode) {
            print('📊 Uploaded $completed/$total images');
          }
        },
      );

      _uploadedUrls.addAll(urls);
      return urls;
    } finally {
      _isUploading.value = false;
    }
  }

  /// مسح الصور المرفوعة
  Future<int> deleteUploadedImages() async {
    if (_uploadedUrls.isEmpty) return 0;

    final deletedCount =
        await EnhancedImageUploadService.deleteMultipleImages(_uploadedUrls);
    _uploadedUrls.clear();
    return deletedCount;
  }

  /// إعادة تعيين الحالة
  void reset() {
    _isUploading.value = false;
    _uploadProgress.value = 0.0;
    _uploadedUrls.clear();
    _errors.clear();
  }
}
