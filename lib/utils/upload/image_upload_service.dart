import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:brother_admin_panel/utils/image/unified_image_picker.dart';

class ImageUploadService {
  uploadCategoryPicture() async {
    try {
      final image = await UnifiedImagePicker.pickSingleImage(
          maxWidth: 512.0, maxHeight: 512.0, imageQuality: 70);
      if (image != null) {
        // start progress

        final ref = FirebaseStorage.instance
            .ref()
            .child('Categories/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(File(image.path));

        //Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        // await userRepository.updateSingleFieldUser(json);
        //user.value.profilePicture = imageUrl;
        //user.refresh();

        // TLoader.successSnackBar(
        //     title: 'Success', message: 'profile photo change successfully');
      }
    } catch (e) {
      //TLoader.erroreSnackBar(title: 'ohSnap', message: 'Something went wrong!');
    } finally {
      //stop loading parameter
    }
  }

  /// التحقق من صحة الملف
  static bool isValidImageFile(File file) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    final fileName = file.path.toLowerCase();

    return validExtensions.any(fileName.endsWith);
  }

  /// الحصول على حجم الملف بالميجابايت
  static double getFileSizeInMB(File file) {
    final bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  /// التحقق من حجم الملف (الحد الأقصى 10 ميجابايت)
  static bool isFileSizeValid(File file, {double maxSizeMB = 10.0}) {
    final fileSizeMB = getFileSizeInMB(file);
    return fileSizeMB <= maxSizeMB;
  }
}
