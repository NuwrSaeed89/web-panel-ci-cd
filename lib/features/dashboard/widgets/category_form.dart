import 'dart:convert';
import 'dart:io';

import 'package:brother_admin_panel/data/models/category_model.dart';
import 'package:brother_admin_panel/services/category_image_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/foundation.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/category_controller.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/universal_image_upload_widget.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';
import 'package:brother_admin_panel/utils/image/image_crop_service.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryForm extends StatefulWidget {
  final CategoryModel? category;
  final bool isEditMode;

  const CategoryForm({
    super.key,
    this.category,
    required this.isEditMode,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _arabicNameController = TextEditingController();
  final _parentIdController = TextEditingController();
  bool _isFeature = false;
  bool _isRootCategory = false;
  List<dynamic> _categoryImages = [];
  String? _localImagePath;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.category != null) {
      _nameController.text = widget.category!.name;
      _arabicNameController.text = widget.category!.arabicName;
      _parentIdController.text = widget.category!.parentId;
      _isFeature = widget.category!.isFeature;
      _isRootCategory = widget.category!.parentId.isEmpty;
      if (widget.category!.image.isNotEmpty) {
        // تحقق إذا كان URL أم base64
        if (widget.category!.image.startsWith('http')) {
          _uploadedImageUrl = widget.category!.image;
          _categoryImages = [widget.category!.image];
        } else {
          // إذا كان base64، نحتفظ به مؤقتاً
          _localImagePath = widget.category!.image;
          _categoryImages = [widget.category!.image];
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _arabicNameController.dispose();
    _parentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;

        return Container(
          padding: ResponsiveHelper.getResponsivePadding(context),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1a1a2e) : const Color(0xFFf5f5f5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.grey.shade200,
            ),
          ),
          child: Form(
            key: _formKey,
            child: ResponsiveHelper.responsiveBuilder(
              context: context,
              mobile: _buildMobileForm(isDark),
              desktop: _buildDesktopForm(isDark),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileForm(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 32),
          _buildFormFields(isDark),
          const SizedBox(height: 32),
          _buildActionButtons(isDark),
          const SizedBox(height: 24), // مساحة إضافية في الأسفل
        ],
      ),
    );
  }

  Widget _buildDesktopForm(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 32),
          // تخطيط أفقي محسن مع مسافات متساوية
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العمود الأيسر
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildNameField(isDark),
                    const SizedBox(height: 24),
                    _buildArabicNameField(isDark),
                    const SizedBox(height: 24),
                    _buildFeatureToggle(isDark),
                  ],
                ),
              ),
              const SizedBox(width: 32), // مسافة أفقية ثابتة
              // العمود الأيمن
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImageField(isDark),
                    const SizedBox(height: 24),
                    _buildParentIdField(isDark),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 32),
          _buildActionButtons(isDark),
          const SizedBox(height: 24), // مساحة إضافية في الأسفل
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // توسيط العنوان
        children: [
          Icon(
            widget.isEditMode ? Icons.edit : Icons.add,
            color: Colors.blue,
            size: ResponsiveHelper.getResponsiveIconSize(context),
          ),
          const SizedBox(width: 16),
          Text(
            widget.isEditMode ? 'تعديل الفئة' : 'إضافة فئة جديدة',
            style: TTextStyles.heading3.copyWith(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildNameField(isDark),
        const SizedBox(height: 24), // مسافة ثابتة
        _buildArabicNameField(isDark),
        const SizedBox(height: 24), // مسافة ثابتة
        _buildImageUploadField(isDark),
        const SizedBox(height: 24), // مسافة ثابتة
        _buildParentIdField(isDark),
        const SizedBox(height: 24), // مسافة ثابتة
        _buildFeatureToggle(isDark),
      ],
    );
  }

  Widget _buildNameField(bool isDark) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Category Name (English)',
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: isDark ? Colors.white10 : Colors.grey.shade50,
      ),
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: ResponsiveHelper.getResponsiveFontSize(context),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Category name is required';
        }
        return null;
      },
    );
  }

  Widget _buildArabicNameField(bool isDark) {
    return TextFormField(
      controller: _arabicNameController,
      decoration: InputDecoration(
        labelText: 'اسم الفئة (العربية)',
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: isDark ? Colors.white10 : Colors.grey.shade50,
      ),
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: ResponsiveHelper.getResponsiveFontSize(context),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'اسم الفئة مطلوب';
        }
        return null;
      },
    );
  }

  Widget _buildImageUploadField(bool isDark) {
    return ImageUploadFormField(
      folderPath: 'categories',
      label: 'صورة الفئة',
      hint: 'سيتم اقتصاص الصورة تلقائياً إلى دائرة 300x300',
      initialImages: _categoryImages.cast<String>(),
      uploadType: UploadType.single,
      cropParameters: CropParameters.circular(
        size: 300,
        quality: 90,
        format: ImageFormat.png, // PNG للدعم الشفافية
      ),
      onChanged: (images) {
        setState(() {
          _categoryImages = images;
        });
      },
      onError: (error) {
        Get.snackbar(
          'خطأ',
          'فشل في رفع الصورة: $error',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  Widget _buildImageField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان الحقل
        Text(
          'صورة الفئة',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize:
                ResponsiveHelper.getResponsiveFontSize(context, mobile: 14),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),

        // عرض الصورة الحالية
        if (_categoryImages.isNotEmpty)
          Center(
            child: Container(
              width: 400,
              height: 400,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImageWidget(isDark),
                ),
              ),
            ),
          ),

        const SizedBox(height: 16),

        // زر اختيار الصورة مع اقتصاص
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: pickCategoryImage,
            icon: const Icon(Icons.crop_original),
            label: const Text(kIsWeb
                ? 'اختيار صورة الفئة من المعرض'
                : 'اختيار واقتصاص صورة الفئة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // عرض الصورة المختارة
        if (_localImagePath != null) ...[
          _buildImageWidget(isDark),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildImageWidget(bool isDark) {
    // عرض حالة الرفع
    if (_isUploading) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 3,
              ),
              SizedBox(height: 12),
              Text(
                'جاري الرفع...',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // عرض الصورة المرفوعة
    if (_uploadedImageUrl != null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'الصورة المرفوعة:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _buildImageDisplay(_uploadedImageUrl!, isDark),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _uploadedImageUrl = null;
                    _categoryImages = [];
                  });
                  Get.snackbar(
                    'تم الحذف',
                    'تم حذف الصورة بنجاح',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.delete),
                label: const Text('حذف الصورة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // عرض الصورة المحلية (base64) - للتوافق مع البيانات القديمة
    if (_localImagePath != null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'الصورة المحلية:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _buildImageDisplay(_localImagePath!, isDark),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _localImagePath = null;
                    _categoryImages = [];
                  });
                  Get.snackbar(
                    'تم الحذف',
                    'تم حذف الصورة بنجاح',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.delete),
                label: const Text('حذف الصورة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // لا توجد صورة
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 50,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            const Text(
              'لا توجد صورة',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء عرض الصورة مع دعم base64 و network URLs
  Widget _buildImageDisplay(String imageData, bool isDark) {
    if (imageData.startsWith('data:image')) {
      return _buildBase64Image(imageData, isDark);
    } else if (imageData.startsWith('http')) {
      return _buildNetworkImage(imageData, isDark);
    } else {
      return _buildFileImage(imageData, isDark);
    }
  }

  /// بناء صورة base64
  Widget _buildBase64Image(String base64Image, bool isDark) {
    try {
      final base64String = base64Image.split(',')[1];
      final bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        key: ValueKey('base64_${base64Image.hashCode}'),
        fit: BoxFit.cover,
        width: 200,
        height: 200,
        errorBuilder: (context, error, stackTrace) {
          if (kDebugMode) {
            print('❌ Error displaying base64 image: $error');
          }
          return _buildErrorImage(isDark);
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error decoding base64 image: $e');
      }
      return _buildErrorImage(isDark);
    }
  }

  /// بناء صورة من URL
  Widget _buildNetworkImage(String imageUrl, bool isDark) {
    return Image.network(
      imageUrl,
      key: ValueKey('network_${imageUrl.hashCode}'),
      fit: BoxFit.cover,
      width: 200,
      height: 200,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingImage(isDark);
      },
      errorBuilder: (context, error, stackTrace) {
        if (kDebugMode) {
          print('❌ Error loading network image: $error');
          print('❌ Image URL: $imageUrl');
        }
        return _buildErrorImage(isDark);
      },
    );
  }

  /// بناء صورة من ملف محلي
  Widget _buildFileImage(String imagePath, bool isDark) {
    return Image.file(
      File(imagePath),
      key: ValueKey('file_${imagePath.hashCode}'),
      fit: BoxFit.cover,
      width: 200,
      height: 200,
      errorBuilder: (context, error, stackTrace) {
        if (kDebugMode) {
          print('❌ Error loading file image: $error');
          print('❌ Image path: $imagePath');
        }
        return _buildErrorImage(isDark);
      },
    );
  }

  /// بناء صورة التحميل
  Widget _buildLoadingImage(bool isDark) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 2,
            ),
            SizedBox(height: 8),
            Text(
              'جاري التحميل...',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء صورة الخطأ
  Widget _buildErrorImage(bool isDark) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 50,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            const Text(
              'فشل في التحميل',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// وظيفة اختيار صورة الفئة مع رفع إلى Firebase Storage
  Future<void> pickCategoryImage() async {
    try {
      setState(() {
        _isUploading = true;
      });

      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickedFile != null) {
        if (kDebugMode) {
          print('📸 Image selected: ${pickedFile.name}');
        }

        String imageUrl;

        if (kIsWeb) {
          // للويب - رفع مباشر
          if (kDebugMode) {
            print('🌐 Web upload starting...');
          }

          imageUrl = await CategoryImageService.uploadCategoryImageFromXFile(
            xFile: pickedFile,
          );

          if (kDebugMode) {
            print('✅ Web upload completed: $imageUrl');
          }
        } else {
          // للموبايل/سطح المكتب - اقتصاص ثم رفع
          if (kDebugMode) {
            print('📱 Mobile/Desktop crop starting...');
          }

          final croppedFile = await ImageCropper().cropImage(
            sourcePath: pickedFile.path,
            compressFormat: ImageCompressFormat.jpg,
            compressQuality: 100,
            aspectRatio: const CropAspectRatio(ratioX: 600, ratioY: 600),
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Edit Category Image',
                toolbarColor: Colors.white,
                toolbarWidgetColor: Colors.black,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: true,
                hideBottomControls: true,
              ),
              IOSUiSettings(
                title: 'Edit Category Image',
              ),
            ],
          );

          if (croppedFile != null) {
            if (kDebugMode) {
              print('✂️ Image cropped, starting upload...');
            }

            // تحويل CroppedFile إلى XFile
            final xFile = XFile(croppedFile.path);
            imageUrl = await CategoryImageService.uploadCategoryImageFromXFile(
              xFile: xFile,
            );

            if (kDebugMode) {
              print('✅ Mobile/Desktop upload completed: $imageUrl');
            }
          } else {
            throw Exception('Image cropping was cancelled');
          }
        }

        setState(() {
          _uploadedImageUrl = imageUrl;
          _categoryImages = [imageUrl];
          _localImagePath = null; // مسح base64 القديم
        });

        Get.snackbar(
          'نجح',
          'تم اختيار ورفع الصورة بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error picking/uploading category image: $e');
      }

      Get.snackbar(
        'خطأ',
        'فشل في اختيار/رفع الصورة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Widget _buildParentIdField(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Root Category Checkbox
          Row(
            children: [
              Checkbox(
                value: _isRootCategory,
                onChanged: (value) {
                  setState(() {
                    _isRootCategory = value ?? false;
                    if (_isRootCategory) {
                      _parentIdController.clear();
                      // إعادة بناء القائمة للتأكد من صحة القيم
                    }
                  });
                },
                activeColor: Colors.blue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'فئة رئيسية (Root Category)',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Parent Category Dropdown
          if (!_isRootCategory) ...[
            Text(
              'الفئة الأم (اختياري)',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize:
                    ResponsiveHelper.getResponsiveFontSize(context, mobile: 14),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                value: _parentIdController.text.isEmpty
                    ? null
                    : _getValidDropdownValue(_parentIdController.text),
                onChanged: (String? newValue) {
                  setState(() {
                    _parentIdController.text = newValue ?? '';
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.grey.shade50,
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: isDark ? Colors.white54 : Colors.grey.shade400,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context),
                ),
                dropdownColor: isDark ? Colors.grey.shade900 : Colors.white,
                items: _buildDropdownItems(isDark),
                validator: (value) {
                  // لا يوجد تحقق مطلوب للفئة الأم
                  return null;
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureToggle(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Switch(
            value: _isFeature,
            onChanged: (value) {
              setState(() {
                _isFeature = value;
              });
            },
            activeColor: Colors.blue,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'فئة مميزة (Featured Category)',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: ResponsiveHelper.responsiveBuilder(
        context: context,
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSaveButton(isDark),
            const SizedBox(height: 16),
            _buildCancelButton(isDark),
          ],
        ),
        desktop: Row(
          mainAxisAlignment: MainAxisAlignment.center, // توسيط الأزرار
          children: [
            SizedBox(
              width: 200, // عرض ثابت للأزرار
              child: _buildCancelButton(isDark),
            ),
            const SizedBox(width: 24),
            SizedBox(
              width: 200, // عرض ثابت للأزرار
              child: _buildSaveButton(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isDark) {
    return SizedBox(
      height: ResponsiveHelper.getResponsiveButtonHeight(context),
      child: ElevatedButton(
        onPressed: _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: GetBuilder<CategoryController>(
          builder: (controller) {
            if (controller.isLoading) {
              return const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }
            return Text(
              widget.isEditMode ? 'Update Category' : 'Create Category',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context),
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCancelButton(bool isDark) {
    return SizedBox(
      height: ResponsiveHelper.getResponsiveButtonHeight(context),
      child: OutlinedButton(
        onPressed: () {
          final controller = Get.find<CategoryController>();
          controller.hideForm();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.white : Colors.black87,
          side: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey.shade400,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    try {
      // Validate form
      if (!_formKey.currentState!.validate()) {
        return;
      }

      // الحصول على URL الصورة
      String imageUrl = '';

      // أولوية للصورة المرفوعة إلى Firebase Storage
      if (_uploadedImageUrl != null) {
        imageUrl = _uploadedImageUrl!;
        if (kDebugMode) {
          print('✅ Using uploaded image URL: $imageUrl');
        }
      } else if (_localImagePath != null) {
        // إذا كانت الصورة base64، نحولها إلى URL
        if (_localImagePath!.startsWith('data:image')) {
          try {
            if (kDebugMode) {
              print('🔄 Converting base64 to Firebase Storage URL...');
            }

            imageUrl = await CategoryImageService.uploadCategoryImage(
              imageData: _localImagePath!,
            );

            if (kDebugMode) {
              print('✅ Base64 converted to URL: $imageUrl');
            }
          } catch (e) {
            Get.snackbar(
              'خطأ',
              'فشل في رفع الصورة: $e',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }
        } else {
          // إذا كان مسار ملف
          try {
            if (kDebugMode) {
              print('🔄 Uploading file to Firebase Storage...');
            }

            imageUrl = await CategoryImageService.uploadCategoryImage(
              imageData: _localImagePath!,
            );

            if (kDebugMode) {
              print('✅ File uploaded to URL: $imageUrl');
            }
          } catch (e) {
            Get.snackbar(
              'خطأ',
              'فشل في رفع الملف: $e',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }
        }
      } else if (_categoryImages.isNotEmpty) {
        final imageData = _categoryImages.first;
        if (imageData is String) {
          if (imageData.startsWith('http')) {
            // إذا كان URL موجود بالفعل
            imageUrl = imageData;
            if (kDebugMode) {
              print('✅ Using existing URL: $imageUrl');
            }
          } else if (imageData.startsWith('data:image')) {
            // إذا كان base64، نحوله إلى URL
            try {
              if (kDebugMode) {
                print('🔄 Converting category image base64 to URL...');
              }

              imageUrl = await CategoryImageService.uploadCategoryImage(
                imageData: imageData,
              );

              if (kDebugMode) {
                print('✅ Category image converted to URL: $imageUrl');
              }
            } catch (e) {
              Get.snackbar(
                'خطأ',
                'فشل في رفع صورة الفئة: $e',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }
          }
        } else if (imageData is XFile) {
          // رفع XFile إلى Firebase Storage
          try {
            if (kDebugMode) {
              print('🔄 Uploading XFile to Firebase Storage...');
            }

            imageUrl = await CategoryImageService.uploadCategoryImageFromXFile(
              xFile: imageData,
            );

            if (kDebugMode) {
              print('✅ XFile uploaded to URL: $imageUrl');
            }
          } catch (e) {
            Get.snackbar(
              'خطأ',
              'فشل في رفع XFile: $e',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }
        }
      }

      // التحقق من وجود صورة
      if (imageUrl.isEmpty) {
        Get.snackbar(
          'تحذير',
          'يرجى اختيار صورة للفئة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // Create category model
      final category = CategoryModel(
        id: widget.isEditMode ? widget.category!.id : '',
        name: _nameController.text.trim(),
        arabicName: _arabicNameController.text.trim(),
        image: imageUrl, // هذا يحتوي على URL الصورة الكامل
        isFeature: _isFeature,
        parentId: _parentIdController.text.trim(),
      );

      if (kDebugMode) {
        print('📋 Category model created:');
        print('   - ID: ${category.id}');
        print('   - Name: ${category.name}');
        print('   - Arabic Name: ${category.arabicName}');
        print('   - Image: ${category.image}');
        print('   - Image is empty: ${category.image.isEmpty}');
        print(
            '   - Image starts with http: ${category.image.startsWith('http')}');
        print('   - Is Feature: ${category.isFeature}');
        print('   - Parent ID: ${category.parentId}');
      }

      // Save category
      final controller = Get.find<CategoryController>();
      if (widget.isEditMode) {
        if (kDebugMode) {
          print('📝 Updating existing category...');
        }
        await controller.updateCategory(category);
        if (kDebugMode) {
          print('✅ Category updated successfully');
        }
        Get.snackbar(
          'نجح التحديث',
          'تم تحديث الفئة بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        if (kDebugMode) {
          print('➕ Creating new category...');
        }
        await controller.createCategory(category);
        if (kDebugMode) {
          print('✅ Category created successfully');
        }
        Get.snackbar(
          'نجح الإنشاء',
          'تم إنشاء الفئة بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      // Reset form and go back to list
      if (kDebugMode) {
        print('🔄 Resetting form and returning to list...');
      }

      controller.hideForm();
      _resetForm();

      if (kDebugMode) {
        print('✅ Category save process completed successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error during category save: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }

      Get.snackbar(
        'خطأ',
        'فشل في حفظ الفئة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _resetForm() {
    _nameController.clear();
    _arabicNameController.clear();
    _parentIdController.clear();
    _isFeature = false;
    _isRootCategory = false;
    _categoryImages.clear();
    _localImagePath = null;
    _uploadedImageUrl = null;
    _isUploading = false;
  }

  /// Get valid dropdown value or null if not found
  String? _getValidDropdownValue(String value) {
    if (value.isEmpty) return null;

    final controller = Get.find<CategoryController>();
    final validValues = [
      '', // بدون فئة أم
      ...controller.categories
          .where((cat) => cat.id != widget.category?.id)
          .map((cat) => cat.id)
    ];

    return validValues.contains(value) ? value : null;
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(bool isDark) {
    final controller = Get.find<CategoryController>();

    // إنشاء قائمة فريدة من القيم
    final Set<String> uniqueValues = <String>{};
    final List<DropdownMenuItem<String>> items = [
      const DropdownMenuItem<String>(
        value: '',
        child: Text('بدون فئة أم'),
      ),
    ];

    // إضافة الفئات مع التأكد من عدم تكرار القيم
    for (final category in controller.categories) {
      if (category.id != widget.category?.id &&
          category.id.isNotEmpty &&
          !uniqueValues.contains(category.id)) {
        uniqueValues.add(category.id);
        items.add(
          DropdownMenuItem<String>(
            value: category.id,
            child: Text(
              '${category.name} - ${category.arabicName}',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      }
    }

    if (kDebugMode) {
      print('🔍 Dropdown items built:');
      print('   - Total items: ${items.length}');
      print('   - Unique values: ${uniqueValues.length}');
      print('   - Values: ${items.map((item) => item.value).toList()}');
    }

    return items;
  }
}
