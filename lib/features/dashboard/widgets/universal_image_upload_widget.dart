import 'dart:io';
import 'dart:convert';

import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brother_admin_panel/utils/upload/enhanced_image_upload_service.dart';
import 'package:brother_admin_panel/utils/image/image_crop_service.dart';
import 'package:brother_admin_panel/utils/image/unified_image_picker.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';

/// ويدجت شامل لرفع الصور قابل للإعادة الاستخدام في جميع أنحاء التطبيق
/// يدعم: صورة واحدة، عدة صور، رفع فوري، معاينة، validation
class UniversalImageUploadWidget extends StatefulWidget {
  /// نوع الرفع: صورة واحدة أو عدة صور
  final UploadType uploadType;

  /// مسار المجلد في Firebase Storage
  final String folderPath;

  /// الصور الأولية (للتعديل)
  final List<String> initialImages;

  /// الحد الأقصى للصور (للرفع المتعدد)
  final int maxImages;

  /// عرض الحاوية
  final double? width;

  /// ارتفاع الحاوية
  final double? height;

  /// تسمية الحقل
  final String? label;

  /// وصف الحقل
  final String? hint;

  /// دالة الاستدعاء عند نجاح الرفع
  final Function(List<String> imageUrls) onImagesUploaded;

  /// دالة الاستدعاء عند حدوث خطأ
  final Function(String error) onError;

  /// دالة الاستدعاء عند تغيير التقدم
  final Function(double progress)? onProgressChanged;

  /// هل يجب رفع الصور فوراً عند الاختيار
  final bool autoUpload;

  /// هل يجب عرض معاينة الصور
  final bool showPreview;

  /// هل يجب عرض أزرار الحذف
  final bool showDeleteButtons;

  /// هل يجب عرض أزرار إعادة الترتيب
  final bool showReorderButtons;

  /// تخصيص شكل الحاوية
  final BoxDecoration? containerDecoration;

  /// تخصيص شكل الأزرار
  final ButtonStyle? buttonStyle;

  /// معاملات الاقتصاص التلقائي
  final CropParameters? cropParameters;

  const UniversalImageUploadWidget({
    super.key,
    required this.uploadType,
    required this.folderPath,
    required this.onImagesUploaded,
    required this.onError,
    this.initialImages = const [],
    this.maxImages = 10,
    this.width,
    this.height,
    this.label,
    this.hint,
    this.onProgressChanged,
    this.autoUpload = true,
    this.showPreview = true,
    this.showDeleteButtons = true,
    this.showReorderButtons = true,
    this.containerDecoration,
    this.buttonStyle,
    this.cropParameters,
  });

  @override
  State<UniversalImageUploadWidget> createState() =>
      _UniversalImageUploadWidgetState();
}

