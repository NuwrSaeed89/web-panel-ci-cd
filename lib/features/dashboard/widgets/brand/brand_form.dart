import 'dart:convert';

import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/data/models/brand_model.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/brand_controller.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';

class BrandForm extends StatefulWidget {
  final BrandModel? brand;
  final bool isEditMode;

  const BrandForm({
    super.key,
    this.brand,
    required this.isEditMode,
  });

  @override
  State<BrandForm> createState() => _BrandFormState();
}

class _BrandFormState extends State<BrandForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _coverController = TextEditingController();
  bool _isFeature = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.brand != null) {
      _nameController.text = widget.brand!.name;
      _imageController.text = widget.brand!.image;
      _coverController.text = widget.brand!.cover;
      _isFeature = widget.brand!.isFeature ?? false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _coverController.dispose();
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDesktopForm(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(isDark),
              const SizedBox(height: 32),
              _buildFormFields(isDark),
              const SizedBox(height: 32),
              _buildActionButtons(isDark),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                widget.isEditMode ? Icons.edit : Icons.add,
                color: isDark ? TColors.primary : Colors.blue.shade700,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.isEditMode ? 'تعديل الماركة' : 'إضافة ماركة جديدة',
                  style: TTextStyles.heading2.copyWith(
                    color: isDark ? Colors.white : Color(0xFF111111),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.isEditMode
                ? 'قم بتعديل معلومات الماركة'
                : 'أدخل معلومات الماركة الجديدة',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize:
                  ResponsiveHelper.getResponsiveFontSize(context, mobile: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildNameField(isDark),
          const SizedBox(height: 24),
          _buildImageField(isDark),
          const SizedBox(height: 24),
          _buildCoverImageField(isDark),
          const SizedBox(height: 24),
          _buildFeatureCheckbox(isDark),
        ],
      ),
    );
  }

  Widget _buildNameField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اسم الماركة *',
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF111111),
            fontSize: ResponsiveHelper.getResponsiveFontSize(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'أدخل اسم الماركة',
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade500,
            ),
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? TColors.primary : Colors.blue.shade700,
                width: 2,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF111111),
            fontSize: ResponsiveHelper.getResponsiveFontSize(context),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'اسم الماركة مطلوب';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildImageField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صورة الماركة *',
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF111111),
            fontSize: ResponsiveHelper.getResponsiveFontSize(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildImageSelector(isDark, isCover: false),
      ],
    );
  }

  Widget _buildCoverImageField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صورة الغلاف (اختياري)',
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF111111),
            fontSize: ResponsiveHelper.getResponsiveFontSize(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildImageSelector(isDark, isCover: true),
      ],
    );
  }

  Widget _buildFeatureCheckbox(bool isDark) {
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
          Checkbox(
            value: _isFeature,
            onChanged: (value) {
              setState(() {
                _isFeature = value ?? false;
              });
            },
            activeColor: Colors.amber,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تمييز الماركة',
                  style: TextStyle(
                    color: isDark ? Colors.white : Color(0xFF111111),
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الماركات المميزة ستظهر في المقدمة',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context,
                        mobile: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معاينة الصور',
            style: TextStyle(
              color: isDark ? Colors.white : Color(0xFF111111),
              fontSize: ResponsiveHelper.getResponsiveFontSize(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          if (_imageController.text.isNotEmpty) ...[
            Text(
              'صورة الماركة:',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    _imageController.text,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
                        color:
                            isDark ? Color(0xFF222222) : Colors.grey.shade200,
                        child: Icon(
                          Icons.branding_watermark,
                          size: 32,
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (_coverController.text.isNotEmpty) ...[
            Text(
              'صورة الغلاف:',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _coverController.text,
                width: double.infinity,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 120,
                    color: isDark ? Colors.black26 : Colors.grey.shade200,
                    child: Icon(
                      Icons.error,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              final controller = Get.find<BrandController>();
              controller.hideForm();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF111111),
                fontSize: ResponsiveHelper.getResponsiveFontSize(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _saveBrand,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? TColors.primary : Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              widget.isEditMode ? 'تحديث الماركة' : 'إضافة الماركة',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.getResponsiveFontSize(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveBrand() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imageController.text.isEmpty) {
      Get.snackbar(
        'خطأ في التحقق',
        'صورة الماركة مطلوبة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final controller = Get.find<BrandController>();
    final brand = BrandModel(
      id: widget.isEditMode ? widget.brand!.id : '',
      name: _nameController.text.trim(),
      image: _imageController.text.trim(),
      cover: _coverController.text.trim(),
      isFeature: _isFeature,
      productCount: widget.isEditMode ? widget.brand!.productCount : 0,
    );

    bool success;
    if (widget.isEditMode) {
      success = await controller.updateBrand(brand);
    } else {
      success = await controller.createBrand(brand);
    }

    if (success) {
      Get.snackbar(
        'نجح',
        widget.isEditMode ? 'تم تحديث الماركة بنجاح' : 'تم إضافة الماركة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildImageSelector(bool isDark, {required bool isCover}) {
    final controller = Get.find<BrandController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          // Current image or selected image
          GetBuilder<BrandController>(
            builder: (brandController) {
              // Show uploading indicator
              if ((isCover
                  ? brandController.isUploadingCover
                  : brandController.isUploadingImage)) {
                return Container(
                  height: 200,
                  width: isCover ? double.infinity : 200,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Color(0xFF0055ff),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'جاري رفع صورة المزود...',
                        style: TTextStyles.bodyMedium.copyWith(
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show uploaded URL image
              final uploadedUrl = isCover
                  ? brandController.uploadedCoverUrl
                  : brandController.uploadedImageUrl;
              if (uploadedUrl != null) {
                return Container(
                  height: 200,
                  width: isCover ? double.infinity : 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(uploadedUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (isCover)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(uploadedUrl),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: () => brandController.removeSelectedImage(
                              isCover: isCover),
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show existing image (URL or base64)
              final existingImage =
                  isCover ? _coverController.text : _imageController.text;
              if (existingImage.isNotEmpty) {
                return Container(
                  height: 200,
                  width: isCover ? double.infinity : 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: existingImage.startsWith('http')
                          ? NetworkImage(existingImage)
                          : MemoryImage(base64Decode(existingImage))
                              as ImageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Circular brand image
                      if (!isCover)
                        Center(
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: existingImage.startsWith('http')
                                  ? Image.network(
                                      existingImage,
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 160,
                                          height: 160,
                                          color: isDark
                                              ? Color(0xFF222222)
                                              : Colors.grey.shade200,
                                          child: Icon(
                                            Icons.branding_watermark,
                                            size: 48,
                                            color: isDark
                                                ? Colors.white54
                                                : Colors.grey.shade500,
                                          ),
                                        );
                                      },
                                    )
                                  : Image.memory(
                                      base64Decode(existingImage),
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 160,
                                          height: 160,
                                          color: isDark
                                              ? Color(0xFF222222)
                                              : Colors.grey.shade200,
                                          child: Icon(
                                            Icons.branding_watermark,
                                            size: 48,
                                            color: isDark
                                                ? Colors.white54
                                                : Colors.grey.shade500,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ),
                      // Cover image (rectangular)
                      if (isCover)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: existingImage.startsWith('http')
                                    ? NetworkImage(existingImage)
                                    : MemoryImage(base64Decode(existingImage))
                                        as ImageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: () => brandController.removeSelectedImage(
                              isCover: isCover),
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isCover
                            ? Icons.photo_library
                            : Icons.branding_watermark,
                        size: 48,
                        color: isDark ? Colors.white54 : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'لم يتم اختيار صورة',
                        style: TTextStyles.bodyMedium.copyWith(
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 16),

          // Image selection buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      controller.pickImageFromGallery(isCover: isCover),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('من المعرض'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      controller.pickImageFromCamera(isCover: isCover),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('الكاميرا'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
