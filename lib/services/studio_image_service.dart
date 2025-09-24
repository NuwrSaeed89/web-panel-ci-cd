import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class StudioImageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// رفع صورة المعرض إلى Firebase Storage
  /// يمكن أن تكون imageData مسار ملف محلي أو سلسلة base64
  static Future<String> uploadGalleryImage({
    required String imageData,
    String folder = 'gallery',
  }) async {
    try {
      final String fileName =
          'gallery_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child(folder).child(fileName);

      UploadTask uploadTask;
      if (imageData.startsWith('data:image')) {
        // إذا كانت base64
        final base64String = imageData.split(',')[1];
        final bytes = base64Decode(base64String);
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        if (kDebugMode) {
          print('📤 Uploading base64 gallery image to Firebase Storage...');
        }
      } else if (imageData.startsWith('http')) {
        // إذا كان URL بالفعل، لا نفعل شيئاً ونعيدها
        if (kDebugMode) {
          print('🔗 Gallery image is already a URL: $imageData');
        }
        return imageData;
      } else {
        // إذا كان مسار ملف محلي
        final file = File(imageData);
        uploadTask = ref.putFile(file);
        if (kDebugMode) {
          print(
              '📤 Uploading local gallery file to Firebase Storage: ${file.path}');
        }
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print('✅ Gallery image uploaded successfully: $downloadUrl');
      }
      return downloadUrl;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error uploading gallery image: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw 'Firebase Error: ${e.message}';
    } catch (e) {
      if (kDebugMode) {
        print('❌ General error uploading gallery image: $e');
      }
      throw 'Failed to upload gallery image: $e';
    }
  }

  /// رفع صورة المعرض من XFile إلى Firebase Storage
  static Future<String> uploadGalleryImageFromXFile({
    required XFile xFile,
    String folder = 'gallery',
  }) async {
    try {
      final String fileName =
          'gallery_${DateTime.now().millisecondsSinceEpoch}_${xFile.name}';
      final Reference ref = _storage.ref().child(folder).child(fileName);

      UploadTask uploadTask;
      if (kIsWeb) {
        // للويب، نستخدم putData مع bytes
        final bytes = await xFile.readAsBytes();
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: xFile.mimeType ?? 'image/jpeg'),
        );
        if (kDebugMode) {
          print(
              '📤 Uploading XFile bytes for gallery web to Firebase Storage...');
        }
      } else {
        // للموبايل/سطح المكتب، نستخدم putFile
        final file = File(xFile.path);
        uploadTask = ref.putFile(file);
        if (kDebugMode) {
          print(
              '📤 Uploading XFile file for gallery mobile/desktop to Firebase Storage: ${file.path}');
        }
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print('✅ Gallery XFile uploaded successfully: $downloadUrl');
      }
      return downloadUrl;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error uploading gallery XFile: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw 'Firebase Error: ${e.message}';
    } catch (e) {
      if (kDebugMode) {
        print('❌ General error uploading gallery XFile: $e');
      }
      throw 'Failed to upload gallery XFile: $e';
    }
  }

  /// رفع صورة الألبوم إلى Firebase Storage
  /// يمكن أن تكون imageData مسار ملف محلي أو سلسلة base64
  static Future<String> uploadAlbumImage({
    required String imageData,
    String folder = 'albums',
  }) async {
    try {
      final String fileName =
          'album_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child(folder).child(fileName);

      UploadTask uploadTask;
      if (imageData.startsWith('data:image')) {
        // إذا كانت base64
        final base64String = imageData.split(',')[1];
        final bytes = base64Decode(base64String);
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        if (kDebugMode) {
          print('📤 Uploading base64 album image to Firebase Storage...');
        }
      } else if (imageData.startsWith('http')) {
        // إذا كان URL بالفعل، لا نفعل شيئاً ونعيدها
        if (kDebugMode) {
          print('🔗 Album image is already a URL: $imageData');
        }
        return imageData;
      } else {
        // إذا كان مسار ملف محلي
        final file = File(imageData);
        uploadTask = ref.putFile(file);
        if (kDebugMode) {
          print(
              '📤 Uploading local album file to Firebase Storage: ${file.path}');
        }
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print('✅ Album image uploaded successfully: $downloadUrl');
      }
      return downloadUrl;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error uploading album image: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw 'Firebase Error: ${e.message}';
    } catch (e) {
      if (kDebugMode) {
        print('❌ General error uploading album image: $e');
      }
      throw 'Failed to upload album image: $e';
    }
  }

  /// رفع صورة الألبوم من XFile إلى Firebase Storage
  static Future<String> uploadAlbumImageFromXFile({
    required XFile xFile,
    String folder = 'albums',
  }) async {
    try {
      final String fileName =
          'album_${DateTime.now().millisecondsSinceEpoch}_${xFile.name}';
      final Reference ref = _storage.ref().child(folder).child(fileName);

      UploadTask uploadTask;
      if (kIsWeb) {
        // للويب، نستخدم putData مع bytes
        final bytes = await xFile.readAsBytes();
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: xFile.mimeType ?? 'image/jpeg'),
        );
        if (kDebugMode) {
          print(
              '📤 Uploading XFile bytes for album web to Firebase Storage...');
        }
      } else {
        // للموبايل/سطح المكتب، نستخدم putFile
        final file = File(xFile.path);
        uploadTask = ref.putFile(file);
        if (kDebugMode) {
          print(
              '📤 Uploading XFile file for album mobile/desktop to Firebase Storage: ${file.path}');
        }
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print('✅ Album XFile uploaded successfully: $downloadUrl');
      }
      return downloadUrl;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error uploading album XFile: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw 'Firebase Error: ${e.message}';
    } catch (e) {
      if (kDebugMode) {
        print('❌ General error uploading album XFile: $e');
      }
      throw 'Failed to upload album XFile: $e';
    }
  }

  /// تحويل صورة base64 إلى URL في Firebase Storage
  static Future<String> convertBase64ToUrl(String base64Image,
      {String folder = 'gallery'}) async {
    try {
      final String fileName =
          'converted_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child(folder).child(fileName);

      final base64String = base64Image.split(',')[1];
      final bytes = base64Decode(base64String);
      final uploadTask = ref.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print('✅ Base64 image converted and uploaded to URL: $downloadUrl');
      }
      return downloadUrl;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error converting base64 image: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw 'Firebase Error converting base64 image: ${e.message}';
    } catch (e) {
      if (kDebugMode) {
        print('❌ General error converting base64 image: $e');
      }
      throw 'Failed to convert base64 image: $e';
    }
  }
}
