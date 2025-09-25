import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brother_admin_panel/data/models/blog_model.dart';
import 'package:brother_admin_panel/data/repositories/blog/blog_repository.dart';
import 'package:brother_admin_panel/services/firebase_storage_service.dart';
import 'package:brother_admin_panel/utils/helpers/snackbar_helper.dart';

class BlogController extends GetxController {
  static BlogController get instance => Get.find();

  // Observable variables
  final RxList<BlogModel> blogs = <BlogModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFormMode = false.obs;
  final RxBool isEditMode = false.obs;
  final RxBool isUploading = false.obs;
  final RxBool isActive = true.obs;
  final RxString searchQuery = ''.obs;

  // Form controllers
  final titleController = TextEditingController();
  final arabicTitleController = TextEditingController();
  final authorController = TextEditingController();
  final arabicAuthorController = TextEditingController();
  final detailsController = TextEditingController();
  final arabicDetailsController = TextEditingController();

  // Selected images
  final RxList<String> selectedImages = <String>[].obs;
  final RxList<String> uploadedImages = <String>[].obs;
  final RxList<Uint8List> selectedImageBytes = <Uint8List>[].obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxBool isPreparing = false.obs;
  BlogModel? selectedBlog;

  // Repository and Services
  final BlogRepository _blogRepository = BlogRepository();
  final ImagePicker _imagePicker = ImagePicker();
  final Rx<FirebaseStorageService?> _storageService =
      Rx<FirebaseStorageService?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    fetchBlogs();
  }

  /// تهيئة الخدمات
  void _initializeServices() {
    try {
      _storageService.value = Get.find<FirebaseStorageService>();
      if (kDebugMode) {
        print(
            '✅ BlogController: FirebaseStorageService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            '❌ BlogController: Failed to initialize FirebaseStorageService: $e');
      }
      _storageService.value = null;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    arabicTitleController.dispose();
    authorController.dispose();
    arabicAuthorController.dispose();
    detailsController.dispose();
    arabicDetailsController.dispose();
    super.onClose();
  }

  /// جلب جميع المقالات
  Future<void> fetchBlogs() async {
    try {
      isLoading.value = true;
      final fetchedBlogs = await _blogRepository.fetchBlog();
      blogs.value = fetchedBlogs;
    } catch (e) {
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في جلب المقالات: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// إضافة مقال جديد
  Future<void> addBlog() async {
    try {
      if (titleController.text.trim().isEmpty ||
          arabicTitleController.text.trim().isEmpty) {
        SnackbarHelper.showError(
          title: 'خطأ',
          message: 'يرجى إدخال عنوان المقال باللغتين',
        );
        return;
      }

      isUploading.value = true;

      // رفع الصور المختارة إلى Firebase Storage
      List<String> blogImages = [];
      if (selectedImages.isNotEmpty) {
        blogImages = await uploadSelectedImages();
      }

      // استخدام "Brother Creative" كقيمة افتراضية إذا كان اسم الكاتب فارغ
      final authorName = authorController.text.trim().isEmpty
          ? "Brother Creative"
          : authorController.text.trim();
      final arabicAuthorName = arabicAuthorController.text.trim().isEmpty
          ? "براذر كرييتف"
          : arabicAuthorController.text.trim();

      final blog = BlogModel(
        DateTime.now().millisecondsSinceEpoch.toString(),
        titleController.text.trim(),
        arabicTitleController.text.trim(),
        authorName,
        arabicAuthorName,
        detailsController.text.trim(),
        arabicDetailsController.text.trim(),
        isActive.value,
        blogImages, // استخدام URLs الصور المرفوعة
        DateTime.now(),
      );

      await _blogRepository.addBolg(blog);

      // SnackbarHelper.showSuccess(
      //   title: 'نجح',
      //   message: 'تم إضافة المقال بنجاح',
      // );

      clearForm();
      fetchBlogs();
    } catch (e) {
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في إضافة المقال: $e',
      );
    } finally {
      isUploading.value = false;
    }
  }

  /// تحديث مقال
  Future<void> updateBlog() async {
    try {
      if (selectedBlog == null) return;

      if (titleController.text.trim().isEmpty ||
          arabicTitleController.text.trim().isEmpty) {
        SnackbarHelper.showError(
          title: 'خطأ',
          message: 'يرجى إدخال عنوان المقال باللغتين',
        );
        return;
      }

      isUploading.value = true;

      // استخدام "Brother Creative" كقيمة افتراضية إذا كان اسم الكاتب فارغ
      final authorName = authorController.text.trim().isEmpty
          ? "Brother Creative"
          : authorController.text.trim();
      final arabicAuthorName = arabicAuthorController.text.trim().isEmpty
          ? "براذر كرييتف"
          : arabicAuthorController.text.trim();

      final updatedBlog = BlogModel(
        selectedBlog!.id,
        titleController.text.trim(),
        arabicTitleController.text.trim(),
        authorName,
        arabicAuthorName,
        detailsController.text.trim(),
        arabicDetailsController.text.trim(),
        isActive.value,
        selectedImages.toList(),
        DateTime.now(),
      );

      await _blogRepository.updateBlog(updatedBlog);

      // SnackbarHelper.showSuccess(
      //   title: 'نجح',
      //   message: 'تم تحديث المقال بنجاح',
      // );

      clearForm();
      fetchBlogs();
    } catch (e) {
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في تحديث المقال: $e',
      );
    } finally {
      isUploading.value = false;
    }
  }

  /// حذف مقال
  Future<void> deleteBlog(String blogId) async {
    try {
      await _blogRepository.deleteBlog(blogId);

      // SnackbarHelper.showSuccess(
      //   title: 'نجح',
      //   message: 'تم حذف المقال بنجاح',
      // );

      fetchBlogs();
    } catch (e) {
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في حذف المقال: $e',
      );
    }
  }

  /// تحميل مقال للتعديل
  void loadBlogForEdit(BlogModel blog) {
    // إنشاء نسخة عميقة من البلوغ للتعديل
    selectedBlog = _createDeepCopy(blog);

    titleController.text = blog.title;
    arabicTitleController.text = blog.arabicTitle;
    authorController.text = blog.auther;
    arabicAuthorController.text = blog.arabicAuther;
    detailsController.text = blog.details;
    arabicDetailsController.text = blog.arabicDetails;
    isActive.value = blog.active;

    // تحميل الصور للتعديل - نسخ الصور بدلاً من الربط المباشر
    selectedImages.clear();
    selectedImageBytes.clear();
    uploadedImages.clear();

    // إضافة صور البلوغ إلى الصور المختارة للتعديل (نسخ الصور)
    if (blog.images != null && blog.images!.isNotEmpty) {
      // نسخ الصور بدلاً من الربط المباشر
      selectedImages.addAll(List<String>.from(blog.images!));
      // إضافة الصور أيضاً إلى uploadedImages للعرض في النموذج
      uploadedImages.addAll(List<String>.from(blog.images!));

      if (kDebugMode) {
        print(
            '📝 BlogController: Loaded ${blog.images!.length} images for editing');
        print(
            '📸 BlogController: Original blog still has ${blog.images!.length} images');
      }
    }

    isFormMode.value = true;
    isEditMode.value = true;
  }

  /// إظهار نموذج الإضافة
  void showAddForm() {
    clearForm();
    isFormMode.value = true;
    isEditMode.value = false;
  }

  /// إظهار نموذج التعديل
  void showEditForm(BlogModel blog) {
    loadBlogForEdit(blog);
  }

  /// إخفاء النموذج
  void hideForm() {
    // إذا كان في وضع التعديل، استعادة البيانات الأصلية
    if (isEditMode.value && selectedBlog != null) {
      _restoreOriginalBlogData();
    }

    clearForm();
    isFormMode.value = false;
  }

  /// استعادة البيانات الأصلية للبلوغ
  void _restoreOriginalBlogData() {
    if (selectedBlog != null) {
      if (kDebugMode) {
        print(
            '🔄 BlogController: Restoring original blog data for ${selectedBlog!.title}');
      }

      // استعادة الصور الأصلية
      if (selectedBlog!.images != null && selectedBlog!.images!.isNotEmpty) {
        // التأكد من أن الصور الأصلية موجودة في البلوغ
        if (kDebugMode) {
          print(
              '📸 BlogController: Restoring ${selectedBlog!.images!.length} original images');
        }
      }

      selectedBlog = null;
    }
  }

  /// إنشاء نسخة عميقة من البلوغ للتعديل
  BlogModel _createDeepCopy(BlogModel original) {
    return BlogModel(
      original.id,
      original.title,
      original.arabicTitle,
      original.auther,
      original.arabicAuther,
      original.details,
      original.arabicDetails,
      original.active,
      original.images != null ? List<String>.from(original.images!) : null,
      original.editTime,
    );
  }

  /// إنشاء مقال جديد
  Future<void> createBlog() async {
    await addBlog();
  }

  /// تحديث حالة النشاط
  Future<void> toggleActiveStatus(BlogModel blog) async {
    try {
      final updatedBlog = BlogModel(
        blog.id,
        blog.title,
        blog.arabicTitle,
        blog.auther,
        blog.arabicAuther,
        blog.details,
        blog.arabicDetails,
        !blog.active,
        blog.images,
        blog.editTime,
      );

      await _blogRepository.updateBlog(updatedBlog);

      // SnackbarHelper.showSuccess(
      //   title: 'نجح',
      //   message: 'تم تحديث حالة المقال بنجاح',
      // );

      fetchBlogs();
    } catch (e) {
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في تحديث حالة المقال: $e',
      );
    }
  }

  /// تحديث البيانات
  Future<void> refreshData() async {
    await fetchBlogs();
  }

  /// إضافة صورة
  void addImage(String imagePath) {
    if (!selectedImages.contains(imagePath)) {
      selectedImages.add(imagePath);
    }
  }

  /// حذف صورة
  void removeImage(String imagePath) {
    selectedImages.remove(imagePath);
  }

  /// مسح النموذج
  void clearForm() {
    titleController.clear();
    arabicTitleController.clear();
    authorController.clear();
    arabicAuthorController.clear();
    detailsController.clear();
    arabicDetailsController.clear();

    // مسح الصور المختارة والمرفوعة فقط عند إغلاق النموذج
    selectedImages.clear();
    selectedImageBytes.clear();
    uploadedImages.clear();

    selectedBlog = null;
    isActive.value = true;
    isFormMode.value = false;
    isEditMode.value = false;
    isUploading.value = false;
    isPreparing.value = false;
    uploadProgress.value = 0.0;

    if (kDebugMode) {
      print('🧹 BlogController: Form cleared successfully');
    }
  }

  /// تبديل وضع النموذج
  void toggleFormMode() {
    isFormMode.value = !isFormMode.value;
    if (!isFormMode.value) {
      clearForm();
    }
  }

  /// البحث في المقالات
  void searchBlogs(String query) {
    searchQuery.value = query;
  }

  /// اختيار الصور من المعرض
  Future<void> pickImagesFromGallery() async {
    try {
      if (kDebugMode) {
        print('📸 BlogController: Starting image selection from gallery');
      }

      // اختيار عدة صور
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFiles.isNotEmpty) {
        await _processSelectedImages(pickedFiles);
      } else {
        if (kDebugMode) {
          print('ℹ️ BlogController: No images selected from gallery');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ BlogController: Error picking images from gallery: $e');
      }
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في اختيار الصور من المعرض: $e',
      );
    }
  }

  /// التقاط صورة من الكاميرا
  Future<void> pickImageFromCamera() async {
    try {
      if (kDebugMode) {
        print('📸 BlogController: Starting image capture from camera');
      }

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        await _processSelectedImages([pickedFile]);
      } else {
        if (kDebugMode) {
          print('ℹ️ BlogController: No image captured from camera');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ BlogController: Error capturing image from camera: $e');
      }
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في التقاط الصورة من الكاميرا: $e',
      );
    }
  }

  /// معالجة الصور المختارة
  Future<void> _processSelectedImages(List<XFile> pickedFiles) async {
    try {
      isPreparing.value = true;

      if (kDebugMode) {
        print(
            '🔄 BlogController: Processing ${pickedFiles.length} selected images');
      }

      for (final file in pickedFiles) {
        // إضافة مسار الصورة
        selectedImages.add(file.path);

        // قراءة بيانات الصورة
        final bytes = await file.readAsBytes();
        selectedImageBytes.add(bytes);
      }

      // تحديث الواجهة بعد إضافة الصور
      update();

      if (kDebugMode) {
        print(
            '✅ BlogController: Successfully processed ${pickedFiles.length} images');
        print(
            '📸 BlogController: selectedImages count: ${selectedImages.length}');
        print(
            '📸 BlogController: selectedImageBytes count: ${selectedImageBytes.length}');
      }

      // SnackbarHelper.showSuccess(
      //   title: 'نجح',
      //   message: 'تم اختيار ${pickedFiles.length} صورة بنجاح',
      // );
    } catch (e) {
      if (kDebugMode) {
        print('❌ BlogController: Error processing selected images: $e');
      }
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في معالجة الصور المختارة: $e',
      );
    } finally {
      isPreparing.value = false;
    }
  }

  /// حذف صورة مختارة
  void removeSelectedImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      if (index < selectedImageBytes.length) {
        selectedImageBytes.removeAt(index);
      }
    }
  }

  /// حذف صورة مرفوعة
  void removeUploadedImage(int index) {
    if (index >= 0 && index < uploadedImages.length) {
      uploadedImages.removeAt(index);
    }
  }

  /// رفع الصور المختارة إلى Firebase Storage
  Future<List<String>> uploadSelectedImages() async {
    try {
      if (_storageService.value == null) {
        throw Exception('Firebase Storage service not initialized');
      }

      if (selectedImages.isEmpty) {
        if (kDebugMode) {
          print('ℹ️ BlogController: No images to upload');
        }
        return [];
      }

      isUploading.value = true;
      uploadProgress.value = 0.0;

      if (kDebugMode) {
        print(
            '📤 BlogController: Starting upload of ${selectedImages.length} images');
      }

      final List<String> uploadedUrls = [];

      // رفع الصور كـ bytes
      if (selectedImageBytes.isNotEmpty) {
        uploadedUrls
            .addAll(await _storageService.value!.uploadMultipleImageBytes(
          imageBytesList: selectedImageBytes,
          folder: 'blog_images',
          onProgress: (progress) {
            uploadProgress.value = progress;
            if (kDebugMode) {
              print(
                  '📤 Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
            }
          },
        ));
      }

      // إضافة URLs المرفوعة إلى القائمة
      uploadedImages.addAll(uploadedUrls);

      if (kDebugMode) {
        print(
            '✅ BlogController: Successfully uploaded ${uploadedUrls.length} images');
      }

      // SnackbarHelper.showSuccess(
      //   title: 'نجح',
      //   message: 'تم رفع ${uploadedUrls.length} صورة بنجاح',
      // );

      return uploadedUrls;
    } catch (e) {
      if (kDebugMode) {
        print('❌ BlogController: Error uploading images: $e');
      }
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في رفع الصور: $e',
      );
      return [];
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
    }
  }

  /// رفع صورة واحدة إلى Firebase Storage
  Future<String?> uploadSingleImage(String imagePath) async {
    try {
      if (_storageService.value == null) {
        throw Exception('Firebase Storage service not initialized');
      }

      if (kDebugMode) {
        print('📤 BlogController: Starting upload of single image: $imagePath');
      }

      final uploadUrl = await _storageService.value!.uploadImage(
        imagePath: imagePath,
        folder: 'blog_images',
      );

      uploadedImages.add(uploadUrl);

      if (kDebugMode) {
        print(
            '✅ BlogController: Successfully uploaded single image: $uploadUrl');
      }

      return uploadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('❌ BlogController: Error uploading single image: $e');
      }
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في رفع الصورة: $e',
      );
      return null;
    }
  }

  /// الحصول على المقالات المفلترة
  List<BlogModel> get filteredBlogs {
    if (searchQuery.value.isEmpty) {
      return blogs;
    }

    return blogs.where((blog) {
      final title = Get.locale?.languageCode == 'en'
          ? blog.title.toLowerCase()
          : blog.arabicTitle.toLowerCase();
      final details = Get.locale?.languageCode == 'en'
          ? blog.details.toLowerCase()
          : blog.arabicDetails.toLowerCase();
      final query = searchQuery.value.toLowerCase();

      return title.contains(query) || details.contains(query);
    }).toList();
  }

  /// إضافة البيانات التجريبية إلى Firebase
  Future<void> addTestData() async {
    try {
      isLoading.value = true;

      final testBlogs = _getTestBlogData();

      for (final blog in testBlogs) {
        await _blogRepository.addBolg(blog);
      }

      // SnackbarHelper.showSuccess(
      //   title: 'نجح',
      //   message: 'تم إضافة البيانات التجريبية بنجاح',
      // );

      await fetchBlogs();
    } catch (e) {
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في إضافة البيانات التجريبية: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// البيانات التجريبية للمدونة
  List<BlogModel> _getTestBlogData() {
    return [
      BlogModel(
        DateTime.now().millisecondsSinceEpoch.toString(),
        "The Future of Web Development",
        "مستقبل تطوير الويب",
        "Brother Creative",
        "براذر كرييتف",
        "Exploring the latest trends in web development that will shape the future of the internet. From progressive web apps to serverless architecture, discover what's next in web technology.",
        "استكشاف أحدث الاتجاهات والتقنيات في تطوير الويب التي ستشكل مستقبل الإنترنت. من التطبيقات التقدمية إلى البنية الخادمة، اكتشف ما ينتظرنا في تقنية الويب.",
        true,
        [
          "https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=800&h=400&fit=crop",
          "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&h=400&fit=crop",
        ],
        DateTime.now().subtract(const Duration(days: 2)),
      ),
      BlogModel(
        (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        "Mobile App Design Trends 2024",
        "اتجاهات تصميم تطبيقات الموبايل 2024",
        "Brother Creative",
        "براذر كرييتف",
        "Discover the most popular design trends that will dominate mobile app development in 2024. From dark mode to micro-interactions, learn what users expect from modern mobile apps.",
        "اكتشف أكثر اتجاهات التصميم شيوعاً التي ستسيطر على تطوير تطبيقات الموبايل في 2024. من الوضع المظلم إلى التفاعلات الدقيقة، تعلم ما يتوقعه المستخدمون من التطبيقات الحديثة.",
        true,
        [
          "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&h=400&fit=crop",
          "https://images.unsplash.com/photo-1551650975-87deedd944c3?w=800&h=400&fit=crop",
          "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&h=400&fit=crop",
        ],
        DateTime.now().subtract(const Duration(days: 5)),
      ),
      BlogModel(
        (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        "AI and Machine Learning in Business",
        "الذكاء الاصطناعي والتعلم الآلي في الأعمال",
        "Brother Creative",
        "براذر كرييتف",
        "How artificial intelligence and machine learning are revolutionizing business operations. From predictive analytics to automated customer service, explore the impact of AI on modern business.",
        "كيف يحدث الذكاء الاصطناعي والتعلم الآلي ثورة في عمليات الأعمال واتخاذ القرارات. من التحليلات التنبؤية إلى خدمة العملاء الآلية، استكشف تأثير الذكاء الاصطناعي على الأعمال الحديثة.",
        true,
        [
          "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800&h=400&fit=crop",
          "https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=800&h=400&fit=crop",
        ],
        DateTime.now().subtract(const Duration(days: 7)),
      ),
      BlogModel(
        (DateTime.now().millisecondsSinceEpoch + 3).toString(),
        "Sustainable Technology Solutions",
        "حلول التكنولوجيا المستدامة",
        "Brother Creative",
        "براذر كرييتف",
        "Exploring eco-friendly technology solutions that help reduce environmental impact. From green cloud computing to energy-efficient algorithms, discover how tech can save the planet.",
        "استكشاف حلول التكنولوجيا الصديقة للبيئة التي تساعد في تقليل التأثير البيئي. من الحوسبة السحابية الخضراء إلى الخوارزميات الموفرة للطاقة، اكتشف كيف يمكن للتكنولوجيا إنقاذ الكوكب.",
        true,
        [
          "https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?w=800&h=400&fit=crop",
          "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800&h=400&fit=crop",
          "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=800&h=400&fit=crop",
        ],
        DateTime.now().subtract(const Duration(days: 10)),
      ),
      BlogModel(
        (DateTime.now().millisecondsSinceEpoch + 4).toString(),
        "Cybersecurity Best Practices 2024",
        "أفضل ممارسات الأمن السيبراني 2024",
        "Brother Creative",
        "براذر كرييتف",
        "Essential cybersecurity practices every business should implement in 2024. From multi-factor authentication to zero-trust architecture, protect your digital assets effectively.",
        "الممارسات الأساسية للأمن السيبراني التي يجب على كل شركة تطبيقها في 2024. من المصادقة متعددة العوامل إلى بنية الثقة الصفرية، احم أصولك الرقمية بفعالية.",
        true,
        [
          "https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800&h=400&fit=crop",
        ],
        DateTime.now().subtract(const Duration(days: 12)),
      ),
      BlogModel(
        (DateTime.now().millisecondsSinceEpoch + 5).toString(),
        "Cloud Computing Revolution",
        "ثورة الحوسبة السحابية",
        "Brother Creative",
        "براذر كرييتف",
        "How cloud computing is transforming the way businesses operate. From scalability to cost-effectiveness, explore the benefits and challenges of cloud migration.",
        "كيف تحول الحوسبة السحابية طريقة عمل الشركات. من قابلية التوسع إلى فعالية التكلفة، استكشف فوائد وتحديات الهجرة إلى السحابة.",
        false,
        [
          "https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&h=400&fit=crop",
          "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=800&h=400&fit=crop",
        ],
        DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }
}
