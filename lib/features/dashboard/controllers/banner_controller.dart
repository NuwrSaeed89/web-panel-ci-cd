import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/data/models/banner_model.dart';
import 'package:brother_admin_panel/data/repositories/banners/banner_repository.dart';
import 'package:brother_admin_panel/services/banner_image_service.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();

  BannerRepository? _repository;
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final _banners = <BannerModel>[].obs;
  final _filteredBanners = <BannerModel>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedBanner = Rxn<BannerModel>();
  final _isFormMode = false.obs;
  final _isEditMode = false.obs;
  final _isSearchExpanded = false.obs;
  final _selectedImageBase64 = Rxn<String>();
  final _selectedImageName = Rxn<String>();
  final _isUploading = false.obs;

  // New variables for Firebase Storage URLs
  final _uploadedImageUrl = Rxn<String>();
  final _isUploadingImage = false.obs;

  // Getters
  List<BannerModel> get banners => _banners;
  List<BannerModel> get filteredBanners => _filteredBanners;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  BannerModel? get selectedBanner => _selectedBanner.value;
  bool get isFormMode => _isFormMode.value;
  bool get isEditMode => _isEditMode.value;
  bool get isSearchExpanded => _isSearchExpanded.value;
  String? get selectedImageBase64 => _selectedImageBase64.value;
  String? get selectedImageName => _selectedImageName.value;
  bool get isUploading => _isUploading.value;

  // New getters for Firebase Storage URLs
  String? get uploadedImageUrl => _uploadedImageUrl.value;
  bool get isUploadingImage => _isUploadingImage.value;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('🔄 BannerController onInit called');
    }

    // Initialize repository
    try {
      _repository = Get.find<BannerRepository>();
      if (kDebugMode) {
        print('✅ BannerRepository found successfully');
      }

      // Load banners immediately
      loadBanners();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error finding BannerRepository: $e');
      }
      // Don't return here, just log the error
      // The repository will be initialized when the binding is created
    }
  }

  /// Load banners from Firestore
  Future<void> loadBanners() async {
    try {
      // Check if repository is initialized
      if (_repository == null) {
        if (kDebugMode) {
          print('⚠️ BannerRepository not initialized yet, skipping load');
        }
        return;
      }

      if (kDebugMode) {
        print('🔄 BannerController: Starting to load banners...');
      }

      _isLoading.value = true;
      update();

      final banners = await _repository!.fetchBanners();

      if (kDebugMode) {
        print('✅ BannerController: Banners loaded successfully');
        print(
            '📊 BannerController: Repository returned ${banners.length} banners');
      }

      _banners.value = banners;
      _filteredBanners.value = List.from(banners);

      _isLoading.value = false;
      update();

      if (kDebugMode) {
        print('✅ BannerController: Banners loading completed');
        print('📊 BannerController: Final state:');
        print('   - Total banners: ${_banners.length}');
        print('   - Filtered banners: ${_filteredBanners.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ BannerController: Error loading banners: $e');
      }

      _isLoading.value = false;
      update();

      Get.snackbar(
        'خطأ',
        'فشل في تحميل البنرات: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Search banners
  void searchBanners(String query) {
    _searchQuery.value = query;
    if (query.isEmpty) {
      _filteredBanners.value = _banners;
    } else {
      _filteredBanners.value = _banners.where((banner) {
        return banner.targetScreen
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            banner.image.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  // Clear search
  void clearSearch() {
    _searchQuery.value = '';
    _filteredBanners.value = _banners;
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

  // Select banner for editing/viewing
  void selectBanner(BannerModel banner) {
    _selectedBanner.value = banner;
  }

  // Clear selection
  void clearSelection() {
    _selectedBanner.value = null;
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _uploadedImageUrl.value = null;
    _isUploadingImage.value = false;
  }

  // Show form for adding new banner
  void showAddForm() {
    _isFormMode.value = true;
    _isEditMode.value = false;
    _selectedBanner.value = null;
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _uploadedImageUrl.value = null;
    _isUploadingImage.value = false;
    update();
  }

  // Show form for editing banner
  void showEditForm(BannerModel banner) {
    _isFormMode.value = true;
    _isEditMode.value = true;
    _selectedBanner.value = banner;
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _isUploadingImage.value = false;

    // Check if image is already a URL or base64
    if (banner.image.startsWith('http')) {
      _uploadedImageUrl.value = banner.image;
    } else {
      // It's base64, convert to URL in background
      _convertBase64ImageToUrl(banner.image);
    }

    update();
  }

  // Hide form
  void hideForm() {
    _isFormMode.value = false;
    _isEditMode.value = false;
    _selectedBanner.value = null;
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _uploadedImageUrl.value = null;
    _isUploadingImage.value = false;
    update();
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      _isUploadingImage.value = true;
      update();

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        if (kDebugMode) {
          print('📸 Banner image selected: ${image.name}');
        }

        // Upload to Firebase Storage
        final imageUrl = await BannerImageService.uploadBannerImageFromXFile(
          xFile: image,
        );

        _uploadedImageUrl.value = imageUrl;
        _selectedImageName.value = image.name;
        _selectedImageBase64.value = null; // Clear base64 since we have URL

        if (kDebugMode) {
          print('✅ Banner image uploaded to Firebase Storage: $imageUrl');
        }

        Get.snackbar(
          'نجح',
          'تم اختيار ورفع صورة البانر بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error picking/uploading banner image: $e');
      }
      Get.snackbar(
        'خطأ',
        'فشل في اختيار/رفع صورة البانر: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isUploadingImage.value = false;
      update();
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      _isUploadingImage.value = true;
      update();

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        if (kDebugMode) {
          print('📸 Banner camera image captured: ${image.name}');
        }

        // Upload to Firebase Storage
        final imageUrl = await BannerImageService.uploadBannerImageFromXFile(
          xFile: image,
        );

        _uploadedImageUrl.value = imageUrl;
        _selectedImageName.value = image.name;
        _selectedImageBase64.value = null; // Clear base64 since we have URL

        if (kDebugMode) {
          print(
              '✅ Banner camera image uploaded to Firebase Storage: $imageUrl');
        }

        Get.snackbar(
          'نجح',
          'تم التقاط ورفع صورة البانر بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error capturing/uploading banner camera image: $e');
      }
      Get.snackbar(
        'خطأ',
        'فشل في التقاط/رفع صورة البانر: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isUploadingImage.value = false;
      update();
    }
  }

  // Remove selected image
  void removeSelectedImage() {
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _uploadedImageUrl.value = null;
    update();
  }

  // Create new banner
  Future<bool> createBanner(BannerModel banner) async {
    try {
      if (!validateBanner(banner)) return false;

      // Check if repository is initialized
      if (_repository == null) {
        Get.snackbar(
          'خطأ',
          'نظام البنرات غير مهيأ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      _isLoading.value = true;
      _isUploading.value = true;
      update();

      // Use uploaded URL or convert base64 if needed
      String imageUrl = _uploadedImageUrl.value ?? banner.image;

      // If no URL but we have base64, convert it
      if (imageUrl.isEmpty && _selectedImageBase64.value != null) {
        imageUrl = await BannerImageService.convertBase64ToUrl(
          _selectedImageBase64.value!,
        );
      }

      final newBanner = BannerModel(
        id: '', // Will be set after creation
        image: imageUrl,
        targetScreen: banner.targetScreen,
        active: banner.active,
      );

      // Create banner in Firebase
      final newId = await _repository!.createBanner(newBanner);

      // Update the banner with the new ID from Firebase
      final createdBanner = BannerModel(
        id: newId,
        image: imageUrl,
        targetScreen: banner.targetScreen,
        active: banner.active,
      );

      // Add to local list
      _banners.add(createdBanner);
      _filteredBanners.value = _banners;

      Get.snackbar(
        'نجح',
        'تم إنشاء البانر بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      hideForm();
      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في إنشاء البانر: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
      _isUploading.value = false;
      update();
    }
  }

  // Update existing banner
  Future<bool> updateBanner(BannerModel banner) async {
    try {
      if (!validateBanner(banner)) return false;

      // Check if repository is initialized
      if (_repository == null) {
        Get.snackbar(
          'خطأ',
          'نظام البنرات غير مهيأ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      _isLoading.value = true;
      _isUploading.value = true;
      update();

      String imageUrl = _uploadedImageUrl.value ?? banner.image;

      // If no URL but we have base64, convert it
      if (imageUrl.isEmpty && _selectedImageBase64.value != null) {
        imageUrl = await BannerImageService.convertBase64ToUrl(
          _selectedImageBase64.value!,
        );
      }

      final updatedBanner = BannerModel(
        id: banner.id,
        image: imageUrl,
        targetScreen: banner.targetScreen,
        active: banner.active,
      );

      // Update banner in Firebase
      await _repository!.updateBanner(updatedBanner);

      // Update in local list
      final index = _banners.indexWhere((b) => b.id == banner.id);
      if (index != -1) {
        _banners[index] = updatedBanner;
        _filteredBanners.value = List.from(_banners);
        update();
      }

      Get.snackbar(
        'نجح التحديث',
        'تم تحديث البانر بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      hideForm();
      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحديث البانر: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      _isLoading.value = false;
      _isUploading.value = false;
      update();
    }
  }

  // Delete banner
  Future<bool> deleteBanner(String bannerId) async {
    try {
      // Check if repository is initialized
      if (_repository == null) {
        Get.snackbar(
          'خطأ',
          'نظام البنرات غير مهيأ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      _isLoading.value = true;
      update();

      // Delete banner from Firebase
      await _repository!.deleteBanner(bannerId);

      // Remove from local list
      _banners.removeWhere((b) => b.id == bannerId);
      _filteredBanners.value = _banners;

      Get.snackbar(
        'نجح',
        'تم حذف البانر بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حذف البانر: ${e.toString()}',
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

  // Toggle active status
  Future<void> toggleActiveStatus(String bannerId) async {
    try {
      final banner = _banners.firstWhere((b) => b.id == bannerId);
      final updatedBanner = BannerModel(
        id: banner.id,
        image: banner.image,
        targetScreen: banner.targetScreen,
        active: !banner.active,
      );

      await updateBanner(updatedBanner);
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تغيير حالة البانر: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadBanners();
  }

  /// تحويل صورة base64 إلى URL في Firebase Storage
  Future<void> _convertBase64ImageToUrl(String base64Image) async {
    try {
      if (kDebugMode) {
        print('🔄 Converting base64 banner image to URL...');
      }

      _isUploadingImage.value = true;
      update();

      final imageUrl = await BannerImageService.convertBase64ToUrl(
        base64Image,
      );

      _uploadedImageUrl.value = imageUrl;

      if (kDebugMode) {
        print('✅ Base64 banner image converted to URL: $imageUrl');
      }

      Get.snackbar(
        'تم التحويل',
        'تم تحويل صورة البانر إلى URL بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error converting base64 banner image: $e');
      }

      Get.snackbar(
        'خطأ',
        'فشل في تحويل صورة البانر: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isUploadingImage.value = false;
      update();
    }
  }

  // Validate banner before saving
  bool validateBanner(BannerModel banner) {
    if (banner.targetScreen.trim().isEmpty) {
      Get.snackbar(
        'خطأ في التحقق',
        'اسم الشاشة مطلوب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (banner.image.trim().isEmpty &&
        _selectedImageBase64.value == null &&
        _uploadedImageUrl.value == null) {
      Get.snackbar(
        'خطأ في التحقق',
        'صورة البانر مطلوبة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
