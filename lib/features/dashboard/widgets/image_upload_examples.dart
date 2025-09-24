import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/universal_image_upload_widget.dart';

/// أمثلة على استخدام UniversalImageUploadWidget في مختلف الحالات
class ImageUploadExamples extends StatefulWidget {
  const ImageUploadExamples({super.key});

  @override
  State<ImageUploadExamples> createState() => _ImageUploadExamplesState();
}

class _ImageUploadExamplesState extends State<ImageUploadExamples> {
  // متغيرات لتخزين الصور المرفوعة
  List<String> categoryImages = [];
  List<String> productImages = [];
  String profileImage = '';
  List<String> galleryImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أمثلة رفع الصور'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مثال 1: رفع صورة واحدة للفئة
            _buildExampleCard(
              title: 'صورة الفئة (صورة واحدة)',
              child: UniversalImageUploadWidget(
                uploadType: UploadType.single,
                folderPath: 'categories',
                label: 'صورة الفئة',
                hint: 'اختر صورة تمثل الفئة',
                initialImages:
                    categoryImages.isNotEmpty ? [categoryImages.first] : [],
                onImagesUploaded: (images) {
                  setState(() {
                    categoryImages = images;
                  });
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $error')),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // مثال 2: رفع عدة صور للمنتج
            _buildExampleCard(
              title: 'صور المنتج (عدة صور)',
              child: UniversalImageUploadWidget(
                uploadType: UploadType.multiple,
                folderPath: 'products',
                label: 'صور المنتج',
                hint: 'اختر عدة صور للمنتج (حد أقصى 5 صور)',
                maxImages: 5,
                initialImages: productImages,
                onImagesUploaded: (images) {
                  setState(() {
                    productImages = images;
                  });
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $error')),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // مثال 3: صورة الملف الشخصي
            _buildExampleCard(
              title: 'صورة الملف الشخصي',
              child: UniversalImageUploadWidget(
                uploadType: UploadType.single,
                folderPath: 'profiles',
                label: 'الصورة الشخصية',
                hint: 'اختر صورة شخصية واضحة',
                initialImages: profileImage.isNotEmpty ? [profileImage] : [],
                onImagesUploaded: (images) {
                  setState(() {
                    profileImage = images.isNotEmpty ? images.first : '';
                  });
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $error')),
                  );
                },
                // تخصيص شكل الحاوية
                containerDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                height: 150,
                width: 150,
              ),
            ),

            const SizedBox(height: 24),

            // مثال 4: معرض الصور
            _buildExampleCard(
              title: 'معرض الصور',
              child: UniversalImageUploadWidget(
                uploadType: UploadType.multiple,
                folderPath: 'gallery',
                label: 'معرض الصور',
                hint: 'أضف صور للمعرض',
                maxImages: 20,
                initialImages: galleryImages,
                onImagesUploaded: (images) {
                  setState(() {
                    galleryImages = images;
                  });
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $error')),
                  );
                },
                // تخصيص شكل الأزرار
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // مثال 5: استخدام ImageUploadFormField
            _buildExampleCard(
              title: 'استخدام ImageUploadFormField',
              child: ImageUploadFormField(
                folderPath: 'banners',
                label: 'صورة البانر',
                hint: 'اختر صورة للبانر',
                initialImages: const [],
                onChanged: (images) {
                  if (kDebugMode) {
                    print('Banner images: $images');
                  }
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $error')),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // عرض البيانات الحالية
            _buildDataDisplayCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard({
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDataDisplayCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'البيانات الحالية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDataItem('صور الفئة', categoryImages),
            _buildDataItem('صور المنتج', productImages),
            _buildDataItem('الصورة الشخصية',
                profileImage.isNotEmpty ? [profileImage] : []),
            _buildDataItem('معرض الصور', galleryImages),
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem(String label, List<String> images) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              images.isEmpty ? 'لا توجد صور' : '${images.length} صورة',
            ),
          ),
        ],
      ),
    );
  }
}

/// مثال على استخدام الويدجت في نموذج الفئة
class CategoryFormWithImageUpload extends StatefulWidget {
  const CategoryFormWithImageUpload({super.key});

  @override
  State<CategoryFormWithImageUpload> createState() =>
      _CategoryFormWithImageUploadState();
}

class _CategoryFormWithImageUploadState
    extends State<CategoryFormWithImageUpload> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _arabicNameController = TextEditingController();
  List<String> _categoryImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نموذج الفئة مع رفع الصور'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // حقل اسم الفئة
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الفئة (إنجليزي)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'اسم الفئة مطلوب';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // حقل الاسم العربي
              TextFormField(
                controller: _arabicNameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الفئة (عربي)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الاسم العربي مطلوب';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // رفع الصور
              ImageUploadFormField(
                folderPath: 'categories',
                label: 'صورة الفئة',
                hint: 'اختر صورة تمثل الفئة',
                initialImages: _categoryImages,
                uploadType: UploadType.single,
                onChanged: (images) {
                  setState(() {
                    _categoryImages = images;
                  });
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ في رفع الصورة: $error')),
                  );
                },
              ),

              const SizedBox(height: 32),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveCategory,
                  child: const Text('حفظ الفئة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      if (_categoryImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار صورة للفئة')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الفئة بنجاح')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _arabicNameController.dispose();
    super.dispose();
  }
}
