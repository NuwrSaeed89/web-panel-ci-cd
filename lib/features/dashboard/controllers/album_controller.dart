import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/data/models/album_model.dart';
import 'package:brother_admin_panel/data/repositories/album/album_repository.dart';
import 'package:brother_admin_panel/services/studio_image_service.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class AlbumController extends GetxController {
  static AlbumController get instance => Get.find();

  AlbumRepository? _repository;
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final _albums = <AlbumModel>[].obs;
  final _filteredAlbums = <AlbumModel>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedAlbum = Rxn<AlbumModel>();
  final _isFormMode = false.obs;
  final _isEditMode = false.obs;
  final _selectedImageBase64 = Rxn<String>();
  final _selectedImageName = Rxn<String>();

  // New variables for Firebase Storage URLs
  final _uploadedImageUrl = Rxn<String>();
  final _isUploadingImage = false.obs;

  // Getters
  List<AlbumModel> get albums => _albums;
  List<AlbumModel> get filteredAlbums => _filteredAlbums;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  AlbumModel? get selectedAlbum => _selectedAlbum.value;
  bool get isFormMode => _isFormMode.value;
  bool get isEditMode => _isEditMode.value;
  String? get selectedImageBase64 => _selectedImageBase64.value;
  String? get selectedImageName => _selectedImageName.value;

  // New getters for Firebase Storage URLs
  String? get uploadedImageUrl => _uploadedImageUrl.value;
  bool get isUploadingImage => _isUploadingImage.value;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('🔄 AlbumController onInit called');
    }

    // Initialize repository
    try {
      _repository = Get.find<AlbumRepository>();
      if (kDebugMode) {
        print('✅ AlbumRepository found successfully');
      }

      // Load albums immediately
      loadAlbums();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error finding AlbumRepository: $e');
      }
    }
  }

  /// Load albums from Firestore
  Future<void> loadAlbums() async {
    try {
      // Check if repository is initialized
      if (_repository == null) {
        if (kDebugMode) {
          print('⚠️ AlbumRepository not initialized yet, skipping load');
        }
        return;
      }

      if (kDebugMode) {
        print('🔄 AlbumController: Starting to load albums...');
      }

      _isLoading.value = true;
      update();

      final albums = await _repository!.getAllAlbums();

      if (kDebugMode) {
        print('✅ AlbumController: Albums loaded successfully');
        print(
            '📊 AlbumController: Repository returned ${albums.length} albums');
      }

      _albums.value = albums;
      _filteredAlbums.value = List.from(albums);

      _isLoading.value = false;
      update();

      if (kDebugMode) {
        print('✅ AlbumController: Albums loading completed');
        print('📊 AlbumController: Final state:');
        print('   - Total albums: ${_albums.length}');
        print('   - Filtered albums: ${_filteredAlbums.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ AlbumController: Error loading albums: $e');
      }

      _isLoading.value = false;
      update();

      Get.snackbar(
        'خطأ',
        'فشل في تحميل الألبومات: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Search albums
  void searchAlbums(String query) {
    _searchQuery.value = query;
    if (query.isEmpty) {
      _filteredAlbums.value = _albums;
    } else {
      _filteredAlbums.value = _albums.where((album) {
        return album.name.toLowerCase().contains(query.toLowerCase()) ||
            album.arabicName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  // Clear search
  void clearSearch() {
    _searchQuery.value = '';
    _filteredAlbums.value = _albums;
    update();
  }

  // Select album for editing/viewing
  void selectAlbum(AlbumModel album) {
    _selectedAlbum.value = album;
  }

  // Clear selection
  void clearSelection() {
    _selectedAlbum.value = null;
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _uploadedImageUrl.value = null;
    _isUploadingImage.value = false;
  }

  // Show form for adding new album
  void showAddForm() {
    _isFormMode.value = true;
    _isEditMode.value = false;
    _selectedAlbum.value = null;
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _uploadedImageUrl.value = null;
    _isUploadingImage.value = false;
    update();
  }

  // Show form for editing album
  void showEditForm(AlbumModel album) {
    _isFormMode.value = true;
    _isEditMode.value = true;
    _selectedAlbum.value = album;
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _isUploadingImage.value = false;

    // Check if image is already a URL or base64
    if (album.image != null && album.image!.startsWith('http')) {
      _uploadedImageUrl.value = album.image;
    } else if (album.image != null) {
      // It's base64, convert to URL in background
      _convertBase64ImageToUrl(album.image!);
    }

    update();
  }

  // Hide form
  void hideForm() {
    _isFormMode.value = false;
    _isEditMode.value = false;
    _selectedAlbum.value = null;
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
          print('📸 Album image selected: ${image.name}');
        }

        // Upload to Firebase Storage
        final imageUrl = await StudioImageService.uploadAlbumImageFromXFile(
          xFile: image,
        );

        _uploadedImageUrl.value = imageUrl;
        _selectedImageName.value = image.name;
        _selectedImageBase64.value = null; // Clear base64 since we have URL

        if (kDebugMode) {
          print('✅ Album image uploaded to Firebase Storage: $imageUrl');
        }

        Get.snackbar(
          'نجح',
          'تم اختيار ورفع صورة الألبوم بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error picking/uploading album image: $e');
      }
      Get.snackbar(
        'خطأ',
        'فشل في اختيار/رفع صورة الألبوم: $e',
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
          print('📸 Album camera image captured: ${image.name}');
        }

        // Upload to Firebase Storage
        final imageUrl = await StudioImageService.uploadAlbumImageFromXFile(
          xFile: image,
        );

        _uploadedImageUrl.value = imageUrl;
        _selectedImageName.value = image.name;
        _selectedImageBase64.value = null; // Clear base64 since we have URL

        if (kDebugMode) {
          print('✅ Album camera image uploaded to Firebase Storage: $imageUrl');
        }

        Get.snackbar(
          'نجح',
          'تم التقاط ورفع صورة الألبوم بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error capturing/uploading album camera image: $e');
      }
      Get.snackbar(
        'خطأ',
        'فشل في التقاط/رفع صورة الألبوم: $e',
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

  // Create new album
  Future<bool> createAlbum(AlbumModel album) async {
    try {
      if (!validateAlbum(album)) return false;

      // Check if repository is initialized
      if (_repository == null) {
        Get.snackbar(
          'خطأ',
          'نظام الألبومات غير مهيأ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      _isLoading.value = true;
      update();

      // Use uploaded URL or convert base64 if needed
      String imageUrl = _uploadedImageUrl.value ?? album.image ?? '';

      // If no URL but we have base64, convert it
      if (imageUrl.isEmpty && _selectedImageBase64.value != null) {
        imageUrl = await StudioImageService.convertBase64ToUrl(
          _selectedImageBase64.value!,
          folder: 'albums',
        );
      }

      final newAlbum = AlbumModel(
        id: '', // Will be set after creation
        name: album.name,
        arabicName: album.arabicName,
        image: imageUrl,
        isFeature: album.isFeature,
      );

      // Create album in Firebase
      final newId = await _repository!.createAlbum(newAlbum);

      // Update the album with the new ID from Firebase
      final createdAlbum = AlbumModel(
        id: newId,
        name: album.name,
        arabicName: album.arabicName,
        image: imageUrl,
        isFeature: album.isFeature,
      );

      // Add to local list
      _albums.add(createdAlbum);
      _filteredAlbums.value = _albums;

      Get.snackbar(
        'نجح',
        'تم إنشاء الألبوم بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      hideForm();
      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في إنشاء الألبوم: ${e.toString()}',
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

  // Update existing album
  Future<bool> updateAlbum(AlbumModel album) async {
    try {
      if (!validateAlbum(album)) return false;

      // Check if repository is initialized
      if (_repository == null) {
        Get.snackbar(
          'خطأ',
          'نظام الألبومات غير مهيأ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      _isLoading.value = true;
      update();

      String imageUrl = _uploadedImageUrl.value ?? album.image ?? '';

      // If no URL but we have base64, convert it
      if (imageUrl.isEmpty && _selectedImageBase64.value != null) {
        imageUrl = await StudioImageService.convertBase64ToUrl(
          _selectedImageBase64.value!,
          folder: 'albums',
        );
      }

      final updatedAlbum = AlbumModel(
        id: album.id,
        name: album.name,
        arabicName: album.arabicName,
        image: imageUrl,
        isFeature: album.isFeature,
      );

      // Update album in Firebase
      await _repository!.updateAlbum(updatedAlbum);

      // Update in local list
      final index = _albums.indexWhere((a) => a.id == album.id);
      if (index != -1) {
        _albums[index] = updatedAlbum;
        _filteredAlbums.value = List.from(_albums);
        update();
      }

      Get.snackbar(
        'نجح التحديث',
        'تم تحديث الألبوم بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      hideForm();
      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحديث الألبوم: ${e.toString()}',
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

  // Delete album
  Future<bool> deleteAlbum(String albumId) async {
    try {
      // Check if repository is initialized
      if (_repository == null) {
        Get.snackbar(
          'خطأ',
          'نظام الألبومات غير مهيأ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      _isLoading.value = true;
      update();

      // Delete album from Firebase
      await _repository!.deleteAlbum(albumId);

      // Remove from local list
      _albums.removeWhere((a) => a.id == albumId);
      _filteredAlbums.value = _albums;

      Get.snackbar(
        'نجح',
        'تم حذف الألبوم بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حذف الألبوم: ${e.toString()}',
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
  Future<void> toggleFeatureStatus(String albumId) async {
    try {
      final album = _albums.firstWhere((a) => a.id == albumId);
      final updatedAlbum = AlbumModel(
        id: album.id,
        name: album.name,
        arabicName: album.arabicName,
        image: album.image,
        isFeature: !album.isFeature,
      );

      await updateAlbum(updatedAlbum);
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تغيير حالة الألبوم: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadAlbums();
  }

  /// تحويل صورة base64 إلى URL في Firebase Storage
  Future<void> _convertBase64ImageToUrl(String base64Image) async {
    try {
      if (kDebugMode) {
        print('🔄 Converting base64 album image to URL...');
      }

      _isUploadingImage.value = true;
      update();

      final imageUrl = await StudioImageService.convertBase64ToUrl(
        base64Image,
        folder: 'albums',
      );

      _uploadedImageUrl.value = imageUrl;

      if (kDebugMode) {
        print('✅ Base64 album image converted to URL: $imageUrl');
      }

      Get.snackbar(
        'تم التحويل',
        'تم تحويل صورة الألبوم إلى URL بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error converting base64 album image: $e');
      }

      Get.snackbar(
        'خطأ',
        'فشل في تحويل صورة الألبوم: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isUploadingImage.value = false;
      update();
    }
  }

  // Validate album before saving
  bool validateAlbum(AlbumModel album) {
    if (album.name.trim().isEmpty) {
      Get.snackbar(
        'خطأ في التحقق',
        'اسم الألبوم مطلوب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (album.arabicName.trim().isEmpty) {
      Get.snackbar(
        'خطأ في التحقق',
        'الاسم العربي للألبوم مطلوب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
