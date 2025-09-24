import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/universal_image_upload_widget.dart';
import 'package:brother_admin_panel/utils/image/image_crop_service.dart';

/// أمثلة على استخدام الاقتصاص التلقائي في رفع الصور
class AutoCropExamples extends StatefulWidget {
  const AutoCropExamples({super.key});

  @override
  State<AutoCropExamples> createState() => _AutoCropExamplesState();
}

class _AutoCropExamplesState extends State<AutoCropExamples> {
  // متغيرات لتخزين الصور المرفوعة
  List<String> categoryImages = [];
  List<String> productImages = [];
  String profileImage = '';
  List<String> bannerImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أمثلة الاقتصاص التلقائي'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مثال 1: صورة فئة مربعة
            _buildExampleCard(
              title: 'صورة الفئة (مربعة 300x300)',
              description: 'اقتصاص تلقائي مربع من المنتصف',
              child: UniversalImageUploadWidget(
                uploadType: UploadType.single,
                folderPath: 'categories',
                label: 'صورة الفئة',
                hint: 'سيتم اقتصاص الصورة إلى مربع 300x300',
                initialImages:
                    categoryImages.isNotEmpty ? [categoryImages.first] : [],
                cropParameters: CropParameters.square(
                  size: 300,
                  quality: 85,
                  format: ImageFormat.jpeg,
                  cropType: CropType.center,
                ),
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

            // مثال 2: صورة منتج مستطيلة
            _buildExampleCard(
              title: 'صورة المنتج (مستطيلة 400x300)',
              description: 'اقتصاص تلقائي مستطيل من المنتصف',
              child: UniversalImageUploadWidget(
                uploadType: UploadType.single,
                folderPath: 'products',
                label: 'صورة المنتج',
                hint: 'سيتم اقتصاص الصورة إلى مستطيل 400x300',
                initialImages:
                    productImages.isNotEmpty ? [productImages.first] : [],
                cropParameters: CropParameters.rectangle(
                  width: 400,
                  height: 300,
                  quality: 90,
                  format: ImageFormat.jpeg,
                  cropType: CropType.center,
                ),
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

            // مثال 3: صورة شخصية دائرية
            _buildExampleCard(
              title: 'الصورة الشخصية (دائرية 200x200)',
              description: 'اقتصاص تلقائي دائري',
              child: UniversalImageUploadWidget(
                uploadType: UploadType.single,
                folderPath: 'profiles',
                label: 'الصورة الشخصية',
                hint: 'سيتم اقتصاص الصورة إلى دائرة 200x200',
                initialImages: profileImage.isNotEmpty ? [profileImage] : [],
                cropParameters: CropParameters.circular(
                  size: 200,
                  quality: 90,
                  format: ImageFormat.png, // PNG للدعم الشفافية
                ),
                containerDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                height: 200,
                width: 200,
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
              ),
            ),

            const SizedBox(height: 24),

            // مثال 4: بانر بزوايا مدورة
            _buildExampleCard(
              title: 'صورة البانر (بزوايا مدورة)',
              description: 'اقتصاص تلقائي بزوايا مدورة',
              child: UniversalImageUploadWidget(
                uploadType: UploadType.single,
                folderPath: 'banners',
                label: 'صورة البانر',
                hint: 'سيتم اقتصاص الصورة بزوايا مدورة',
                initialImages:
                    bannerImages.isNotEmpty ? [bannerImages.first] : [],
                cropParameters: CropParameters.rounded(
                  width: 800,
                  height: 400,
                  borderRadius: 16.0,
                  quality: 85,
                  format: ImageFormat.png,
                  cropType: CropType.center,
                ),
                onImagesUploaded: (images) {
                  setState(() {
                    bannerImages = images;
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

            // مثال 5: اقتصاص ذكي
            _buildExampleCard(
              title: 'اقتصاص ذكي (اختيار أفضل منطقة)',
              description: 'اقتصاص تلقائي ذكي لاختيار أفضل منطقة',
              child: UniversalImageUploadWidget(
                uploadType: UploadType.single,
                folderPath: 'smart_crop',
                label: 'صورة بالاقتصاص الذكي',
                hint: 'سيتم اختيار أفضل منطقة تلقائياً',
                initialImages: const [],
                cropParameters: const CropParameters(
                  width: 500,
                  height: 500,
                  quality: 90,
                  format: ImageFormat.jpeg,
                  cropType: CropType.smart,
                ),
                onImagesUploaded: (images) {
                  if (kDebugMode) {
                    print('Smart cropped images: $images');
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

            // مثال 6: اقتصاص من الأعلى
            _buildExampleCard(
              title: 'اقتصاص من الأعلى',
              description: 'اقتصاص تلقائي من الجزء العلوي',
              child: UniversalImageUploadWidget(
                uploadType: UploadType.single,
                folderPath: 'top_crop',
                label: 'صورة اقتصاص علوي',
                hint: 'سيتم اقتصاص الصورة من الأعلى',
                initialImages: const [],
                cropParameters: const CropParameters(
                  width: 600,
                  height: 300,
                  quality: 85,
                  format: ImageFormat.jpeg,
                  cropType: CropType.top,
                ),
                onImagesUploaded: (images) {
                  if (kDebugMode) {
                    print('Top cropped images: $images');
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

            // مثال 7: اقتصاص متعدد للصور
            _buildExampleCard(
              title: 'اقتصاص متعدد للصور',
              description: 'اقتصاص تلقائي لعدة صور بنفس المعايير',
              child: UniversalImageUploadWidget(
                uploadType: UploadType.multiple,
                folderPath: 'gallery',
                label: 'معرض الصور',
                hint: 'سيتم اقتصاص جميع الصور إلى 300x300',
                maxImages: 5,
                initialImages: const [],
                cropParameters: CropParameters.square(
                  size: 300,
                  quality: 80,
                  format: ImageFormat.jpeg,
                  cropType: CropType.center,
                ),
                onImagesUploaded: (images) {
                  if (kDebugMode) {
                    print('Gallery images: $images');
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
    required String description,
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
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
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
            _buildDataItem('صور البانر', bannerImages),
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

/// مثال على استخدام الاقتصاص في نموذج الفئة
class CategoryFormWithAutoCrop extends StatefulWidget {
  const CategoryFormWithAutoCrop({super.key});

  @override
  State<CategoryFormWithAutoCrop> createState() =>
      _CategoryFormWithAutoCropState();
}

class _CategoryFormWithAutoCropState extends State<CategoryFormWithAutoCrop> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _arabicNameController = TextEditingController();
  List<String> _categoryImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نموذج الفئة مع الاقتصاص التلقائي'),
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

              // رفع الصور مع الاقتصاص التلقائي
              ImageUploadFormField(
                folderPath: 'categories',
                label: 'صورة الفئة',
                hint: 'سيتم اقتصاص الصورة تلقائياً إلى مربع 300x300',
                initialImages: _categoryImages,
                uploadType: UploadType.single,
                cropParameters: CropParameters.square(
                  size: 300,
                  quality: 85,
                  format: ImageFormat.jpeg,
                  cropType: CropType.center,
                ),
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
