import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/data/models/gallery_model.dart';
import 'package:brother_admin_panel/data/models/album_model.dart';
import 'package:brother_admin_panel/data/repositories/gallery/gallery_repository.dart';
import 'package:brother_admin_panel/data/repositories/album/album_repository.dart';
import 'package:brother_admin_panel/data/repositories/gallery_album/gallery_album_repository.dart';
import 'package:brother_admin_panel/services/studio_image_service.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class GalleryController extends GetxController {
  static GalleryController get instance => Get.find();

  GalleryRepository? _galleryRepository;
  AlbumRepository? _albumRepository;
  GalleryAlbumRepository? _galleryAlbumRepository;
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final _galleryImages = <GalleryModel>[].obs;
  final _filteredImages = <GalleryModel>[].obs;
  final _albums = <AlbumModel>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedImage = Rxn<GalleryModel>();
  final _isFormMode = false.obs;
  final _isEditMode = false.obs;
  final _selectedImageBase64 = Rxn<String>();
  final _selectedImageName = Rxn<String>();
  final _selectedAlbums = <String>[].obs; // Selected album IDs
  final _isFeature = false.obs;

  // New variables for Firebase Storage URLs
  final _uploadedImageUrl = Rxn<String>();
  final _isUploadingImage = false.obs;

  // Getters
  List<GalleryModel> get galleryImages => _galleryImages;
  List<GalleryModel> get filteredImages => _filteredImages;
  List<AlbumModel> get albums => _albums;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  GalleryModel? get selectedImage => _selectedImage.value;
  bool get isFormMode => _isFormMode.value;
  bool get isEditMode => _isEditMode.value;
  String? get selectedImageBase64 => _selectedImageBase64.value;
  String? get selectedImageName => _selectedImageName.value;
  List<String> get selectedAlbums => _selectedAlbums;
  bool get isFeature => _isFeature.value;

  // New getters for Firebase Storage URLs
  String? get uploadedImageUrl => _uploadedImageUrl.value;
  bool get isUploadingImage => _isUploadingImage.value;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('🔄 GalleryController onInit called');
    }

    // Initialize repositories
    try {
      _galleryRepository = Get.find<GalleryRepository>();
      _albumRepository = Get.find<AlbumRepository>();
      _galleryAlbumRepository = Get.find<GalleryAlbumRepository>();

      if (kDebugMode) {
        print('✅ All repositories found successfully');
      }

      // Load data immediately
      loadData();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error finding repositories: $e');
      }
    }
  }

  /// Load all data
  Future<void> loadData() async {
    await Future.wait([
      loadGalleryImages(),
      loadAlbums(),
    ]);
  }

  /// Load gallery images from Firestore
  Future<void> loadGalleryImages() async {
    try {
      if (_galleryRepository == null) {
        if (kDebugMode) {
          print('⚠️ GalleryRepository not initialized yet, skipping load');
        }
        return;
      }

      if (kDebugMode) {
        print('🔄 GalleryController: Starting to load gallery images...');
      }

      _isLoading.value = true;
      update();

      final images = await _galleryRepository!.getAllGalleryImages();

      if (kDebugMode) {
        print('✅ GalleryController: Gallery images loaded successfully');
        print(
            '📊 GalleryController: Repository returned ${images.length} images');
      }

      _galleryImages.value = images;
      _filteredImages.value = List.from(images);

      _isLoading.value = false;
      update();

      if (kDebugMode) {
        print('✅ GalleryController: Gallery images loading completed');
        print('📊 GalleryController: Final state:');
        print('   - Total images: ${_galleryImages.length}');
        print('   - Filtered images: ${_filteredImages.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ GalleryController: Error loading gallery images: $e');
      }

      _isLoading.value = false;
      update();

      Get.snackbar(
        'خطأ',
        'فشل في تحميل الصور: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Load albums from Firestore
  Future<void> loadAlbums() async {
    try {
      if (_albumRepository == null) {
        if (kDebugMode) {
          print('⚠️ AlbumRepository not initialized yet, skipping load');
        }
        return;
      }

      final albums = await _albumRepository!.getAllAlbums();
      _albums.value = albums;

      if (kDebugMode) {
        print('✅ GalleryController: Albums loaded successfully');
        print('📊 GalleryController: ${albums.length} albums loaded');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ GalleryController: Error loading albums: $e');
      }
    }
  }

  // Search images
  void searchImages(String query) {
    _searchQuery.value = query;
    if (query.isEmpty) {
      _filteredImages.value = _galleryImages;
    } else {
      _filteredImages.value = _galleryImages.where((image) {
        return (image.name?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (image.arabicName?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (image.description?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (image.arabicDescription
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false);
      }).toList();
    }
    update();
  }

  // Clear search
  void clearSearch() {
    _searchQuery.value = '';
    _filteredImages.value = _galleryImages;
    update();
  }

  // Select image for editing/viewing
  void selectImage(GalleryModel image) {
    _selectedImage.value = image;
  }

  // Clear selection
  void clearSelection() {
    _selectedImage.value = null;
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _selectedAlbums.clear();
    _isFeature.value = false;
    _uploadedImageUrl.value = null;
    _isUploadingImage.value = false;
  }

  // Show form for adding new image
  void showAddForm() {
    _isFormMode.value = true;
    _isEditMode.value = false;
    _selectedImage.value = null;
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _selectedAlbums.clear();
    _isFeature.value = false;
    _uploadedImageUrl.value = null;
    _isUploadingImage.value = false;
    update();
  }

  // Show form for editing image
  void showEditForm(GalleryModel image) async {
    _isFormMode.value = true;
    _isEditMode.value = true;
    _selectedImage.value = image;
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _isFeature.value = image.isFeature;
    _isUploadingImage.value = false;

    // Check if image is already a URL or base64
    if (image.image.startsWith('http')) {
      _uploadedImageUrl.value = image.image;
    } else {
      // It's base64, convert to URL in background
      _convertBase64ImageToUrl(image.image);
    }

    // Load associated albums for this image
    if (_galleryAlbumRepository != null) {
      try {
        final albumIds =
            await _galleryAlbumRepository!.getAlbumsForImage(image.id);
        _selectedAlbums.value = albumIds;
        if (kDebugMode) {
          print('✅ Loaded ${albumIds.length} albums for image: ${image.id}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error loading albums for image: $e');
        }
        _selectedAlbums.clear();
      }
    }

    update();
  }

  // Hide form
  void hideForm() {
    _isFormMode.value = false;
    _isEditMode.value = false;
    _selectedImage.value = null;
    _selectedImageBase64.value = null;
    _selectedImageName.value = null;
    _selectedAlbums.clear();
    _isFeature.value = false;
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
          print('📸 Gallery image selected: ${image.name}');
        }

        // Upload to Firebase Storage
        final imageUrl = await StudioImageService.uploadGalleryImageFromXFile(
          xFile: image,
        );

        _uploadedImageUrl.value = imageUrl;
        _selectedImageName.value = image.name;
        _selectedImageBase64.value = null; // Clear base64 since we have URL

        if (kDebugMode) {
          print('✅ Gallery image uploaded to Firebase Storage: $imageUrl');
        }

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
        print('❌ Error picking/uploading gallery image: $e');
      }
      Get.snackbar(
        'خطأ',
        'فشل في اختيار/رفع الصورة: $e',
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
          print('📸 Camera image captured: ${image.name}');
        }

        // Upload to Firebase Storage
        final imageUrl = await StudioImageService.uploadGalleryImageFromXFile(
          xFile: image,
        );

        _uploadedImageUrl.value = imageUrl;
        _selectedImageName.value = image.name;
        _selectedImageBase64.value = null; // Clear base64 since we have URL

        if (kDebugMode) {
          print('✅ Camera image uploaded to Firebase Storage: $imageUrl');
        }

        Get.snackbar(
          'نجح',
          'تم التقاط ورفع الصورة بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error capturing/uploading camera image: $e');
      }
      Get.snackbar(
        'خطأ',
        'فشل في التقاط/رفع الصورة: $e',
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

  // Toggle album selection
  void toggleAlbumSelection(String albumId) {
    if (_selectedAlbums.contains(albumId)) {
      _selectedAlbums.remove(albumId);
    } else {
      _selectedAlbums.add(albumId);
    }
    update();
  }

  // Toggle feature status
  void toggleFeatureStatus() {
    _isFeature.value = !_isFeature.value;
    update();
  }

  /// تحويل صورة base64 إلى URL في Firebase Storage
  Future<void> _convertBase64ImageToUrl(String base64Image) async {
    try {
      if (kDebugMode) {
        print('🔄 Converting base64 gallery image to URL...');
      }

      _isUploadingImage.value = true;
      update();

      final imageUrl = await StudioImageService.convertBase64ToUrl(
        base64Image,
        folder: 'gallery',
      );

      _uploadedImageUrl.value = imageUrl;

      if (kDebugMode) {
        print('✅ Base64 gallery image converted to URL: $imageUrl');
      }

      Get.snackbar(
        'تم التحويل',
        'تم تحويل الصورة إلى URL بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error converting base64 gallery image: $e');
      }

      Get.snackbar(
        'خطأ',
        'فشل في تحويل الصورة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isUploadingImage.value = false;
      update();
    }
  }

  // Create new gallery image
  Future<bool> createGalleryImage({
    required String name,
    required String arabicName,
    String? description,
    String? arabicDescription,
  }) async {
    try {
      if (!validateImageData(name, arabicName)) return false;

      // Check if repositories are initialized
      if (_galleryRepository == null || _galleryAlbumRepository == null) {
        Get.snackbar(
          'خطأ',
          'نظام الصور غير مهيأ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      _isLoading.value = true;
      update();

      // Use uploaded URL or convert base64 if needed
      String imageUrl = _uploadedImageUrl.value ?? '';

      // If no URL but we have base64, convert it
      if (imageUrl.isEmpty && _selectedImageBase64.value != null) {
        imageUrl = await StudioImageService.convertBase64ToUrl(
          _selectedImageBase64.value!,
          folder: 'gallery',
        );
      }

      if (imageUrl.isEmpty) {
        Get.snackbar(
          'خطأ',
          'يجب اختيار صورة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return false;
      }

      // Create gallery image using repository
      final newImage = GalleryModel(
        id: '', // سيتم تعيينه من قبل Repository
        image: imageUrl,
        albumId: _selectedAlbums.isNotEmpty ? _selectedAlbums.first : '',
        isFeature: _isFeature.value,
        name: name,
        arabicName: arabicName,
        description: description,
        arabicDescription: arabicDescription,
      );

      // Save to Firestore and get the actual ID
      final imageId = await _galleryRepository!.createGalleryImage(newImage);

      // Update the image with the actual ID
      final savedImage = GalleryModel(
        id: imageId,
        image: imageUrl,
        albumId: _selectedAlbums.isNotEmpty ? _selectedAlbums.first : '',
        isFeature: _isFeature.value,
        name: name,
        arabicName: arabicName,
        description: description,
        arabicDescription: arabicDescription,
      );

      // Add to local list
      _galleryImages.add(savedImage);
      _filteredImages.value = _galleryImages;

      // Create relationships with selected albums
      for (String albumId in _selectedAlbums) {
        await _galleryAlbumRepository!.addImageToAlbum(imageId, albumId);
      }

      Get.snackbar(
        'نجح',
        'تم إنشاء الصورة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      hideForm();
      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في إنشاء الصورة: ${e.toString()}',
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

  // Update existing gallery image
  Future<bool> updateGalleryImage({
    required String name,
    required String arabicName,
    String? description,
    String? arabicDescription,
  }) async {
    try {
      if (!validateImageData(name, arabicName)) return false;

      // Check if repositories are initialized
      if (_galleryRepository == null || _galleryAlbumRepository == null) {
        Get.snackbar(
          'خطأ',
          'نظام الصور غير مهيأ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      _isLoading.value = true;
      update();

      String imageUrl =
          _uploadedImageUrl.value ?? _selectedImage.value?.image ?? '';

      // If no URL but we have base64, convert it
      if (imageUrl.isEmpty && _selectedImageBase64.value != null) {
        imageUrl = await StudioImageService.convertBase64ToUrl(
          _selectedImageBase64.value!,
          folder: 'gallery',
        );
      }

      final updatedImage = GalleryModel(
        id: _selectedImage.value?.id ?? '',
        image: imageUrl,
        albumId: _selectedAlbums.isNotEmpty ? _selectedAlbums.first : '',
        isFeature: _isFeature.value,
        name: name,
        arabicName: arabicName,
        description: description,
        arabicDescription: arabicDescription,
      );

      // Update in Firestore
      if (_selectedImage.value != null) {
        await _galleryRepository!
            .updateGalleryImage(_selectedImage.value!.id, updatedImage);

        // Update in local list
        final index = _galleryImages
            .indexWhere((img) => img.id == _selectedImage.value?.id);
        if (index != -1) {
          _galleryImages[index] = updatedImage;
          _filteredImages.value = List.from(_galleryImages);
          update();
        }

        // Update relationships with albums
        // Remove all existing relationships
        await _galleryAlbumRepository!
            .removeAllRelationshipsForImage(_selectedImage.value!.id);

        // Add new relationships
        for (String albumId in _selectedAlbums) {
          await _galleryAlbumRepository!
              .addImageToAlbum(_selectedImage.value!.id, albumId);
        }
      }

      Get.snackbar(
        'نجح التحديث',
        'تم تحديث الصورة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      hideForm();
      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحديث الصورة: ${e.toString()}',
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

  // Delete gallery image
  Future<bool> deleteGalleryImage(String imageId) async {
    try {
      // Check if repository is initialized
      if (_galleryAlbumRepository == null) {
        Get.snackbar(
          'خطأ',
          'نظام الصور غير مهيأ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      _isLoading.value = true;
      update();

      // Remove from Firestore
      await _galleryRepository!.deleteGalleryImage(imageId);

      // Remove all relationships
      await _galleryAlbumRepository!.removeAllRelationshipsForImage(imageId);

      // Remove from local list
      _galleryImages.removeWhere((img) => img.id == imageId);
      _filteredImages.value = _galleryImages;

      Get.snackbar(
        'نجح',
        'تم حذف الصورة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حذف الصورة: ${e.toString()}',
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

  // Toggle feature status for existing image
  Future<void> toggleImageFeatureStatus(String imageId) async {
    try {
      final image = _galleryImages.firstWhere((img) => img.id == imageId);
      final updatedImage = GalleryModel(
        id: image.id,
        image: image.image,
        albumId: image.albumId,
        isFeature: !image.isFeature,
        name: image.name,
        arabicName: image.arabicName,
        description: image.description,
        arabicDescription: image.arabicDescription,
      );

      // Update in local list
      final index = _galleryImages.indexWhere((img) => img.id == imageId);
      if (index != -1) {
        _galleryImages[index] = updatedImage;
        _filteredImages.value = List.from(_galleryImages);
        update();
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تغيير حالة الصورة: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadData();
  }

  // Validate image data before saving
  bool validateImageData(String name, String arabicName) {
    if (name.trim().isEmpty) {
      Get.snackbar(
        'خطأ في التحقق',
        'اسم الصورة مطلوب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (arabicName.trim().isEmpty) {
      Get.snackbar(
        'خطأ في التحقق',
        'الاسم العربي للصورة مطلوب',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (_uploadedImageUrl.value == null &&
        _selectedImageBase64.value == null &&
        _selectedImage.value == null) {
      Get.snackbar(
        'خطأ في التحقق',
        'يجب اختيار صورة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
