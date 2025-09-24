import 'dart:io';

import 'package:brother_admin_panel/features/dashboard/controllers/blog_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildImageSection extends StatelessWidget {
  const BuildImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BlogController>();
    final isDark = Get.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صور المقال',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Image Selection Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.pickImagesFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text('من المعرض'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.pickImageFromCamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text('الكاميرا'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Upload Images Button
        if (controller.selectedImages.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton.icon(
              onPressed: controller.selectedImages.isNotEmpty &&
                      !controller.isUploading.value
                  ? () async {
                      await controller.uploadSelectedImages();
                    }
                  : null,
              icon: const Icon(Icons.cloud_upload),
              label: const Text('رفع الصور إلى Firebase Storage'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

        // Selected Images with Loading States
        Obx(() {
          if (controller.selectedImages.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الصور المختارة:',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.selectedImages.length,
                    itemBuilder: (context, index) {
                      return _buildSelectedImageCard(
                        controller,
                        index,
                        isDark,
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),

        // Uploaded Images
        Obx(() {
          if (controller.uploadedImages.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'الصور المرفوعة:',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.uploadedImages.length,
                    itemBuilder: (context, index) {
                      return _buildUploadedImageCard(
                        controller,
                        index,
                        isDark,
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),

        // Upload Progress
        Obx(() {
          if (controller.isUploading.value) {
            return Column(
              children: [
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: controller.uploadProgress.value,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 8),
                Text(
                  'جاري رفع الصور... ${(controller.uploadProgress.value * 100).toInt()}%',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildSelectedImageCard(
    BlogController controller,
    int index,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImageWidget(
                controller.selectedImages[index],
                controller,
                isDark,
              ),
            ),
          ),

          // Remove Button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => controller.removeSelectedImage(index),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          // Loading State Overlay
          Obx(() {
            if (controller.isUploading.value || controller.isPreparing.value) {
              return Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hourglass Icon
                        const Icon(
                          Icons.hourglass_empty,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        // Progress Text
                        Text(
                          controller.isPreparing.value
                              ? 'جاري التحضير...'
                              : 'جاري الرفع...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Progress Percentage
                        if (controller.uploadProgress.value > 0)
                          Text(
                            '${(controller.uploadProgress.value * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Success State Overlay (when upload is complete)
          Obx(() {
            if (!controller.isUploading.value &&
                controller.uploadedImages.isNotEmpty &&
                index < controller.selectedImages.length) {
              // Check if this image has been uploaded
              final imagePath = controller.selectedImages[index];
              final isUploaded = controller.uploadedImages.any((url) =>
                  url.contains(imagePath.split('/').last) ||
                  url.contains(imagePath.split('\\').last));

              if (isUploaded) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                );
              }
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildUploadedImageCard(
    BlogController controller,
    int index,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Image.network(
                    controller.uploadedImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'جاري التحميل...',
                                style: TextStyle(
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 32,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'خطأ في التحميل',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Success Checkmark
                  const Positioned(
                    top: 8,
                    left: 8,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Delete Button for uploaded images
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _showDeleteConfirmation(controller, index, isDark),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(
    BlogController controller,
    int index,
    bool isDark,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
        title: Text(
          'حذف الصورة',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذه الصورة؟',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.removeUploadedImage(index);
              Get.snackbar(
                'تم الحذف',
                'تم حذف الصورة بنجاح',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // دالة لبناء widget الصورة مع دعم Flutter Web
  Widget _buildImageWidget(
    String imagePath,
    BlogController controller,
    bool isDark,
  ) {
    if (kIsWeb) {
      // على Flutter Web، استخدم Image.network أو Image.memory
      if (imagePath.startsWith('http')) {
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey.shade300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'جاري التحميل...',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    color: isDark ? Colors.white54 : Colors.black54,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'خطأ في التحميل',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        // للصور المحلية على الويب، استخدم Image.memory إذا كانت متوفرة
        final imageIndex = _getImageIndex(imagePath, controller);

        if (imageIndex != -1 &&
            imageIndex < controller.selectedImageBytes.length) {
          return Image.memory(
            controller.selectedImageBytes[imageIndex],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      color: isDark ? Colors.white54 : Colors.black54,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'خطأ في التحميل',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          // للصور المحلية على الويب، استخدم placeholder مع معلومات أكثر
          return Container(
            color: Colors.grey.shade300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  color: isDark ? Colors.white54 : Colors.black54,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'صورة محلية',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'سيتم رفعها عند الحفظ',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        }
      }
    } else {
      // على Mobile، استخدم Image.file
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  color: isDark ? Colors.white54 : Colors.black54,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'خطأ في التحميل',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  // دالة مساعدة للعثور على فهرس الصورة
  int _getImageIndex(String imagePath, BlogController controller) {
    try {
      for (int i = 0; i < controller.selectedImages.length; i++) {
        if (controller.selectedImages[i] == imagePath) {
          if (kDebugMode) {
            print('🔍 Found image at index $i for path: $imagePath');
          }
          return i;
        }
      }
      if (kDebugMode) {
        print('⚠️ Image not found in selectedImages: $imagePath');
        print('📸 Available paths: ${controller.selectedImages}');
      }
      return -1;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in _getImageIndex: $e');
      }
      return -1;
    }
  }
}
