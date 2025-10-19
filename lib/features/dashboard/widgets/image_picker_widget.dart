import 'dart:io';
import 'dart:convert';

import 'package:brother_admin_panel/features/dashboard/controllers/category_controller.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:brother_admin_panel/utils/image/unified_image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final String? initialImageUrl;
  final Function(String imageUrl) onImageSelected;
  final Function(String error) onError;
  final double? width;
  final double? height;
  final String? label;

  const ImagePickerWidget({
    super.key,
    this.initialImageUrl,
    required this.onImageSelected,
    required this.onError,
    this.width,
    this.height,
    this.label,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _selectedImage;
  List<int>? _selectedImageBytes; // للويب
  String? _selectedImageName; // اسم الملف للويب
  String? _imageUrl;
  bool _isUploading = false;
  String? _errorMessage; // Error message for display

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              color: isDark ? Colors.white : Color(0xFF111111),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Image Display Area
        Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 200,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
          ),
          child: _buildImageContent(isDark),
        ),

        const SizedBox(height: 12),

        // Action Buttons
        Row(
          children: [
            // Pick Image Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickImage,
                icon: const Icon(Icons.photo_library, size: 20),
                label: const Text('اختيار صورة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Camera Button (only show on mobile)
            if (!kIsWeb) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isUploading ? null : _takePhoto,
                  icon: const Icon(Icons.camera_alt, size: 20),
                  label: const Text('التقاط صورة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),

        // Clear Image Button (only show when there's a selected image)
        if (_hasSelectedImage) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isUploading ? null : _clearSelectedImage,
              icon: const Icon(Icons.clear, size: 20),
              label: const Text('مسح الصورة المحددة'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],

        // Upload Progress
        if (_isUploading) ...[
          const SizedBox(height: 16),
          GetBuilder<CategoryController>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'جاري رفع الصورة...',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: controller.imageUploadProgress,
                    backgroundColor:
                        isDark ? Colors.black : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? TColors.primary : Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(controller.imageUploadProgress * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
        ],

        // Error Message
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageContent(bool isDark) {
    if (_isUploading) {
      return GetBuilder<CategoryController>(
        builder: (controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: controller.imageUploadProgress,
                  color: isDark ? Colors.white : Colors.blue,
                ),
                const SizedBox(height: 16),
                Text(
                  'جاري رفع الصورة...',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // عرض الصورة المحددة (بدون رفع)
    if (_selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            if (kIsWeb)
              Image.memory(
                _selectedImage!.readAsBytesSync(),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            else
              Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            // مؤشر أن هذه صورة جديدة
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'جديدة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // عرض الصورة المحددة للويب (bytes)
    if (_selectedImageBytes != null && _selectedImageBytes!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.memory(
              Uint8List.fromList(_selectedImageBytes!),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // مؤشر أن هذه صورة جديدة
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'جديدة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // عرض الصورة الموجودة مسبقاً
    if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          _imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(isDark);
          },
        ),
      );
    }

    return _buildPlaceholder(isDark);
  }

  Widget _buildPlaceholder(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48,
            color: isDark ? Colors.white54 : Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'لا توجد صورة',
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'اضغط لاختيار صورة',
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      // استخدام UnifiedImagePicker لجميع المنصات
      final XFile? image = await UnifiedImagePicker.pickSingleImage(
        maxWidth: 1920.0,
        maxHeight: 1080.0,
        imageQuality: 85,
      );

      if (image != null) {
        await _processSelectedImage(File(image.path));
      }
    } catch (e) {
      if (e.toString().contains('User cancelled')) {
        // المستخدم ألغى العملية - لا نعرض خطأ
        return;
      }
      _showError('خطأ في اختيار الصورة: $e');
    }
  }

  /// Create temporary file from bytes for web upload
  Future<File?> _createTempFileFromBytes(
      List<int> bytes, String fileName) async {
    try {
      if (kDebugMode) {
        print('📁 Creating temporary file for web upload');
        print('   - File name: $fileName');
        print('   - Bytes length: ${bytes.length}');
      }

      // For web, we can't create actual files, so we'll handle this differently
      if (kIsWeb) {
        if (kDebugMode) {
          print('🌐 Web platform detected - skipping temp file creation');
        }
        return null;
      }

      // Create temporary directory for mobile/desktop
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');

      // Write bytes to temp file
      await tempFile.writeAsBytes(bytes);

      if (kDebugMode) {
        print('✅ Temporary file created');
        print('   - Temp path: ${tempFile.path}');
        print('   - File exists: ${await tempFile.exists()}');
        print('   - File size: ${await tempFile.length()} bytes');
      }

      return tempFile;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating temporary file: $e');
      }
      return null;
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await UnifiedImagePicker.takePhoto(
        maxWidth: 1920.0,
        maxHeight: 1080.0,
        imageQuality: 85,
      );

      if (image != null) {
        await _processSelectedImage(File(image.path));
      }
    } catch (e) {
      _showError('خطأ في التقاط الصورة: $e');
    }
  }

  Future<void> _processSelectedImage(File imageFile) async {
    await _processSelectedImageInternal(imageFile);
  }

  Future<void> _processSelectedImageInternal(File? imageFile,
      {String? fileName, List<int>? imageBytes}) async {
    // التحقق من صحة الملف - صيغ الصور المدعومة فقط
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];

    // استخراج امتداد الملف
    String extension;
    if (fileName != null) {
      extension = fileName.toLowerCase().substring(fileName.lastIndexOf('.'));
    } else if (imageFile != null) {
      final path = imageFile.path.toLowerCase();
      extension = path.substring(path.lastIndexOf('.'));
    } else {
      _showError('لم يتم تحديد اسم الملف');
      return;
    }

    // التحقق من نوع الملف
    if (!validExtensions.contains(extension)) {
      _showError(
          'نوع الملف غير مدعوم: $extension. يرجى اختيار صورة بصيغة: ${validExtensions.join(', ')}');
      return;
    }

    // التحقق من حجم الملف
    int fileSizeBytes;
    if (imageBytes != null) {
      fileSizeBytes = imageBytes.length;
    } else if (imageFile != null) {
      fileSizeBytes = imageFile.lengthSync();
    } else {
      _showError('لم يتم تحديد الملف');
      return;
    }

    final fileSizeMB = fileSizeBytes / (1024 * 1024);
    if (fileSizeMB > 10.0) {
      _showError('حجم الملف كبير جداً. الحد الأقصى 10 ميجابايت');
      return;
    }

    // التحقق من محتوى الملف (للويب)
    if (imageBytes != null) {
      // التحقق من أن الملف ليس HTML
      if (imageBytes.length >= 10) {
        final header = imageBytes.take(10).toList();
        if (header[0] == 0x3c &&
            header[1] == 0x21 &&
            header[2] == 0x44 &&
            header[3] == 0x4f &&
            header[4] == 0x43 &&
            header[5] == 0x54 &&
            header[6] == 0x59 &&
            header[7] == 0x50 &&
            header[8] == 0x45) {
          _showError('هذا الملف ليس صورة صحيحة. يبدو أنه ملف HTML');
          return;
        }
      }
    }

    // عرض الصورة المحددة (بدون رفع فوري)
    setState(() {
      if (imageFile != null) {
        _selectedImage = imageFile;
        _selectedImageBytes = null;
        _selectedImageName = null;
        // مسح URL الصورة القديمة عند اختيار صورة جديدة
        _imageUrl = null;
      } else if (imageBytes != null) {
        _selectedImageBytes = imageBytes;
        _selectedImageName = fileName;
        _selectedImage = null;
        // مسح URL الصورة القديمة عند اختيار صورة جديدة
        _imageUrl = null;
      }
      _errorMessage = null;
      _isUploading = false;
    });

    // إخطار الوالد بالصورة المحددة
    if (imageFile != null) {
      // للموبايل/ديسكتوب: إرسال مسار الملف الكامل
      widget.onImageSelected(imageFile.path);
      if (kDebugMode) {
        print('📱 Mobile/Desktop: Sending file path: ${imageFile.path}');
      }
    } else if (imageBytes != null) {
      // للويب: رفع الصورة فوراً وإرسال URL
      if (kIsWeb) {
        try {
          if (kDebugMode) {
            print('🌐 Web: Uploading image immediately...');
            print('🌐 File name: $fileName');
            print('🌐 Bytes length: ${imageBytes.length}');
          }

          final imageUrl = await _uploadImageFromBytes(imageBytes, fileName!);
          if (imageUrl.isNotEmpty) {
            widget.onImageSelected(imageUrl);
            if (kDebugMode) {
              print('✅ Web: Image uploaded successfully');
              print('🔗 Image URL: $imageUrl');
            }
          } else {
            _showError('فشل في رفع الصورة');
            if (kDebugMode) {
              print('❌ Web: Image upload failed');
            }
          }
        } catch (e) {
          _showError('فشل في رفع الصورة: $e');
          if (kDebugMode) {
            print('❌ Web: Image upload error: $e');
          }
        }
      } else {
        // للويب: إرسال اسم الملف فقط (سيتم رفعه عند الحفظ)
        widget.onImageSelected(fileName ?? 'web_image');
        if (kDebugMode) {
          print('🌐 Web: Image selected, will upload when saving');
          print('🌐 File name: $fileName');
          print('🌐 Bytes length: ${imageBytes.length}');
        }
      }
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    widget.onError(message);
  }

  // الحصول على URL الصورة الحالية
  String? get currentImageUrl => _imageUrl;

  // التحقق من وجود صورة
  bool get hasImage => _imageUrl != null && _imageUrl!.isNotEmpty;

  // التحقق من وجود صورة محددة (جديدة)
  bool get _hasSelectedImage =>
      _selectedImage != null || _selectedImageBytes != null;

  // مسح الصورة
  void clearImage() {
    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
      _selectedImageName = null;
      _errorMessage = null;
    });
  }

  // مسح الصورة المحددة (الجديدة)
  void _clearSelectedImage() {
    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
      _selectedImageName = null;
      // إعادة تعيين URL الصورة الأصلية
      _imageUrl = widget.initialImageUrl;
      _errorMessage = null;
    });

    // إخطار الوالد بإلغاء الصورة المحددة
    if (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty) {
      widget.onImageSelected(widget.initialImageUrl!);
    } else {
      widget.onImageSelected('');
    }

    if (kDebugMode) {
      print('🗑️ Selected image cleared');
      print('🔄 Restored original image URL: ${widget.initialImageUrl}');
    }
  }

  /// Upload image using the simple method (same as user's code)
  Future<String> _uploadImage(String path, XFile image) async {
    try {
      // إنشاء مجلد جديد للصور: category_images/اسم_الملف
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${timestamp}_${image.name}';
      final fullImagePath = 'category_images/$fileName';

      if (kDebugMode) {
        print('📁 Uploading to new folder: category_images');
        print('📁 File name: $fileName');
        print('📁 Full path: $fullImagePath');
      }

      final ref = FirebaseStorage.instance.ref().child(fullImagePath);

      // تحديد نوع الملف الصحيح للصور
      final metadata = SettableMetadata(
        contentType: _getContentType(image.name),
        cacheControl: 'public, max-age=31536000', // cache لمدة سنة
      );

      await ref.putFile(File(image.path), metadata);
      final url = await ref.getDownloadURL();

      if (kDebugMode) {
        print('✅ Image uploaded successfully');
        print('🔗 Download URL obtained: $url');
        print('🔗 Full image path saved: $fullImagePath');
      }

      return url;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error during upload: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print('❌ General error during upload: $e');
      }
      throw 'Error in upload file';
    }
  }

  /// تحديد نوع الملف الصحيح للصور
  String _getContentType(String fileName) {
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
        return 'image/jpeg'; // افتراضي
    }
  }

  /// Upload image from bytes (for web)
  Future<String> _uploadImageFromBytes(List<int> bytes, String fileName) async {
    try {
      // إنشاء مجلد جديد للصور: category_images/اسم_الملف
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final finalFileName = '${timestamp}_$fileName';
      final fullImagePath = 'category_images/$finalFileName';

      if (kDebugMode) {
        print('📁 Uploading bytes to new folder: category_images');
        print('📁 File name: $finalFileName');
        print('📁 Full path: $fullImagePath');
      }

      final ref = FirebaseStorage.instance.ref().child(fullImagePath);

      // تحديد نوع الملف الصحيح للصور
      final metadata = SettableMetadata(
        contentType: _getContentType(fileName),
        cacheControl: 'public, max-age=31536000', // cache لمدة سنة
      );

      // رفع الـ bytes مباشرة مع metadata
      await ref.putData(Uint8List.fromList(bytes), metadata);
      final url = await ref.getDownloadURL();

      if (kDebugMode) {
        print('✅ Image uploaded successfully from bytes');
        print('🔗 Download URL obtained: $url');
        print('🔗 Full image path saved: $fullImagePath');
      }

      return url;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error during bytes upload: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print('❌ General error during bytes upload: $e');
      }
      throw 'Error in upload bytes';
    }
  }

  // التحقق من وجود صورة جديدة
  bool get hasNewImage => _selectedImage != null || _selectedImageBytes != null;

  // الحصول على معلومات الصورة المحددة
  Map<String, dynamic>? get selectedImageInfo {
    if (_selectedImage != null) {
      return {
        'type': 'file',
        'file': _selectedImage,
        'path': _selectedImage!.path,
      };
    } else if (_selectedImageBytes != null) {
      return {
        'type': 'bytes',
        'bytes': _selectedImageBytes,
        'name': _selectedImageName,
      };
    }
    return null;
  }

  /// Public method to upload image when saving
  Future<String?> uploadImageWhenSaving() async {
    try {
      if (kDebugMode) {
        print('🔄 Starting image upload process...');
        print('📊 Selected image state:');
        print('   - _selectedImage: ${_selectedImage?.path}');
        print('   - _selectedImageBytes: ${_selectedImageBytes?.length} bytes');
        print('   - _selectedImageName: $_selectedImageName');
      }

      // Check if we have an image to upload
      if (_selectedImage == null && _selectedImageBytes == null) {
        if (kDebugMode) {
          print('⚠️ No image selected for upload');
        }
        return null;
      }

      if (kDebugMode) {
        print('📤 Starting image upload...');
      }

      String? imageUrl;

      if (_selectedImage != null) {
        // For mobile/desktop - use File
        if (kDebugMode) {
          print('📱 Mobile/Desktop upload using File');
          print('   - File path: ${_selectedImage!.path}');
        }

        // Create XFile from File for compatibility
        final xFile = XFile(_selectedImage!.path);
        imageUrl = await _uploadImage('category_images', xFile);

        if (kDebugMode) {
          print('✅ Mobile/Desktop upload completed');
          print('🔗 Image URL: $imageUrl');
        }
      } else if (_selectedImageBytes != null && _selectedImageName != null) {
        // For web - handle bytes directly
        if (kDebugMode) {
          print('🌐 Web upload using bytes');
          print('   - File name: $_selectedImageName');
          print('   - Bytes length: ${_selectedImageBytes!.length}');
        }

        // For web, upload bytes directly
        if (kIsWeb) {
          imageUrl = await _uploadImageFromBytes(
              _selectedImageBytes!, _selectedImageName!);

          if (kDebugMode) {
            print('✅ Web upload completed using bytes');
            print('🔗 Image URL: $imageUrl');
          }
        } else {
          // For mobile/desktop, create temporary file
          final tempFile = await _createTempFileFromBytes(
              _selectedImageBytes!, _selectedImageName!);
          if (tempFile != null) {
            final xFile = XFile(tempFile.path);
            imageUrl = await _uploadImage('category_images', xFile);

            if (kDebugMode) {
              print('✅ Mobile/Desktop upload completed');
              print('🔗 Image URL: $imageUrl');
            }

            // Clean up temp file
            await tempFile.delete();
          }
        }
      }

      if (kDebugMode) {
        print('🔄 Resetting local state...');
      }

      // Reset local state
      _selectedImage = null;
      _selectedImageBytes = null;
      _selectedImageName = null;

      if (kDebugMode) {
        print('✅ Image upload process completed successfully');
        print('🔗 Final image URL: $imageUrl');
      }

      return imageUrl;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error during image upload: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }

      // Reset local state on error
      _selectedImage = null;
      _selectedImageBytes = null;
      _selectedImageName = null;

      return null;
    }
  }

  /// Public method to upload image from widget (for external access)
  Future<String?> uploadImage() async {
    return uploadImageWhenSaving();
  }

  /// Upload selected image when saving (for web)
  Future<String?> uploadSelectedImageWhenSaving() async {
    try {
      if (kDebugMode) {
        print('🔄 Starting image upload for saving...');
        print('📊 Selected image state:');
        print('   - _selectedImage: ${_selectedImage?.path}');
        print('   - _selectedImageBytes: ${_selectedImageBytes?.length} bytes');
        print('   - _selectedImageName: $_selectedImageName');
      }

      // Check if we have an image to upload
      if (_selectedImage == null && _selectedImageBytes == null) {
        if (kDebugMode) {
          print('⚠️ No image selected for upload');
        }
        return null;
      }

      if (kDebugMode) {
        print('📤 Starting image upload...');
      }

      String? imageUrl;

      if (_selectedImage != null) {
        // For mobile/desktop - use File
        if (kDebugMode) {
          print('📱 Mobile/Desktop upload using File');
          print('   - File path: ${_selectedImage!.path}');
        }

        // Create XFile from File for compatibility
        final xFile = XFile(_selectedImage!.path);
        imageUrl = await _uploadImage('category_images', xFile);

        if (kDebugMode) {
          print('✅ Mobile/Desktop upload completed');
          print('🔗 Image URL: $imageUrl');
        }
      } else if (_selectedImageBytes != null && _selectedImageName != null) {
        // For web - handle bytes directly
        if (kDebugMode) {
          print('🌐 Web upload using bytes');
          print('   - File name: $_selectedImageName');
          print('   - Bytes length: ${_selectedImageBytes!.length}');
        }

        // For web, upload bytes directly
        if (kIsWeb) {
          imageUrl = await _uploadImageFromBytes(
              _selectedImageBytes!, _selectedImageName!);

          if (kDebugMode) {
            print('✅ Web upload completed using bytes');
            print('🔗 Image URL: $imageUrl');
          }
        } else {
          // For mobile/desktop, create temporary file
          final tempFile = await _createTempFileFromBytes(
              _selectedImageBytes!, _selectedImageName!);
          if (tempFile != null) {
            final xFile = XFile(tempFile.path);
            imageUrl = await _uploadImage('category_images', xFile);

            if (kDebugMode) {
              print('✅ Mobile/Desktop upload completed');
              print('🔗 Image URL: $imageUrl');
            }

            // Clean up temp file
            await tempFile.delete();
          }
        }
      }

      if (kDebugMode) {
        print('🔄 Resetting local state...');
      }

      // Reset local state
      _selectedImage = null;
      _selectedImageBytes = null;
      _selectedImageName = null;

      if (kDebugMode) {
        print('✅ Image upload process completed successfully');
        print('🔗 Final image URL: $imageUrl');
      }

      return imageUrl;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error during image upload: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }

      // Reset local state on error
      _selectedImage = null;
      _selectedImageBytes = null;
      _selectedImageName = null;

      return null;
    }
  }
}

