import 'dart:io';

import 'package:brother_admin_panel/data/models/category_model.dart';
import 'package:brother_admin_panel/data/repositories/categories/category_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  late final CategoryRepository _repository;

  // Observable variables
  final _categories = <CategoryModel>[].obs;
  final _filteredCategories = <CategoryModel>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedCategory = Rxn<CategoryModel>();
  final _isFormMode = false.obs;
  final _isEditMode = false.obs;
  final _isSearchExpanded = false.obs; // إضافة حالة توسع البحث

  // Image upload variables
  final _isImageUploading = false.obs;
  final _imageUploadProgress = 0.0.obs;
  final _selectedImageFile = Rxn<File>();
  final _uploadedImageUrl = ''.obs;

  // Getters
  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get filteredCategories => _filteredCategories;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  CategoryModel? get selectedCategory => _selectedCategory.value;
  bool get isFormMode => _isFormMode.value;
  bool get isEditMode => _isEditMode.value;
  bool get isSearchExpanded => _isSearchExpanded.value; // getter للبحث الموسع

  // Image upload getters
  bool get isImageUploading => _isImageUploading.value;
  double get imageUploadProgress => _imageUploadProgress.value;
  File? get selectedImageFile => _selectedImageFile.value;
  String get uploadedImageUrl => _uploadedImageUrl.value;

  // Image upload progress methods
  void updateImageUploadProgress(double progress) {
    _imageUploadProgress.value = progress;
    update();
  }

  void resetImageUploadProgress() {
    _imageUploadProgress.value = 0.0;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize repository
    _repository = Get.find<CategoryRepository>();
    // Load categories after a short delay to ensure proper initialization
    Future.delayed(const Duration(milliseconds: 100), loadCategories);
  }

  /// Load categories from Firestore
  Future<void> loadCategories() async {
    try {
      _isLoading.value = true;
      update();

      if (kDebugMode) {
        print('🔄 Starting to load categories...');
        print('📊 Current categories count: ${_categories.length}');
      }

      final categories = await _repository.getAllCategories();

      if (kDebugMode) {
        print('✅ Categories loaded successfully from repository');
        print('📊 Repository returned ${categories.length} categories');
      }

      _categories.value = categories;
      _filteredCategories.value = List.from(categories);

      if (kDebugMode) {
        print('💾 Categories stored in controller');
        print('📊 Controller now has ${_categories.length} categories');
        print('🔍 Filtered categories: ${_filteredCategories.length}');

        // تفاصيل كل فئة
        for (int i = 0; i < _categories.length; i++) {
          final category = _categories[i];
          print('📋 Category ${i + 1}:');
          print('   - ID: ${category.id}');
          print('   - Name: ${category.name}');
          print('   - Arabic Name: ${category.arabicName}');
          print('   - Image URL: ${category.image}');
          print('   - Image is empty: ${category.image.isEmpty}');
          print(
              '   - Image starts with http: ${category.image.startsWith('http')}');
          print('   - Is Feature: ${category.isFeature}');
          print('   - Parent ID: ${category.parentId}');
          print('   ---');
        }
      }

      _isLoading.value = false;
      update();

      if (kDebugMode) {
        print('✅ Categories loading completed');
        print('📊 Final state:');
        print('   - Total categories: ${_categories.length}');
        print('   - Filtered categories: ${_filteredCategories.length}');
        print('   - Loading state: ${_isLoading.value}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading categories: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }

      _isLoading.value = false;
      update();

      Get.snackbar(
        'Error',
        'Failed to load categories: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Search categories
  void searchCategories(String query) {
    _searchQuery.value = query;
    if (query.isEmpty) {
      _filteredCategories.value = _categories;
    } else {
      _filteredCategories.value = _categories.where((category) {
        return category.name.toLowerCase().contains(query.toLowerCase()) ||
            category.arabicName.contains(query) ||
            category.id.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update(); // تحديث الواجهة
  }

  // Clear search
  void clearSearch() {
    _searchQuery.value = '';
    _filteredCategories.value = _categories;
    update(); // تحديث الواجهة
  }

  // Toggle search expansion
  void toggleSearchExpansion() {
    _isSearchExpanded.value = !_isSearchExpanded.value;
    if (!_isSearchExpanded.value) {
      clearSearch();
    }
    update(); // تحديث الواجهة
  }

  // Select category for editing/viewing
  void selectCategory(CategoryModel category) {
    _selectedCategory.value = category;
  }

  // Clear selection
  void clearSelection() {
    _selectedCategory.value = null;
  }

  // Show form for adding new category
  void showAddForm() {
    _isFormMode.value = true;
    _isEditMode.value = false;
    _selectedCategory.value = null;
    update(); // تحديث الواجهة
  }

  // Show form for editing category
  void showEditForm(CategoryModel category) {
    if (kDebugMode) {
      print('✏️ showEditForm called with category:');
      print('   - ID: "${category.id}"');
      print('   - Name: "${category.name}"');
      print('   - Arabic Name: "${category.arabicName}"');
      print('   - Image: "${category.image}"');
      print('   - Is Feature: ${category.isFeature}');
      print('   - Parent ID: "${category.parentId}"');
    }

    _isFormMode.value = true;
    _isEditMode.value = true;
    _selectedCategory.value = category;
    update(); // تحديث الواجهة
  }

  // Hide form
  void hideForm() {
    _isFormMode.value = false;
    _isEditMode.value = false;
    _selectedCategory.value = null;
    update(); // تحديث الواجهة
  }

  // Create new category
  Future<bool> createCategory(CategoryModel category) async {
    try {
      _isLoading.value = true;
      update(); // تحديث الواجهة

      // Create category in Firebase
      final newId = await _repository.createCategory(category);

      // Update the category with the new ID from Firebase
      final newCategory = CategoryModel(
        id: newId,
        name: category.name,
        arabicName: category.arabicName,
        image: category.image,
        isFeature: category.isFeature,
        parentId: category.parentId,
      );

      // Add to local list
      _categories.add(newCategory);
      _filteredCategories.value = _categories;

      Get.snackbar(
        'Success',
        'Category created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      hideForm();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create category: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
      update(); // تحديث الواجهة
    }
  }

  // Update existing category
  Future<bool> updateCategory(CategoryModel category) async {
    try {
      if (kDebugMode) {
        print('🔄 Starting updateCategory process...');
        print('   - Category ID: "${category.id}"');
        print('   - Category Name: "${category.name}"');
        print('   - Category Arabic Name: "${category.arabicName}"');
        print('   - Category Image: "${category.image}"');
        print('   - Category Is Feature: ${category.isFeature}');
        print('   - Category Parent ID: "${category.parentId}"');
      }

      _isLoading.value = true;
      update(); // تحديث الواجهة

      if (kDebugMode) {
        print('🔄 Updating category in Firebase: ${category.id}');
        print('🖼️ New image URL: ${category.image}');
        print('🖼️ Image is empty: ${category.image.isEmpty}');
        print(
            '🖼️ Image starts with http: ${category.image.startsWith('http')}');
      }

      // Update category in Firebase
      final updateResult = await _repository.updateCategory(category);

      if (kDebugMode) {
        print('✅ Firebase update completed: $updateResult');
      }

      // Update in local list
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;

        if (kDebugMode) {
          print('✅ Category updated in local list at index: $index');
          print('🖼️ Local list now has image: ${_categories[index].image}');
        }

        // إعادة تطبيق البحث إذا كان هناك بحث نشط
        if (_searchQuery.value.isNotEmpty) {
          searchCategories(_searchQuery.value);
          if (kDebugMode) {
            print('🔍 Reapplied search with query: ${_searchQuery.value}');
            print(
                '🔍 Filtered categories count: ${_filteredCategories.length}');
          }
        } else {
          _filteredCategories.value = List.from(_categories);
          if (kDebugMode) {
            print('📋 Updated filtered categories without search');
            print(
                '📋 Filtered categories count: ${_filteredCategories.length}');
          }
        }

        // تحديث فوري للواجهة
        update();
      } else {
        if (kDebugMode) {
          print('❌ Category not found in local list for ID: ${category.id}');
          print('❌ Available IDs: ${_categories.map((c) => c.id).toList()}');
        }
      }

      Get.snackbar(
        'نجح التحديث',
        'تم تحديث الفئة بنجاح في Firebase',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      hideForm();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating category: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }

      Get.snackbar(
        'خطأ',
        'فشل في تحديث الفئة: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
      update(); // تحديث الواجهة
    }
  }

  // Delete category
  Future<bool> deleteCategory(String categoryId) async {
    try {
      if (kDebugMode) {
        print('🗑️ Starting deleteCategory process...');
        print('   - Category ID: "$categoryId"');
        print('   - ID is empty: ${categoryId.isEmpty}');
        print('   - Current categories count: ${_categories.length}');
        print('   - Categories IDs: ${_categories.map((c) => c.id).toList()}');
      }

      _isLoading.value = true;
      update(); // تحديث الواجهة

      if (kDebugMode) {
        print('🗑️ Deleting category from Firebase: $categoryId');
      }

      // Delete category from Firebase
      final deleteResult = await _repository.deleteCategory(categoryId);

      if (kDebugMode) {
        print('✅ Firebase delete completed: $deleteResult');
      }

      // Remove from local list
      final initialCount = _categories.length;
      _categories.removeWhere((c) => c.id == categoryId);
      final finalCount = _categories.length;

      if (kDebugMode) {
        print('🗑️ Category removal from local list:');
        print('   - Initial count: $initialCount');
        print('   - Final count: $finalCount');
        print('   - Removed: ${initialCount - finalCount} categories');
      }

      _filteredCategories.value = _categories;

      Get.snackbar(
        'نجح الحذف',
        'تم حذف الفئة بنجاح من Firebase',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting category: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }

      Get.snackbar(
        'خطأ',
        'فشل في حذف الفئة: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
      update(); // تحديث الواجهة
    }
  }

  // Toggle feature status
  Future<void> toggleFeatureStatus(String categoryId) async {
    try {
      final category = _categories.firstWhere((c) => c.id == categoryId);
      final updatedCategory = CategoryModel(
        id: category.id,
        name: category.name,
        arabicName: category.arabicName,
        image: category.image,
        isFeature: !category.isFeature,
        parentId: category.parentId,
      );

      await updateCategory(updatedCategory);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to toggle feature status: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Get subcategories count
  int getSubCategoriesCount(String categoryId) {
    return _categories.where((c) => c.parentId == categoryId).length;
  }

  // Check if category has subcategories
  bool hasSubCategories(String categoryId) {
    return _categories.any((c) => c.parentId == categoryId);
  }

  // Get parent category name
  String getParentCategoryName(String parentId) {
    if (parentId.isEmpty) return 'Main Category';
    final parent = _categories.firstWhereOrNull((c) => c.id == parentId);
    return parent?.name ?? 'Unknown';
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadCategories();
  }

  // Advanced search using Firebase
  Future<void> performFirebaseSearch(String query) async {
    try {
      _isLoading.value = true;

      if (query.isEmpty) {
        await loadCategories();
      } else {
        final results = await _repository.searchCategories(query);
        _filteredCategories.value = results;
      }

      _searchQuery.value = query;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Search failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Get categories count
  Future<int> getCategoriesCount() async {
    try {
      return await _repository.getCategoriesCount();
    } catch (e) {
      return _categories.length;
    }
  }

  // Validate category before saving
  bool validateCategory(CategoryModel category) {
    if (category.name.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Category name is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (category.arabicName.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Arabic name is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // ===== Image Upload Methods =====

  /// اختيار ملف صورة (تم استبدالها برفع مباشر إلى Firebase Storage)
  void selectImageFile(File imageFile) {
    // لم تعد مطلوبة - تم استبدالها برفع مباشر
  }

  /// رفع الصورة مع تتبع التقدم (تم استبدالها برفع مباشر إلى Firebase Storage)
  Future<bool> uploadImageWithProgress() async {
    // لم تعد مطلوبة - تم استبدالها برفع مباشر في ImagePickerWidget
    return false;
  }

  /// مسح الصورة المحددة
  void clearSelectedImage() {
    _selectedImageFile.value = null;
    _uploadedImageUrl.value = '';
    update();
  }

  /// الحصول على URL الصورة النهائي (المرفوعة أو الموجودة)
  String getFinalImageUrl() {
    if (_uploadedImageUrl.value.isNotEmpty) {
      return _uploadedImageUrl.value;
    }
    if (_selectedCategory.value?.image.isNotEmpty == true) {
      return _selectedCategory.value!.image;
    }
    return '';
  }

  /// إنشاء فئة مع رفع الصورة
  Future<bool> createCategoryWithImageUpload(
    String name,
    String arabicName,
    bool isFeature,
    String parentId,
  ) async {
    // التحقق من وجود صورة
    if (_uploadedImageUrl.value.isEmpty && _selectedImageFile.value == null) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار صورة للفئة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    // إذا كان هناك ملف صورة محدد، ارفعه أولاً
    if (_selectedImageFile.value != null && _uploadedImageUrl.value.isEmpty) {
      final uploadSuccess = await uploadImageWithProgress();
      if (!uploadSuccess) {
        return false;
      }
    }

    // إنشاء الفئة
    final category = CategoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      arabicName: arabicName.trim(),
      image: _uploadedImageUrl.value,
      isFeature: isFeature,
      parentId: parentId.trim(),
    );

    return createCategory(category);
  }

  /// تحديث فئة مع رفع الصورة
  Future<bool> updateCategoryWithImageUpload(
    String name,
    String arabicName,
    bool isFeature,
    String parentId,
  ) async {
    final currentCategory = _selectedCategory.value;
    if (currentCategory == null) {
      Get.snackbar(
        'خطأ',
        'لم يتم تحديد فئة للتحديث',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // إذا كان هناك ملف صورة محدد، ارفعه أولاً
    if (_selectedImageFile.value != null && _uploadedImageUrl.value.isEmpty) {
      final uploadSuccess = await uploadImageWithProgress();
      if (!uploadSuccess) {
        return false;
      }
    }

    // تحديث الفئة
    final updatedCategory = CategoryModel(
      id: currentCategory.id,
      name: name.trim(),
      arabicName: arabicName.trim(),
      image: _uploadedImageUrl.value.isNotEmpty
          ? _uploadedImageUrl.value
          : currentCategory.image,
      isFeature: isFeature,
      parentId: parentId.trim(),
    );

    return updateCategory(updatedCategory);
  }

  /// إعادة تعيين حالة رفع الصورة
  void resetImageUploadState() {
    _isImageUploading.value = false;
    _imageUploadProgress.value = 0.0;
    _selectedImageFile.value = null;
    _uploadedImageUrl.value = '';
    update();
  }
}