class _UniversalImageUploadWidgetState
    extends State<UniversalImageUploadWidget> {
  final ImageUploadController _uploadController =
      Get.put(ImageUploadController());

  List<String> _currentImages = [];
  List<dynamic> _selectedFiles = []; // File أو List<int>

  @override
  void initState() {
    super.initState();
    _currentImages = List.from(widget.initialImages);
  }

  @override
  void didUpdateWidget(UniversalImageUploadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialImages != widget.initialImages) {
      setState(() {
        _currentImages = List.from(widget.initialImages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // التسمية
            if (widget.label != null) ...[
              Text(
                widget.label!,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // الوصف
            if (widget.hint != null) ...[
              Text(
                widget.hint!,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
            ],

            // حاوية الصور
            _buildImageContainer(isDark),

            const SizedBox(height: 16),

            // أزرار التحكم
            _buildControlButtons(isDark),

            // شريط التقدم
            if (_uploadController.isUploading) ...[
              const SizedBox(height: 16),
              _buildProgressIndicator(isDark),
            ],

            // رسائل الخطأ
            if (_uploadController.errors.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildErrorMessages(isDark),
            ],
          ],
        );
      },
    );
  }

  Widget _buildImageContainer(bool isDark) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 200,
      decoration: widget.containerDecoration ??
          BoxDecoration(
            color: isDark ? Colors.black12 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
          ),
      child: _currentImages.isEmpty && _selectedFiles.isEmpty
          ? _buildEmptyState(isDark)
          : _buildImageGrid(isDark),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.uploadType == UploadType.single
                ? Icons.image_outlined
                : Icons.photo_library_outlined,
            size: 48,
            color: isDark ? Colors.white54 : Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            widget.uploadType == UploadType.single
                ? 'لا توجد صورة'
                : 'لا توجد صور',
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'اضغط لاختيار ${widget.uploadType == UploadType.single ? "صورة" : "صور"}',
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(bool isDark) {
    final allImages = [
      ..._currentImages,
      ..._selectedFiles.map(_getImagePreview)
    ];

    if (widget.uploadType == UploadType.single) {
      return _buildSingleImagePreview(allImages.first, isDark);
    } else {
      return _buildMultipleImagesGrid(allImages, isDark);
    }
  }

  Widget _buildSingleImagePreview(dynamic image, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          _buildImageWidget(image, isDark),
          if (widget.showDeleteButtons)
            Positioned(
              top: 8,
              right: 8,
              child: _buildDeleteButton(image, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildMultipleImagesGrid(List<dynamic> images, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
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
                  child: _buildImageWidget(image, isDark),
                ),
              ),

              // شارة الصورة الرئيسية
              if (isMainImage)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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

              // زر الحذف
              if (widget.showDeleteButtons)
                Positioned(
                  top: 4,
                  right: 4,
                  child: _buildDeleteButton(image, isDark),
                ),

              // مقبض إعادة الترتيب
              if (widget.showReorderButtons && images.length > 1)
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
        },
      ),
    );
  }

  Widget _buildImageWidget(dynamic image, bool isDark) {
    if (image is String) {
      // URL صورة
      if (image.startsWith('http')) {
        return Image.network(
          image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorWidget(isDark),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildLoadingWidget(isDark);
          },
        );
      } else if (image.startsWith('data:image')) {
        // Base64 image
        try {
          final base64String = image.split(',')[1];
          final bytes = base64Decode(base64String);
          return Image.memory(
            bytes,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                _buildErrorWidget(isDark),
          );
        } catch (e) {
          return _buildErrorWidget(isDark);
        }
      }
    } else if (image is File) {
      // ملف محلي
      return Image.file(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(isDark),
      );
    } else if (image is XFile) {
      // XFile للويب
      return FutureBuilder<Uint8List>(
        future: image.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  _buildErrorWidget(isDark),
            );
          } else if (snapshot.hasError) {
            return _buildErrorWidget(isDark);
          } else {
            return _buildLoadingWidget(isDark);
          }
        },
      );
    } else if (image is List<int>) {
      // bytes للويب
      return Image.memory(
        Uint8List.fromList(image),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(isDark),
      );
    }

    return _buildErrorWidget(isDark);
  }

  Widget _buildErrorWidget(bool isDark) {
    return Container(
      color: isDark ? Colors.black26 : Colors.grey.shade200,
      child: Icon(
        Icons.error,
        color: isDark ? Colors.white54 : Colors.grey.shade600,
        size: 24,
      ),
    );
  }

  Widget _buildLoadingWidget(bool isDark) {
    return Container(
      color: isDark ? Colors.black26 : Colors.grey.shade200,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            isDark ? Colors.white54 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(dynamic image, bool isDark) {
    return GestureDetector(
      onTap: () => _deleteImage(image),
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
    );
  }

  Widget _buildControlButtons(bool isDark) {
    return Row(
      children: [
        // زر اختيار من المعرض
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _uploadController.isUploading ? null : _pickFromGallery,
            icon: const Icon(Icons.photo_library, size: 20),
            label: Text(
              widget.uploadType == UploadType.single
                  ? 'اختيار صورة'
                  : 'اختيار صور',
            ),
            style: widget.buttonStyle ??
                ElevatedButton.styleFrom(
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

        // زر الكاميرا (للموبايل فقط)
        if (!kIsWeb) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _uploadController.isUploading ? null : _takePhoto,
              icon: const Icon(Icons.camera_alt, size: 20),
              label: const Text('التقاط صورة'),
              style: widget.buttonStyle ??
                  ElevatedButton.styleFrom(
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
    );
  }

  Widget _buildProgressIndicator(bool isDark) {
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
          value: _uploadController.uploadProgress,
          backgroundColor: isDark ? Colors.black : Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(
            isDark ? TColors.primary : Colors.blue.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(_uploadController.uploadProgress * 100).toStringAsFixed(1)}%',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessages(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _uploadController.errors
            .map((error) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.red.shade600, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      if (widget.uploadType == UploadType.single) {
        final XFile? image = await _pickSingleImage();
        if (image != null) {
          await _processSelectedImage(image);
        }
      } else {
        final List<XFile> images = await _pickMultipleImages();
        if (images.isNotEmpty) {
          final remainingSlots =
              widget.maxImages - _currentImages.length - _selectedFiles.length;
          final imagesToProcess = images.take(remainingSlots).toList();

          if (imagesToProcess.isNotEmpty) {
            await _processSelectedImages(imagesToProcess);
          } else {
            widget.onError('تم الوصول للحد الأقصى من الصور');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error picking images from gallery: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }
      widget.onError('فشل في اختيار الصور: $e');
    }
  }

  /// Pick single image with fallback for namespace issues
  Future<XFile?> _pickSingleImage() async {
    try {
      if (kDebugMode) {
        print('🌐 Using unified image picker...');
      }
      return await UnifiedImagePicker.pickSingleImage(
        maxWidth: 1920.0,
        maxHeight: 1080.0,
        imageQuality: 85,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unified image picker failed: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }
      rethrow;
    }
  }

  /// Pick multiple images with fallback for namespace issues
  Future<List<XFile>> _pickMultipleImages() async {
    try {
      if (kDebugMode) {
        print('🌐 Using unified multi-image picker...');
      }
      return await UnifiedImagePicker.pickMultipleImages(
        maxWidth: 1920.0,
        maxHeight: 1080.0,
        imageQuality: 85,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unified multi-image picker failed: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }
      rethrow;
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _pickImageFromCamera();
      if (image != null) {
        if (widget.uploadType == UploadType.single) {
          await _processSelectedImage(image);
        } else {
          if (_currentImages.length + _selectedFiles.length <
              widget.maxImages) {
            await _processSelectedImage(image);
          } else {
            widget.onError('تم الوصول للحد الأقصى من الصور');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error taking photo: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }
      widget.onError('فشل في التقاط الصورة: $e');
    }
  }

  /// Pick image from camera with fallback for namespace issues
  Future<XFile?> _pickImageFromCamera() async {
    try {
      if (kDebugMode) {
        print('📷 Using unified camera picker...');
      }
      return await UnifiedImagePicker.takePhoto(
        maxWidth: 1920.0,
        maxHeight: 1080.0,
        imageQuality: 85,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unified camera picker failed: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }
      rethrow;
    }
  }

  Future<void> _processSelectedImage(XFile image) async {
    // التحقق من صحة الملف
    if (!_isValidImageFile(image)) {
      widget.onError('نوع الملف غير مدعوم');
      return;
    }

    // التحقق من حجم الملف
    double fileSize;
    if (kIsWeb) {
      // للويب، نحصل على الحجم من XFile مباشرة
      final bytes = await image.readAsBytes();
      fileSize = bytes.length / (1024 * 1024); // تحويل إلى ميجابايت
    } else {
      // للموبايل، نستخدم File
      fileSize =
          await EnhancedImageUploadService.getFileSizeInMB(File(image.path));
    }

    if (fileSize > 10.0) {
      widget.onError('حجم الملف كبير جداً. الحد الأقصى 10 ميجابايت');
      return;
    }

    setState(() {
      if (kIsWeb) {
        // للويب، نحفظ XFile مباشرة
        _selectedFiles = [image];
      } else {
        // للموبايل، نحول إلى File
        _selectedFiles = [File(image.path)];
      }
    });

    if (widget.autoUpload) {
      await _uploadImages();
    }
  }

  Future<void> _processSelectedImages(List<XFile> images) async {
    final validImages = <dynamic>[]; // يمكن أن يكون File أو XFile

    for (final image in images) {
      // التحقق من صحة الملف
      if (!_isValidImageFile(image)) {
        widget.onError('نوع الملف غير مدعوم: ${image.name}');
        continue;
      }

      // التحقق من حجم الملف
      double fileSize;
      if (kIsWeb) {
        // للويب، نحصل على الحجم من XFile مباشرة
        final bytes = await image.readAsBytes();
        fileSize = bytes.length / (1024 * 1024); // تحويل إلى ميجابايت
      } else {
        // للموبايل، نستخدم File
        fileSize =
            await EnhancedImageUploadService.getFileSizeInMB(File(image.path));
      }

      if (fileSize > 10.0) {
        widget.onError('حجم الملف كبير جداً: ${image.name}');
        continue;
      }

      if (kIsWeb) {
        validImages.add(image); // XFile للويب
      } else {
        validImages.add(File(image.path)); // File للموبايل
      }
    }

    if (validImages.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(validImages);
      });

      if (widget.autoUpload) {
        await _uploadImages();
      }
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedFiles.isEmpty) return;

    try {
      List<String> uploadedUrls;

      if (widget.uploadType == UploadType.single) {
        final url = await _uploadController.uploadSingleImage(
          folderPath: widget.folderPath,
          imageData: _selectedFiles.first,
          cropParameters: widget.cropParameters,
        );

        if (url != null) {
          uploadedUrls = [url];
          setState(() {
            _currentImages = uploadedUrls;
            _selectedFiles.clear();
          });
          widget.onImagesUploaded(uploadedUrls);
        }
      } else {
        uploadedUrls = await _uploadController.uploadMultipleImages(
          folderPath: widget.folderPath,
          imagesData: _selectedFiles,
          cropParameters: widget.cropParameters,
        );

        if (uploadedUrls.isNotEmpty) {
          setState(() {
            _currentImages.addAll(uploadedUrls);
            _selectedFiles.clear();
          });
          widget.onImagesUploaded(_currentImages);
        }
      }
    } catch (e) {
      widget.onError('فشل في رفع الصور: $e');
    }
  }

  void _deleteImage(dynamic image) {
    setState(() {
      if (image is String) {
        _currentImages.remove(image);
      } else {
        _selectedFiles.remove(image);
      }
    });

    // إعادة إرسال القائمة المحدثة
    widget.onImagesUploaded(_currentImages);
  }

  String _getImagePreview(dynamic file) {
    if (file is File) {
      return file.path;
    } else if (file is XFile) {
      return file.path;
    } else if (file is List<int>) {
      return 'bytes_preview';
    }
    return '';
  }

  @override
  void dispose() {
    _uploadController.reset();
    super.dispose();
  }
}

/// أنواع الرفع
enum UploadType {
  single, // صورة واحدة
  multiple, // عدة صور
}

/// استخدام الويدجت في النماذج
class ImageUploadFormField extends StatelessWidget {
  final String folderPath;
  final List<String> initialImages;
  final Function(List<String> imageUrls) onChanged;
  final Function(String error) onError;
  final String? label;
  final String? hint;
  final UploadType uploadType;
  final int maxImages;
  final CropParameters? cropParameters;

  const ImageUploadFormField({
    super.key,
    required this.folderPath,
    required this.onChanged,
    required this.onError,
    this.initialImages = const [],
    this.label,
    this.hint,
    this.uploadType = UploadType.single,
    this.maxImages = 10,
    this.cropParameters,
  });

  @override
  Widget build(BuildContext context) {
    return UniversalImageUploadWidget(
      uploadType: uploadType,
      folderPath: folderPath,
      initialImages: initialImages,
      maxImages: maxImages,
      label: label,
      hint: hint,
      onImagesUploaded: onChanged,
      onError: onError,
      autoUpload: true,
      showPreview: true,
      showDeleteButtons: true,
      showReorderButtons: uploadType == UploadType.multiple,
      cropParameters: cropParameters,
    );
  }
}

/// التحقق من صحة ملف الصورة
bool _isValidImageFile(XFile image) {
  final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];

  final fileName = image.name.toLowerCase();
  final hasValidExtension = validExtensions.any(fileName.endsWith);

  if (kDebugMode) {
    print('🔍 Validating image file:');
    print('   - Name: ${image.name}');
    print('   - Path: ${image.path}');
    print('   - Valid extension: $hasValidExtension');
  }

  return hasValidExtension;
}