class MultiImagePickerWidget extends StatefulWidget {
  final List<String> initialImages;
  final Function(List<String> images) onImagesSelected;
  final Function(String error) onError;
  final double? width;
  final double? height;
  final String? label;
  final int maxImages;

  const MultiImagePickerWidget({
    super.key,
    this.initialImages = const [],
    required this.onImagesSelected,
    required this.onError,
    this.width,
    this.height,
    this.label,
    this.maxImages = 10,
  });

  @override
  State<MultiImagePickerWidget> createState() => _MultiImagePickerWidgetState();
}

class _MultiImagePickerWidgetState extends State<MultiImagePickerWidget> {
  List<String> _selectedImages = [];
  List<String> _uploadedImages = [];
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedImages = List.from(widget.initialImages);
    _uploadedImages = List.from(widget.initialImages);
  }

  @override
  void didUpdateWidget(MultiImagePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local state when initialImages change
    if (oldWidget.initialImages != widget.initialImages) {
      setState(() {
        _selectedImages = List.from(widget.initialImages);
        _uploadedImages = List.from(widget.initialImages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              color: isDark ? Colors.white : Color(0xFF111111),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Images Grid Display
        if (_uploadedImages.isNotEmpty) ...[
          Container(
            width: widget.width ?? double.infinity,
            constraints: BoxConstraints(
              minHeight: widget.height ?? 200,
            ),
            decoration: BoxDecoration(
              color: isDark ? Colors.black12 : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الصور المحددة (${_uploadedImages.length}/${widget.maxImages})',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_uploadedImages.length > 1)
                        TextButton.icon(
                          onPressed: _reorderImages,
                          icon: const Icon(Icons.swap_vert, size: 16),
                          label: const Text('إعادة ترتيب'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: _uploadedImages.length,
                    itemBuilder: (context, index) {
                      return _buildImageItem(index, isDark);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Action Buttons
        Row(
          children: [
            // Pick Multiple Images Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    _isUploading || _uploadedImages.length >= widget.maxImages
                        ? null
                        : _pickMultipleImages,
                icon: const Icon(Icons.photo_library, size: 20),
                label: Text(
                    'اختيار صور (${_uploadedImages.length}/${widget.maxImages})'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Camera Button (only show on mobile)
            if (!kIsWeb) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      _isUploading || _uploadedImages.length >= widget.maxImages
                          ? null
                          : _takePhoto,
                  icon: const Icon(Icons.camera_alt, size: 20),
                  label: const Text('التقاط صورة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),

        // Clear All Images Button
        if (_uploadedImages.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isUploading ? null : _clearAllImages,
              icon: const Icon(Icons.clear_all, size: 20),
              label: const Text('مسح جميع الصور'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],

        // Upload Progress
        if (_isUploading) ...[
          const SizedBox(height: 16),
          GetBuilder<CategoryController>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'جاري رفع الصور...',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: controller.imageUploadProgress,
                    backgroundColor:
                        isDark ? Colors.black : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? TColors.primary : Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(controller.imageUploadProgress * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
        ],

        // Error Message
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageItem(int index, bool isDark) {
    final imageUrl = _uploadedImages[index];
    final isMainImage = index == 0;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isMainImage
                  ? Colors.blue
                  : (isDark ? Colors.white24 : Colors.grey.shade300),
              width: isMainImage ? 2 : 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImageWidget(imageUrl, isDark),
          ),
        ),

        // Main Image Badge
        if (isMainImage)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'رئيسية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Remove Image Button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ),

        // Reorder Handle
        if (_uploadedImages.length > 1)
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.drag_handle,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> images = await UnifiedImagePicker.pickMultipleImages(
        maxWidth: 1920.0,
        maxHeight: 1080.0,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        final remainingSlots = widget.maxImages - _uploadedImages.length;
        final imagesToProcess = images.take(remainingSlots).toList();

        if (imagesToProcess.isNotEmpty) {
          await _processAndUploadImages(imagesToProcess);
        } else {
          _showError('تم الوصول للحد الأقصى من الصور');
        }
      }
    } catch (e) {
      _showError('فشل في اختيار الصور: ${e.toString()}');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await UnifiedImagePicker.takePhoto(
        maxWidth: 1920.0,
        maxHeight: 1080.0,
        imageQuality: 85,
      );

      if (image != null && _uploadedImages.length < widget.maxImages) {
        await _processAndUploadImages([image]);
      } else if (_uploadedImages.length >= widget.maxImages) {
        _showError('تم الوصول للحد الأقصى من الصور');
      }
    } catch (e) {
      _showError('فشل في التقاط الصورة: ${e.toString()}');
    }
  }

  Future<void> _processAndUploadImages(List<XFile> images) async {
    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final categoryController = Get.find<CategoryController>();

      for (final image in images) {
        if (_uploadedImages.length >= widget.maxImages) break;

        try {
          final imageUrl = await _uploadImage(image, categoryController);
          if (imageUrl.isNotEmpty) {
            setState(() {
              _uploadedImages.add(imageUrl);
              _selectedImages.add(imageUrl);
            });
          }
        } catch (e) {
          _showError('فشل في رفع الصورة: ${e.toString()}');
        }
      }

      // Notify parent about the updated images
      if (_selectedImages.isNotEmpty) {
        widget.onImagesSelected(_selectedImages);
      }
    } catch (e) {
      _showError('فشل في معالجة الصور: ${e.toString()}');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<String> _uploadImage(
      XFile image, CategoryController controller) async {
    try {
      if (kIsWeb) {
        // Web implementation
        final bytes = await image.readAsBytes();

        // Simulate upload for now - you'll need to implement actual Firebase upload
        await Future.delayed(const Duration(seconds: 1));

        // For web, create a data URL from the image bytes for immediate display
        final base64String = base64Encode(bytes);
        final mimeType = _getMimeType(image.name);
        return 'data:$mimeType;base64,$base64String';
      } else {
        // Mobile implementation

        // Simulate upload for now - you'll need to implement actual Firebase upload
        await Future.delayed(const Duration(seconds: 1));

        // Return the local file path for now - replace with actual Firebase Storage URL
        return image.path;
      }
    } catch (e) {
      throw Exception('فشل في رفع الصورة: ${e.toString()}');
    }
  }

  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
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
      default:
        return 'image/jpeg';
    }
  }

  void _removeImage(int index) {
    if (index >= 0 && index < _uploadedImages.length) {
      setState(() {
        _uploadedImages.removeAt(index);
        _selectedImages.removeAt(index);
      });
      widget.onImagesSelected(_selectedImages);
    }
  }

  void _clearAllImages() {
    setState(() {
      _uploadedImages.clear();
      _selectedImages.clear();
    });
    widget.onImagesSelected(_selectedImages);
  }

  void _reorderImages() {
    // Show reorder dialog
    showDialog(
      context: context,
      builder: (context) => _buildReorderDialog(),
    );
  }

  Widget _buildReorderDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1a1a2e) : Colors.white,
      title: Text(
        'إعادة ترتيب الصور',
        style: TextStyle(
          color: isDark ? Colors.white : Color(0xFF111111),
        ),
      ),
      content: SizedBox(
        width: 300,
        height: 400,
        child: ReorderableListView.builder(
          itemCount: _uploadedImages.length,
          itemBuilder: (context, index) {
            final imageUrl = _uploadedImages[index];
            return Container(
              key: ValueKey('reorder_${imageUrl}_$index'),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.black12 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: index == 0 ? TColors.primary : Colors.transparent,
                  width: index == 0 ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.drag_handle,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'صورة ${index + 1}${index == 0 ? ' (رئيسية)' : ''}',
                      style: TextStyle(
                        color: isDark ? Colors.white : Color(0xFF111111),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = _uploadedImages.removeAt(oldIndex);
              _uploadedImages.insert(newIndex, item);

              final selectedItem = _selectedImages.removeAt(oldIndex);
              _selectedImages.insert(newIndex, selectedItem);
            });
            widget.onImagesSelected(_selectedImages);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'إغلاق',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    widget.onError(message);
  }

  Widget _buildImageWidget(String imageUrl, bool isDark) {
    if (imageUrl.startsWith('data:')) {
      // Handle data URLs (base64 encoded images)
      return Image.memory(
        base64Decode(imageUrl.split(',')[1]),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: isDark ? Colors.black26 : Colors.grey.shade200,
            child: Icon(
              Icons.error,
              color: isDark ? Colors.white54 : Colors.grey.shade600,
              size: 24,
            ),
          );
        },
      );
    } else if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: isDark ? Colors.black26 : Colors.grey.shade200,
            child: Icon(
              Icons.error,
              color: isDark ? Colors.white54 : Colors.grey.shade600,
              size: 24,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: isDark ? Colors.black26 : Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? Colors.white54 : Colors.grey.shade600,
                ),
              ),
            ),
          );
        },
      );
    } else {
      try {
        return Image.file(
          File(imageUrl),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: isDark ? Colors.black26 : Colors.grey.shade200,
              child: Icon(
                Icons.error,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
                size: 24,
              ),
            );
          },
        );
      } catch (e) {
        return Container(
          color: isDark ? Colors.black26 : Colors.grey.shade200,
          child: Icon(
            Icons.error,
            color: isDark ? Colors.white54 : Colors.grey.shade600,
            size: 24,
          ),
        );
      }
    }
  }
}
