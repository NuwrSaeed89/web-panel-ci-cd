import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brother_admin_panel/data/models/product_model.dart';
import 'package:brother_admin_panel/data/repositories/product/product_repository.dart';
import 'package:flutter/foundation.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  late final ProductRepository _repository;

  // Observable variables
  final _products = <ProductModel>[].obs;
  final _filteredProducts = <ProductModel>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedProduct = Rxn<ProductModel>();
  final _isFormMode = false.obs;
  final _isEditMode = false.obs;
  final _isSearchExpanded = false.obs;
  final _selectedCategory = ''.obs;
  final _selectedBrand = ''.obs;
  final _sortBy = 'title'.obs;
  final _sortOrder = 'asc'.obs;

  // Getters
  List<ProductModel> get products => _products;
  List<ProductModel> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  ProductModel? get selectedProduct => _selectedProduct.value;
  bool get isFormMode => _isFormMode.value;
  bool get isEditMode => _isEditMode.value;
  bool get isSearchExpanded => _isSearchExpanded.value;
  String get selectedCategory => _selectedCategory.value;
  String get selectedBrand => _selectedBrand.value;
  String get sortBy => _sortBy.value;
  String get sortOrder => _sortOrder.value;

  @override
  void onInit() {
    super.onInit();
    // Initialize repository
    _repository = Get.find<ProductRepository>();
    // Load products after a short delay to ensure proper initialization
    Future.delayed(const Duration(milliseconds: 100), loadProducts);
  }

  /// Load products from Firestore
  Future<void> loadProducts() async {
    try {
      _isLoading.value = true;
      update();

      if (kDebugMode) {
        print('🔄 Starting to load products...');
        print('📊 Current products count: ${_products.length}');
      }

      // Get all products (you might want to implement pagination here)
      final products = await _repository.fetchProductsByQuery(
        FirebaseFirestore.instance.collection('Products'),
      );

      if (kDebugMode) {
        print('✅ Products loaded successfully from repository');
        print('📊 Repository returned ${products.length} products');
      }

      _products.value = products;
      _filteredProducts.value = List.from(products);

      if (kDebugMode) {
        print('💾 Products stored in controller');
        print('📊 Controller now has ${_products.length} products');
        print('🔍 Filtered products: ${_filteredProducts.length}');
      }

      _isLoading.value = false;
      update();

      if (kDebugMode) {
        print('✅ Products loading completed');
        print('📊 Final state:');
        print('   - Total products: ${_products.length}');
        print('   - Filtered products: ${_filteredProducts.length}');
        print('   - Loading state: ${_isLoading.value}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading products: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }

      _isLoading.value = false;
      update();

      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }

  // Clear search
  void clearSearch() {
    _searchQuery.value = '';
    _applyFilters();
  }

  // Toggle search expansion
  void toggleSearchExpansion() {
    _isSearchExpanded.value = !_isSearchExpanded.value;
    if (!_isSearchExpanded.value) {
      clearSearch();
    }
    update();
  }

  // Filter by category
  void filterByCategory(String categoryId) {
    _selectedCategory.value = categoryId;
    _applyFilters();
  }

  // Filter by brand
  void filterByBrand(String brandId) {
    _selectedBrand.value = brandId;
    _applyFilters();
  }

  // Sort products
  void sortProducts(String field, {String order = 'asc'}) {
    _sortBy.value = field;
    _sortOrder.value = order;
    _applyFilters();
  }

  // Apply all filters and sorting
  void _applyFilters() {
    List<ProductModel> filtered = List.from(_products);

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((product) {
        final query = _searchQuery.value.toLowerCase();
        return product.title.toLowerCase().contains(query) ||
            product.arabicTitle.toLowerCase().contains(query) ||
            product.sku?.toLowerCase().contains(query) == true ||
            product.id.toLowerCase().contains(query);
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory.value.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.categoryId == _selectedCategory.value;
      }).toList();
    }

    // Apply brand filter
    if (_selectedBrand.value.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.brand?.id == _selectedBrand.value;
      }).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      dynamic aValue;
      dynamic bValue;

      switch (_sortBy.value) {
        case 'title':
          aValue = a.title.toLowerCase();
          bValue = b.title.toLowerCase();
          break;
        case 'price':
          aValue = a.price;
          bValue = b.price;
          break;
        case 'stock':
          aValue = a.stock;
          bValue = b.stock;
          break;
        case 'sku':
          aValue = a.sku ?? '';
          bValue = b.sku ?? '';
          break;
        default:
          aValue = a.title.toLowerCase();
          bValue = b.title.toLowerCase();
      }

      if (_sortOrder.value == 'asc') {
        return aValue.compareTo(bValue);
      } else {
        return bValue.compareTo(aValue);
      }
    });

    _filteredProducts.value = filtered;
    update();
  }

  // Select product for editing/viewing
  void selectProduct(ProductModel product) {
    _selectedProduct.value = product;
  }

  // Clear selection
  void clearSelection() {
    _selectedProduct.value = null;
  }

  // Show form for adding new product
  void showAddForm() {
    _isFormMode.value = true;
    _isEditMode.value = false;
    _selectedProduct.value = null;
    update();
  }

  // Show form for editing product
  void showEditForm(ProductModel product) {
    _isFormMode.value = true;
    _isEditMode.value = true;
    _selectedProduct.value = product;
    update();
  }

  // Hide form
  void hideForm() {
    _isFormMode.value = false;
    _isEditMode.value = false;
    _selectedProduct.value = null;
    update();
  }

  // Create new product
  Future<bool> createProduct(ProductModel product) async {
    try {
      _isLoading.value = true;
      update();

      // Create product in Firebase
      final success = await _repository.addProducts(product);

      if (success) {
        // Add to local list
        _products.add(product);
        _filteredProducts.value = _products;

        Get.snackbar(
          'Success',
          'Product created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        hideForm();
        return true;
      }

      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create product: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  // Update existing product
  Future<bool> updateProduct(ProductModel product) async {
    try {
      _isLoading.value = true;
      update();

      if (kDebugMode) {
        print('🔄 Controller: Starting updateProduct...');
        print('   - Product ID: ${product.id}');
        print('   - Product Title: ${product.title}');
        print('   - Product Price: ${product.price}');
      }

      // Update product in Firebase
      final success = await _repository.updateProduct(product);

      if (success) {
        // Update in local list
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = product;
          _applyFilters();

          if (kDebugMode) {
            print('✅ Product updated in local list at index: $index');
          }
        }

        Get.snackbar(
          'نجح التحديث',
          'تم تحديث المنتج بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        hideForm();
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating product: $e');
        print('❌ Error type: ${e.runtimeType}');
      }

      Get.snackbar(
        'خطأ',
        'فشل في تحديث المنتج: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  // Delete product
  Future<bool> deleteProduct(String productId) async {
    try {
      _isLoading.value = true;
      update();

      if (kDebugMode) {
        print('🔄 Controller: Starting deleteProduct...');
        print('   - Product ID: $productId');
      }

      // Delete product from Firebase
      final success = await _repository.deleteProduct(productId);

      if (success) {
        // Remove from local list
        _products.removeWhere((p) => p.id == productId);
        _filteredProducts.value = _products;

        if (kDebugMode) {
          print('✅ Product deleted from local list');
        }

        Get.snackbar(
          'نجح الحذف',
          'تم حذف المنتج بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting product: $e');
        print('❌ Error type: ${e.runtimeType}');
      }

      Get.snackbar(
        'خطأ',
        'فشل في حذف المنتج: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  // Toggle feature status
  Future<void> toggleFeatureStatus(String productId) async {
    try {
      final product = _products.firstWhere((p) => p.id == productId);
      final updatedProduct = ProductModel(
        id: product.id,
        title: product.title,
        arabicTitle: product.arabicTitle,
        price: product.price,
        thumbnail: product.thumbnail,
        productType: product.productType,
        stock: product.stock,
        sku: product.sku,
        brand: product.brand,
        images: product.images,
        salePrice: product.salePrice,
        isFeature: !(product.isFeature ?? false),
        description: product.description,
        arabicDescription: product.arabicDescription,
        categoryId: product.categoryId,
      );

      await updateProduct(updatedProduct);
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

  // Refresh data
  Future<void> refreshData() async {
    await loadProducts();
  }

  // Get products count
  int get productsCount => _products.length;

  // Get featured products count
  int get featuredProductsCount =>
      _products.where((p) => p.isFeature == true).length;

  // Get low stock products count
  int get lowStockProductsCount => _products.where((p) => p.stock < 10).length;

  // Validate product before saving
  bool validateProduct(ProductModel product) {
    if (product.title.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Product title is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (product.thumbnail.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Product thumbnail is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (product.price <= 0) {
      Get.snackbar(
        'Validation Error',
        'Product price must be greater than 0',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
