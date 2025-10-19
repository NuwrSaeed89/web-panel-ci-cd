import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/product_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/category_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/brand_controller.dart';
import 'package:brother_admin_panel/services/product_image_service.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/data/models/product_model.dart';
import 'package:brother_admin_panel/data/models/category_model.dart';
import 'package:brother_admin_panel/data/models/brand_model.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/image_picker_widget.dart';
import 'package:flutter/foundation.dart';

class ProductsFormView extends StatefulWidget {
  final bool isDark;
  final ProductController controller;
  final ProductModel? product; // للمراجعة/التعديل

  const ProductsFormView({
    super.key,
    required this.isDark,
    required this.controller,
    this.product,
  });

  @override
  State<ProductsFormView> createState() => _ProductsFormViewState();
}

class _ProductsFormViewState extends State<ProductsFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _arabicTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _arabicDescriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _skuController = TextEditingController();
  final _productTypeController = TextEditingController();

  CategoryModel? _selectedCategory;
  BrandModel? _selectedBrand;
  List<String> _selectedImages = [];
  List<String> _uploadedImageUrls = [];
  bool _isFeature = false;
  bool _isLoading = false;
  bool _isUploadingImages = false;

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndBrands();
    // تأخير تحميل بيانات المنتج لضمان جاهزية المتحكمات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProductData();
    });
  }

  @override
  void didUpdateWidget(ProductsFormView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // تحديث البيانات عند تغيير المنتج
    if (oldWidget.product?.id != widget.product?.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadProductData();
      });
    }
  }

  void _loadProductData() {
    if (widget.product != null) {
      setState(() {
        _titleController.text = widget.product!.title;
        _arabicTitleController.text = widget.product!.arabicTitle;
        _descriptionController.text = widget.product!.description ?? '';
        _arabicDescriptionController.text =
            widget.product!.arabicDescription ?? '';
        _priceController.text = widget.product!.price.toString();
        _salePriceController.text = widget.product!.salePrice.toString();
        _stockController.text = widget.product!.stock.toString();
        _skuController.text = widget.product!.sku ?? '';
        _productTypeController.text = widget.product!.productType;

        // تحميل الصور - دعم URLs و base64
        final images = widget.product!.images ?? [];
        _selectedImages = images;

        // تصنيف الصور حسب النوع
        _uploadedImageUrls =
            images.where((img) => img.startsWith('http')).toList();
        final base64Images =
            images.where((img) => img.startsWith('data:image')).toList();

        if (base64Images.isNotEmpty) {
          // تحويل base64 إلى URLs في الخلفية
          _convertBase64ImagesToUrls(base64Images);
        }

        _isFeature = widget.product!.isFeature ?? false;

        // انتظار تحميل الفئات والبراندات
        _setSelectedCategoryAndBrand();
      });
    }
  }

  void _setSelectedCategoryAndBrand() {
    if (widget.product == null) return;

    final categoryController = Get.find<CategoryController>();
    final brandController = Get.find<BrandController>();

    // انتظار تحميل الفئات
    if (categoryController.categories.isNotEmpty) {
      _selectedCategory = widget.product!.categoryId != null
          ? categoryController.categories
              .firstWhereOrNull((cat) => cat.id == widget.product!.categoryId)
          : null;
    } else {
      // إذا لم تكن الفئات محملة، انتظر حتى يتم تحميلها
      categoryController.addListener(() {
        if (categoryController.categories.isNotEmpty) {
          _selectedCategory = widget.product!.categoryId != null
              ? categoryController.categories.firstWhereOrNull(
                  (cat) => cat.id == widget.product!.categoryId)
              : null;
          setState(() {});
        }
      });
    }

    // انتظار تحميل البراندات
    if (brandController.brands.isNotEmpty) {
      // Find brand by ID to ensure we get the correct instance
      if (widget.product!.brand != null) {
        _selectedBrand = brandController.brands
            .firstWhereOrNull((brand) => brand.id == widget.product!.brand!.id);
      }
    } else {
      // إذا لم تكن البراندات محملة، انتظر حتى يتم تحميلها
      brandController.addListener(() {
        if (brandController.brands.isNotEmpty) {
          if (widget.product!.brand != null) {
            _selectedBrand = brandController.brands.firstWhereOrNull(
                (brand) => brand.id == widget.product!.brand!.id);
          }
          setState(() {});
        }
      });
    }
  }

  void _loadCategoriesAndBrands() {
    final categoryController = Get.find<CategoryController>();
    final brandController = Get.find<BrandController>();

    if (categoryController.categories.isEmpty) {
      categoryController.loadCategories();
    }
    if (brandController.brands.isEmpty) {
      brandController.loadBrands();
    }
  }

  /// تحويل صور base64 إلى URLs
  Future<void> _convertBase64ImagesToUrls(List<String> base64Images) async {
    try {
      if (kDebugMode) {
        print('🔄 Converting base64 images to URLs...');
        print('   - Base64 images count: ${base64Images.length}');
      }

      setState(() {
        _isUploadingImages = true;
      });

      final urls =
          await ProductImageService.convertBase64ListToUrls(base64Images);

      setState(() {
        _uploadedImageUrls.addAll(urls);
        _selectedImages = _uploadedImageUrls;
        _isUploadingImages = false;
      });

      if (kDebugMode) {
        print('✅ Base64 images converted to URLs successfully');
        print('   - Total URLs: ${_uploadedImageUrls.length}');
      }

      Get.snackbar(
        'تم التحويل',
        'تم تحويل الصور إلى URLs بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error converting base64 images: $e');
      }

      setState(() {
        _isUploadingImages = false;
      });

      Get.snackbar(
        'خطأ',
        'فشل في تحويل الصور: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _arabicTitleController.dispose();
    _descriptionController.dispose();
    _arabicDescriptionController.dispose();
    _priceController.dispose();
    _salePriceController.dispose();
    _stockController.dispose();
    _skuController.dispose();
    _productTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ResponsiveHelper.getResponsivePadding(context),
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: ResponsiveHelper.isMobile(context) ? double.infinity : 800,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF1a1a2e) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: widget.isDark ? Colors.white12 : Colors.grey.shade200),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  _buildHeader(),
                  const SizedBox(height: 24),

                  // النموذج
                  _buildForm(),
                  const SizedBox(height: 24),

                  // أزرار الحفظ والإلغاء
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          widget.product != null ? Icons.edit : Icons.add_shopping_cart,
          size: 32,
          color: widget.isDark ? Colors.white : Colors.blue,
        ),
        const SizedBox(width: 12),
        Text(
          widget.product != null ? 'تعديل المنتج' : 'إضافة منتج جديد',
          style: TTextStyles.heading2.copyWith(
            color: widget.isDark ? Colors.white : Color(0xFF111111),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        // الصف الأول - العنوان واللغة العربية
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _titleController,
                label: 'اسم المنتج (إنجليزي)',
                hint: 'أدخل اسم المنتج باللغة الإنجليزية',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'اسم المنتج مطلوب';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _arabicTitleController,
                label: 'اسم المنتج (عربي)',
                hint: 'أدخل اسم المنتج باللغة العربية',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'اسم المنتج بالعربية مطلوب';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // الصف الثاني - الوصف
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _descriptionController,
                label: 'الوصف (إنجليزي)',
                hint: 'أدخل وصف المنتج باللغة الإنجليزية',
                maxLines: 3,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _arabicDescriptionController,
                label: 'الوصف (عربي)',
                hint: 'أدخل وصف المنتج باللغة العربية',
                maxLines: 3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // الصف الثالث - الفئة والبراند
        Row(
          children: [
            Expanded(
              child: _buildCategoryDropdown(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBrandDropdown(),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // الصف الرابع - السعر والسعر المخفض
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _priceController,
                label: 'السعر',
                hint: '0.00',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'السعر مطلوب';
                  }
                  if (double.tryParse(value) == null) {
                    return 'السعر يجب أن يكون رقم';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _salePriceController,
                label: 'السعر المخفض',
                hint: '0.00',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // الصف الخامس - المخزون والرمز
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _stockController,
                label: 'المخزون',
                hint: '0',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'المخزون مطلوب';
                  }
                  if (int.tryParse(value) == null) {
                    return 'المخزون يجب أن يكون رقم';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _skuController,
                label: 'رمز المنتج (SKU)',
                hint: 'أدخل رمز المنتج',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // الصف السادس - نوع المنتج والميزة
        Row(
          children: [
            // Expanded(
            //   child: _buildTextField(
            //     controller: _productTypeController,
            //     label: 'نوع المنتج',
            //     hint: 'أدخل نوع المنتج',
            //     validator: (value) {
            //       if (value == null || value.trim().isEmpty) {
            //         return 'نوع المنتج مطلوب';
            //       }
            //       return null;
            //     },
            //   ),
            // ),
            //const SizedBox(width: 16),
            _buildFeatureCheckbox(),
          ],
        ),
        const SizedBox(height: 24),

        // قسم الصور
        _buildImagesSection(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TTextStyles.bodyMedium.copyWith(
            color: widget.isDark ? Colors.white : Color(0xFF111111),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: widget.isDark ? Colors.white54 : Colors.grey.shade500,
            ),
            filled: true,
            fillColor: widget.isDark ? Colors.white10 : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.isDark ? Colors.white24 : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.isDark ? Colors.white24 : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
          ),
          style: TextStyle(
            color: widget.isDark ? Colors.white : Color(0xFF111111),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الفئة',
          style: TTextStyles.bodyMedium.copyWith(
            color: widget.isDark ? Colors.white : Color(0xFF111111),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GetBuilder<CategoryController>(
          builder: (categoryController) {
            // Ensure unique categories by ID to prevent dropdown assertion errors
            final uniqueCategories = categoryController.categories
                .fold<Map<String, CategoryModel>>({}, (map, category) {
                  if (!map.containsKey(category.id)) {
                    map[category.id] = category;
                  }
                  return map;
                })
                .values
                .toList();

            // Find the selected category by ID to ensure proper matching
            CategoryModel? selectedCategory;
            if (_selectedCategory != null) {
              selectedCategory = uniqueCategories.firstWhereOrNull(
                (category) => category.id == _selectedCategory!.id,
              );
            }

            return DropdownButtonFormField<CategoryModel>(
              value: selectedCategory,
              decoration: InputDecoration(
                filled: true,
                fillColor: widget.isDark ? Colors.white10 : Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        widget.isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        widget.isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),
              hint: Text(
                'اختر الفئة',
                style: TextStyle(
                  color: widget.isDark ? Colors.white54 : Colors.grey.shade500,
                ),
              ),
              items: uniqueCategories.map((category) {
                return DropdownMenuItem<CategoryModel>(
                  value: category,
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Color(0xFF111111),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (CategoryModel? value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'اختر الفئة';
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBrandDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'البراند',
          style: TTextStyles.bodyMedium.copyWith(
            color: widget.isDark ? Colors.white : Color(0xFF111111),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GetBuilder<BrandController>(
          builder: (brandController) {
            // Ensure unique brands by ID to prevent dropdown assertion errors
            final uniqueBrands = brandController.brands
                .fold<Map<String, BrandModel>>({}, (map, brand) {
                  if (!map.containsKey(brand.id)) {
                    map[brand.id] = brand;
                  }
                  return map;
                })
                .values
                .toList();

            // Find the selected brand by ID to ensure proper matching
            BrandModel? selectedBrand;
            if (_selectedBrand != null) {
              selectedBrand = uniqueBrands.firstWhereOrNull(
                (brand) => brand.id == _selectedBrand!.id,
              );
            }

            return DropdownButtonFormField<BrandModel>(
              value: selectedBrand,
              decoration: InputDecoration(
                filled: true,
                fillColor: widget.isDark ? Colors.white10 : Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        widget.isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        widget.isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),
              hint: Text(
                'اختر البراند',
                style: TextStyle(
                  color: widget.isDark ? Colors.white54 : Colors.grey.shade500,
                ),
              ),
              items: uniqueBrands.map((brand) {
                return DropdownMenuItem<BrandModel>(
                  value: brand,
                  child: Text(
                    brand.name,
                    style: TextStyle(
                      color: widget.isDark ? Colors.white : Color(0xFF111111),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (BrandModel? value) {
                setState(() {
                  _selectedBrand = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'اختر البراند';
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCheckbox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ميزة',
          style: TTextStyles.bodyMedium.copyWith(
            color: widget.isDark ? Colors.white : Color(0xFF111111),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isDark ? Colors.white10 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isDark ? Colors.white24 : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Checkbox(
                value: _isFeature,
                onChanged: (bool? value) {
                  setState(() {
                    _isFeature = value ?? false;
                  });
                },
                activeColor: Colors.blue,
              ),
              Text(
                'منتج مميز',
                style: TextStyle(
                  color: widget.isDark ? Colors.white : Color(0xFF111111),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'صور المنتج',
              style: TTextStyles.bodyMedium.copyWith(
                color: widget.isDark ? Colors.white : Color(0xFF111111),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            if (_isUploadingImages) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'جاري تحويل الصور...',
                style: TextStyle(
                  color: widget.isDark ? Colors.white70 : Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        // عرض حالة الصور
        if (_uploadedImageUrls.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.isDark
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.green.shade200,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'تم رفع ${_uploadedImageUrls.length} صورة إلى Firebase Storage',
                  style: TextStyle(
                    color: widget.isDark ? Colors.green : Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // صور المنتج (متعددة)
        MultiImagePickerWidget(
          key: ValueKey(
              'product_images_${widget.product?.id ?? 'new'}'), // إضافة key فريد
          initialImages: _selectedImages,
          onImagesSelected: (images) {
            setState(() {
              _selectedImages = images;
              // تصنيف الصور الجديدة
              _uploadedImageUrls =
                  images.where((img) => img.startsWith('http')).toList();
            });
          },
          onError: (error) {
            Get.snackbar(
              'خطأ في الصور',
              error,
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          },
          label:
              'صور المنتج (الحد الأقصى: 10 صور) - سيتم رفعها إلى Firebase Storage',
          width: double.infinity,
          height: 400,
          maxImages: 10,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  widget.controller.hideForm();
                },
          child: Text(
            'إلغاء',
            style: TextStyle(
              color: widget.isDark ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveProduct,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  widget.product != null ? 'تحديث المنتج' : 'إضافة المنتج',
                ),
        ),
      ],
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار الفئة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (_selectedBrand == null) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار البراند',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // معالجة الصور - تحويل base64 إلى URLs إذا لزم الأمر
      final List<String> finalImages = [];

      if (_selectedImages.isNotEmpty) {
        if (kDebugMode) {
          print('🔄 Processing product images...');
          print('   - Selected images count: ${_selectedImages.length}');
        }

        // تصنيف الصور
        final urls =
            _selectedImages.where((img) => img.startsWith('http')).toList();
        final base64Images = _selectedImages
            .where((img) => img.startsWith('data:image'))
            .toList();
        final filePaths = _selectedImages
            .where((img) =>
                !img.startsWith('http') && !img.startsWith('data:image'))
            .toList();

        if (kDebugMode) {
          print('   - URLs: ${urls.length}');
          print('   - Base64: ${base64Images.length}');
          print('   - File paths: ${filePaths.length}');
        }

        // إضافة URLs الموجودة
        finalImages.addAll(urls);

        // تحويل base64 إلى URLs
        if (base64Images.isNotEmpty) {
          if (kDebugMode) {
            print('🔄 Converting base64 images to URLs...');
          }

          final base64Urls =
              await ProductImageService.convertBase64ListToUrls(base64Images);
          finalImages.addAll(base64Urls);

          if (kDebugMode) {
            print('✅ Base64 images converted: ${base64Urls.length}');
          }
        }

        // رفع ملفات محلية إلى URLs
        if (filePaths.isNotEmpty) {
          if (kDebugMode) {
            print('🔄 Uploading file paths to URLs...');
          }

          final fileUrls =
              await ProductImageService.uploadMultipleProductImages(
            imageDataList: filePaths,
            prefix: 'product_${DateTime.now().millisecondsSinceEpoch}',
          );
          finalImages.addAll(fileUrls);

          if (kDebugMode) {
            print('✅ File paths uploaded: ${fileUrls.length}');
          }
        }

        if (kDebugMode) {
          print('✅ Final images count: ${finalImages.length}');
          print(
              '✅ All images are now URLs: ${finalImages.every((img) => img.startsWith('http'))}');
        }
      }

      final product = ProductModel(
        id: widget.product?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        arabicTitle: _arabicTitleController.text.trim(),
        description: _descriptionController.text.trim(),
        arabicDescription: _arabicDescriptionController.text.trim(),
        price: double.parse(_priceController.text),
        salePrice: double.tryParse(_salePriceController.text) ?? 0.0,
        stock: int.parse(_stockController.text),
        sku: _skuController.text.trim(),
        productType: _productTypeController.text.trim(),
        thumbnail: finalImages.isNotEmpty ? finalImages.first : '',
        images: finalImages,
        isFeature: _isFeature,
        categoryId: _selectedCategory!.id,
        brand: _selectedBrand!,
      );

      if (kDebugMode) {
        print('📋 Product model created:');
        print('   - ID: ${product.id}');
        print('   - Title: ${product.title}');
        print('   - Images count: ${product.images?.length ?? 0}');
        print('   - Thumbnail: ${product.thumbnail}');
        print(
            '   - All images are URLs: ${product.images?.every((img) => img.startsWith('http')) ?? true}');
      }

      if (widget.product != null) {
        // تحديث المنتج
        await widget.controller.updateProduct(product);
      } else {
        // إضافة منتج جديد
        await widget.controller.createProduct(product);
      }

      // العودة إلى قائمة المنتجات
      widget.controller.hideForm();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving product: $e');
        print('❌ Error type: ${e.runtimeType}');
      }

      Get.snackbar(
        'خطأ',
        'فشل في حفظ المنتج: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
