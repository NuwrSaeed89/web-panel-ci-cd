import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/data/models/brand_model.dart';
import 'package:brother_admin_panel/data/repositories/Brand/brand_repository.dart';
import 'package:brother_admin_panel/data/repositories/product/product_repository.dart';
import 'package:brother_admin_panel/services/brand_image_service.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  late final BrandRepository _repository;
  late final ProductRepository _productRepository;
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final _brands = <BrandModel>[].obs;
  final _filteredBrands = <BrandModel>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedBrand = Rxn<BrandModel>();
  final _isFormMode = false.obs;
  final _isEditMode = false.obs;
  final _isSearchExpanded = false.obs;

  // Image handling variables
  final _uploadedImageUrl = Rxn<String>();
  final _uploadedCoverUrl = Rxn<String>();
  final _isUploadingImage = false.obs;
  final _isUploadingCover = false.obs;
  final _selectedImageBase64 = Rxn<String>();
  final _selectedCoverBase64 = Rxn<String>();

  // Getters
  List<BrandModel> get brands => _brands;
  List<BrandModel> get filteredBrands => _filteredBrands;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  BrandModel? get selectedBrand => _selectedBrand.value;
  bool get isFormMode => _isFormMode.value;
  bool get isEditMode => _isEditMode.value;
  bool get isSearchExpanded => _isSearchExpanded.value;

  // Image getters
  String? get uploadedImageUrl => _uploadedImageUrl.value;
  String? get uploadedCoverUrl => _uploadedCoverUrl.value;
  bool get isUploadingImage => _isUploadingImage.value;
  bool get isUploadingCover => _isUploadingCover.value;
  String? get selectedImageBase64 => _selectedImageBase64.value;
  String? get selectedCoverBase64 => _selectedCoverBase64.value;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('🔄 BrandController onInit called');
    }

    // Initialize repositories
    try {
      _repository = Get.find<BrandRepository>();
      _productRepository = Get.find<ProductRepository>();
      if (kDebugMode) {
        print('✅ BrandRepository and ProductRepository found successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error finding repositories: $e');
      }
      return;
    }

    // Load brands immediately and also after a short delay
    loadBrands();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (kDebugMode) {
        print('🔄 Starting delayed loadBrands call');
      }
      if (_brands.isEmpty) {
        loadBrands();
      }
    });
  }

  // Update product counts for brands
  Future<List<BrandModel>> _updateBrandProductCounts(
      List<BrandModel> brands) async {
    try {
      if (kDebugMode) {
        print(
            '🔄 BrandController: Updating product counts for ${brands.length} brands');
      }

      final brandIds = brands.map((brand) => brand.id).toList();
      final productCounts =
          await _productRepository.getProductsCountForBrands(brandIds);

      final updatedBrands = brands.map((brand) {
        final productCount = productCounts[brand.id] ?? 0;

        if (kDebugMode) {
          print(
              '📊 Brand "${brand.name}" (${brand.id}): $productCount products');
        }

        return BrandModel(
          id: brand.id,
          name: brand.name,
          image: brand.image,
          cover: brand.cover,
          isFeature: brand.isFeature,
          productCount: productCount,
        );
      }).toList();

      if (kDebugMode) {
        print('✅ BrandController: Product counts updated successfully');
      }

      return updatedBrands;
    } catch (e) {
      if (kDebugMode) {
        print('❌ BrandController: Error updating product counts: $e');
      }
      // Return original brands if there's an error
      return brands;
    }
  }

  /// Load brands from Firestore
  Future<void> loadBrands() async {
    try {
      if (kDebugMode) {
        print('🔄 BrandController: Starting to load brands...');
        print('📊 BrandController: Current brands count: ${_brands.length}');
      }

      _isLoading.value = true;
      update();

      final brands = await _repository.fetchBrands();

      if (kDebugMode) {
        print('✅ BrandController: Brands loaded successfully from repository');
        print(
            '📊 BrandController: Repository returned ${brands.length} brands');
      }

      // Get actual product counts for each brand
      final brandsWithProductCounts = await _updateBrandProductCounts(brands);

      _brands.value = brandsWithProductCounts;
      _filteredBrands.value = List.from(brandsWithProductCounts);

      if (kDebugMode) {
        print('💾 BrandController: Brands stored in controller');
        print(
            '📊 BrandController: Controller now has ${_brands.length} brands');
        print('🔍 BrandController: Filtered brands: ${_filteredBrands.length}');

        // تفاصيل كل ماركة
        for (int i = 0; i < _brands.length; i++) {
          final brand = _brands[i];
          print('📋 BrandController - Brand ${i + 1}:');
          print('   - ID: ${brand.id}');
          print('   - Name: ${brand.name}');
          print('   - Image URL: ${brand.image}');
          print('   - Cover URL: ${brand.cover}');
          print('   - Is Feature: ${brand.isFeature}');
          print('   - Product Count: ${brand.productCount}');
          print('   ---');
        }
      }

      _isLoading.value = false;
      update();

      if (kDebugMode) {
        print('✅ BrandController: Brands loading completed');
        print('📊 BrandController: Final state:');
        print('   - Total brands: ${_brands.length}');
        print('   - Filtered brands: ${_filteredBrands.length}');
        print('   - Loading state: ${_isLoading.value}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ BrandController: Error loading brands: $e');
        print('❌ BrandController: Error type: ${e.runtimeType}');
        print('❌ BrandController: Stack trace: ${StackTrace.current}');
      }

      _isLoading.value = false;
      update();

      Get.snackbar(
        'Error',
        'Failed to load brands: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Search brands
  void searchBrands(String query) {
    _searchQuery.value = query;
    if (query.isEmpty) {
      _filteredBrands.value = _brands;
    } else {
      _filteredBrands.value = _brands.where((brand) {
        return brand.name.toLowerCase().contains(query.toLowerCase()) ||
            brand.id.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  // Clear search
  void clearSearch() {
    _searchQuery.value = '';
    _filteredBrands.value = _brands;
    update();
  }

  // Toggle search expansion
  void toggleSearchExpansion() {
    _isSearchExpanded.value = !_isSearchExpanded.value;
    if (!_isSearchExpanded.value) {
      clearSearch();
    }
    update();
  }

  // Select brand for editing/viewing
  void selectBrand(BrandModel brand) {
    _selectedBrand.value = brand;
  }

  // Clear selection
  void clearSelection() {
    _selectedBrand.value = null;
    _uploadedImageUrl.value = null;
    _uploadedCoverUrl.value = null;
    _isUploadingImage.value = false;
    _isUploadingCover.value = false;
    _selectedImageBase64.value = null;
    _selectedCoverBase64.value = null;
  }

  // Show form for adding new brand
  void showAddForm() {
    _isFormMode.value = true;
    _isEditMode.value = false;
    _selectedBrand.value = null;
    _uploadedImageUrl.value = null;
    _uploadedCoverUrl.value = null;
    _isUploadingImage.value = false;
    _isUploadingCover.value = false;
    _selectedImageBase64.value = null;
    _selectedCoverBase64.value = null;
    update();
  }

  // Show form for editing brand
  void showEditForm(BrandModel brand) {
    _isFormMode.value = true;
    _isEditMode.value = true;
    _selectedBrand.value = brand;
    _uploadedImageUrl.value = null;
    _uploadedCoverUrl.value = null;
    _isUploadingImage.value = false;
    _isUploadingCover.value = false;
    _selectedImageBase64.value = null;
    _selectedCoverBase64.value = null;

    // Check if brand has images and convert base64 to URLs if needed
    if (brand.image.isNotEmpty) {
      if (brand.image.startsWith('http')) {
        _uploadedImageUrl.value = brand.image;
      } else {
        // Convert base64 to URL in background
        _convertBase64ImageToUrl(brand.image, isCover: false);
      }
    }

    if (brand.cover.isNotEmpty) {
      if (brand.cover.startsWith('http')) {
        _uploadedCoverUrl.value = brand.cover;
      } else {
        // Convert base64 to URL in background
        _convertBase64ImageToUrl(brand.cover, isCover: true);
      }
    }

    update();
  }

  // Hide form
  void hideForm() {
    _isFormMode.value = false;
    _isEditMode.value = false;
    _selectedBrand.value = null;
    _uploadedImageUrl.value = null;
    _uploadedCoverUrl.value = null;
    _isUploadingImage.value = false;
    _isUploadingCover.value = false;
    _selectedImageBase64.value = null;
    _selectedCoverBase64.value = null;
    update();
  }

  // Create new brand
  Future<bool> createBrand(BrandModel brand) async {
    try {
      _isLoading.value = true;
      update();

      // Use uploaded URLs or convert base64 to URLs
      String imageUrl = brand.image;
      String coverUrl = brand.cover;

      // Handle image URL
      if (_uploadedImageUrl.value != null) {
        imageUrl = _uploadedImageUrl.value!;
      } else if (brand.image.isNotEmpty && !brand.image.startsWith('http')) {
        imageUrl = await BrandImageService.convertBase64ToUrl(brand.image);
      }

      // Handle cover URL
      if (_uploadedCoverUrl.value != null) {
        coverUrl = _uploadedCoverUrl.value!;
      } else if (brand.cover.isNotEmpty && !brand.cover.startsWith('http')) {
        coverUrl = await BrandImageService.convertBase64ToUrl(brand.cover);
      }

      // Create brand with URLs
      final brandWithUrls = BrandModel(
        id: brand.id,
        name: brand.name,
        image: imageUrl,
        cover: coverUrl,
        isFeature: brand.isFeature,
        productCount: brand.productCount,
      );

      // Create brand in Firebase
      final newId = await _repository.createBrand(brandWithUrls);

      // Update the brand with the new ID from Firebase
      final newBrand = BrandModel(
        id: newId,
        name: brandWithUrls.name,
        image: brandWithUrls.image,
        cover: brandWithUrls.cover,
        isFeature: brandWithUrls.isFeature,
        productCount: brandWithUrls.productCount,
      );

      // Add to local list
      _brands.add(newBrand);
      _filteredBrands.value = _brands;

      Get.snackbar(
        'نجح',
        'تم إنشاء المزود بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      hideForm();
      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في إنشاء المزود: ${e.toString()}',
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

  // Update existing brand
  Future<bool> updateBrand(BrandModel brand) async {
    try {
      _isLoading.value = true;
      update();

      if (kDebugMode) {
        print('🔄 Updating brand: ${brand.id}');
        print('🖼️ New image URL: ${brand.image}');
        print('🖼️ New cover URL: ${brand.cover}');
      }

      // Use uploaded URLs or convert base64 to URLs
      String imageUrl = brand.image;
      String coverUrl = brand.cover;

      // Handle image URL
      if (_uploadedImageUrl.value != null) {
        imageUrl = _uploadedImageUrl.value!;
      } else if (brand.image.isNotEmpty && !brand.image.startsWith('http')) {
        imageUrl = await BrandImageService.convertBase64ToUrl(brand.image);
      }

      // Handle cover URL
      if (_uploadedCoverUrl.value != null) {
        coverUrl = _uploadedCoverUrl.value!;
      } else if (brand.cover.isNotEmpty && !brand.cover.startsWith('http')) {
        coverUrl = await BrandImageService.convertBase64ToUrl(brand.cover);
      }

      // Create brand with URLs
      final brandWithUrls = BrandModel(
        id: brand.id,
        name: brand.name,
        image: imageUrl,
        cover: coverUrl,
        isFeature: brand.isFeature,
        productCount: brand.productCount,
      );

      // Update brand in Firebase
      await _repository.updateBrand(brandWithUrls);

      // Update in local list
      final index = _brands.indexWhere((b) => b.id == brand.id);
      if (index != -1) {
        _brands[index] = brandWithUrls;

        if (kDebugMode) {
          print('✅ Brand updated in local list at index: $index');
        }

        // إعادة تطبيق البحث إذا كان هناك بحث نشط
        if (_searchQuery.value.isNotEmpty) {
          searchBrands(_searchQuery.value);
        } else {
          _filteredBrands.value = List.from(_brands);
        }

        update();
      }

      Get.snackbar(
        'نجح التحديث',
        'تم تحديث المزود بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      hideForm();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating brand: $e');
      }

      Get.snackbar(
        'خطأ',
        'فشل في تحديث المزود: ${e.toString()}',
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

  // Delete brand
  Future<bool> deleteBrand(String brandId) async {
    try {
      _isLoading.value = true;
      update();

      // Delete brand from Firebase
      await _repository.deleteBrand(brandId);

      // Remove from local list
      _brands.removeWhere((b) => b.id == brandId);
      _filteredBrands.value = _brands;

      Get.snackbar(
        'Success',
        'Brand deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete brand: ${e.toString()}',
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
  Future<void> toggleFeatureStatus(String brandId) async {
    try {
      final brand = _brands.firstWhere((b) => b.id == brandId);
      final updatedBrand = BrandModel(
        id: brand.id,
        name: brand.name,
        image: brand.image,
        cover: brand.cover,
        isFeature: !(brand.isFeature ?? false),
        productCount: brand.productCount,
      );

      await updateBrand(updatedBrand);
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
    await loadBrands();
  }

  // Update product count for a specific brand
  Future<void> updateBrandProductCount(String brandId) async {
    try {
      final productCount =
          await _productRepository.getProductsCountForBrand(brandId);

      // Update the brand in the local list
      final brandIndex = _brands.indexWhere((brand) => brand.id == brandId);
      if (brandIndex != -1) {
        final brand = _brands[brandIndex];
        _brands[brandIndex] = BrandModel(
          id: brand.id,
          name: brand.name,
          image: brand.image,
          cover: brand.cover,
          isFeature: brand.isFeature,
          productCount: productCount,
        );

        // Update filtered brands if this brand is visible
        final filteredIndex =
            _filteredBrands.indexWhere((brand) => brand.id == brandId);
        if (filteredIndex != -1) {
          _filteredBrands[filteredIndex] = _brands[brandIndex];
        }

        update();

        if (kDebugMode) {
          print(
              '✅ BrandController: Updated product count for brand $brandId to $productCount');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            '❌ BrandController: Error updating product count for brand $brandId: $e');
      }
    }
  }

  // Get brands count
  Future<int> getBrandsCount() async {
    try {
      return await _repository.getBrandsCount();
    } catch (e) {
      return _brands.length;
    }
  }

  // Validate brand before saving
  bool validateBrand(BrandModel brand) {
    if (brand.name.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Brand name is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (brand.image.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Brand image is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // Image handling methods
  Future<void> pickImageFromGallery({bool isCover = false}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kDebugMode) {
          print('🖼️ Brand image picked from gallery: ${pickedFile.name}');
        }

        if (isCover) {
          _isUploadingCover.value = true;
        } else {
          _isUploadingImage.value = true;
        }
        update();

        final imageUrl = await BrandImageService.uploadBrandImageFromXFile(
          xFile: pickedFile,
        );

        if (isCover) {
          _uploadedCoverUrl.value = imageUrl;
          _selectedCoverBase64.value = null;
        } else {
          _uploadedImageUrl.value = imageUrl;
          _selectedImageBase64.value = null;
        }

        if (kDebugMode) {
          print('✅ Brand image uploaded successfully: $imageUrl');
        }

        Get.snackbar(
          'نجح الرفع',
          'تم رفع صورة المزود بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error picking brand image: $e');
      }

      Get.snackbar(
        'خطأ في رفع الصورة',
        'فشل في رفع صورة المزود: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (isCover) {
        _isUploadingCover.value = false;
      } else {
        _isUploadingImage.value = false;
      }
      update();
    }
  }

  Future<void> pickImageFromCamera({bool isCover = false}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kDebugMode) {
          print('📷 Brand image picked from camera: ${pickedFile.name}');
        }

        if (isCover) {
          _isUploadingCover.value = true;
        } else {
          _isUploadingImage.value = true;
        }
        update();

        final imageUrl = await BrandImageService.uploadBrandImageFromXFile(
          xFile: pickedFile,
        );

        if (isCover) {
          _uploadedCoverUrl.value = imageUrl;
          _selectedCoverBase64.value = null;
        } else {
          _uploadedImageUrl.value = imageUrl;
          _selectedImageBase64.value = null;
        }

        if (kDebugMode) {
          print('✅ Brand image uploaded successfully: $imageUrl');
        }

        Get.snackbar(
          'نجح الرفع',
          'تم رفع صورة المزود بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error picking brand image: $e');
      }

      Get.snackbar(
        'خطأ في رفع الصورة',
        'فشل في رفع صورة المزود: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (isCover) {
        _isUploadingCover.value = false;
      } else {
        _isUploadingImage.value = false;
      }
      update();
    }
  }

  void removeSelectedImage({bool isCover = false}) {
    if (isCover) {
      _uploadedCoverUrl.value = null;
      _selectedCoverBase64.value = null;
    } else {
      _uploadedImageUrl.value = null;
      _selectedImageBase64.value = null;
    }
    update();
  }

  Future<void> _convertBase64ImageToUrl(String base64Image,
      {required bool isCover}) async {
    try {
      if (kDebugMode) {
        print('🔄 Converting base64 brand image to URL...');
      }

      _isUploadingImage.value = true;
      update();

      final imageUrl = await BrandImageService.convertBase64ToUrl(base64Image);

      if (isCover) {
        _uploadedCoverUrl.value = imageUrl;
      } else {
        _uploadedImageUrl.value = imageUrl;
      }

      if (kDebugMode) {
        print('✅ Base64 brand image converted to URL: $imageUrl');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error converting base64 brand image to URL: $e');
      }
    } finally {
      _isUploadingImage.value = false;
      update();
    }
  }
}
