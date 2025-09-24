# الاقتصاص التلقائي للصور

## نظرة عامة

تم إضافة ميزة الاقتصاص التلقائي للصور في `UniversalImageUploadWidget` مع معاملات قابلة للتخصيص. هذه الميزة تسمح باقتصاص الصور تلقائياً قبل رفعها إلى Firebase Storage.

## المميزات

### ✅ **أنواع الاقتصاص المدعومة**
- **من المنتصف (Center)**: اقتصاص من وسط الصورة
- **من الأعلى (Top)**: اقتصاص من الجزء العلوي
- **من الأسفل (Bottom)**: اقتصاص من الجزء السفلي
- **من اليسار (Left)**: اقتصاص من الجانب الأيسر
- **من اليمين (Right)**: اقتصاص من الجانب الأيمن
- **ذكي (Smart)**: اختيار أفضل منطقة تلقائياً
- **دائري (Circular)**: اقتصاص دائري مع خلفية شفافة
- **بزوايا مدورة (Rounded)**: اقتصاص بزوايا مدورة

### ✅ **تنسيقات الصور المدعومة**
- JPEG
- PNG
- WebP
- BMP

### ✅ **معاملات قابلة للتخصيص**
- الأبعاد (العرض والارتفاع)
- الجودة
- نوع الاقتصاص
- تنسيق الصورة
- نصف قطر الزوايا المدورة

## الاستخدام الأساسي

### 1. اقتصاص مربع

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.single,
  folderPath: 'categories',
  cropParameters: CropParameters.square(
    size: 300,
    quality: 85,
    format: ImageFormat.jpeg,
    cropType: CropType.center,
  ),
  onImagesUploaded: (images) {
    print('Uploaded images: $images');
  },
  onError: (error) {
    print('Error: $error');
  },
)
```

### 2. اقتصاص مستطيل

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.single,
  folderPath: 'products',
  cropParameters: CropParameters.rectangle(
    width: 400,
    height: 300,
    quality: 90,
    format: ImageFormat.jpeg,
    cropType: CropType.center,
  ),
  onImagesUploaded: (images) {
    print('Uploaded images: $images');
  },
  onError: (error) {
    print('Error: $error');
  },
)
```

### 3. اقتصاص دائري

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.single,
  folderPath: 'profiles',
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
    print('Uploaded images: $images');
  },
  onError: (error) {
    print('Error: $error');
  },
)
```

### 4. اقتصاص بزوايا مدورة

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.single,
  folderPath: 'banners',
  cropParameters: CropParameters.rounded(
    width: 800,
    height: 400,
    borderRadius: 16.0,
    quality: 85,
    format: ImageFormat.png,
    cropType: CropType.center,
  ),
  onImagesUploaded: (images) {
    print('Uploaded images: $images');
  },
  onError: (error) {
    print('Error: $error');
  },
)
```

## المعاملات المتقدمة

### CropParameters

```dart
CropParameters(
  width: 400,                    // العرض المطلوب
  height: 300,                   // الارتفاع المطلوب
  quality: 85,                   // الجودة (1-100)
  format: ImageFormat.jpeg,      // تنسيق الصورة
  aspectRatio: 4/3,             // النسبة المطلوبة (اختياري)
  cropType: CropType.center,     // نوع الاقتصاص
  borderRadius: 8.0,            // نصف قطر الزوايا (للزوايا المدورة)
)
```

### أنواع الاقتصاص

```dart
enum CropType {
  center,    // من المنتصف
  top,       // من الأعلى
  bottom,    // من الأسفل
  left,      // من اليسار
  right,     // من اليمين
  smart,     // ذكي
  circular,  // دائري
  rounded,   // بزوايا مدورة
}
```

### تنسيقات الصور

```dart
enum ImageFormat {
  jpeg,      // JPEG
  png,       // PNG
  webp,      // WebP
  bmp,       // BMP
  unknown,   // غير معروف
}
```

## أمثلة متقدمة

### 1. اقتصاص ذكي

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.single,
  folderPath: 'smart_crop',
  cropParameters: CropParameters(
    width: 500,
    height: 500,
    quality: 90,
    format: ImageFormat.jpeg,
    cropType: CropType.smart,
  ),
  onImagesUploaded: (images) {
    print('Smart cropped images: $images');
  },
  onError: (error) {
    print('Error: $error');
  },
)
```

### 2. اقتصاص من الأعلى

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.single,
  folderPath: 'top_crop',
  cropParameters: CropParameters(
    width: 600,
    height: 300,
    quality: 85,
    format: ImageFormat.jpeg,
    cropType: CropType.top,
  ),
  onImagesUploaded: (images) {
    print('Top cropped images: $images');
  },
  onError: (error) {
    print('Error: $error');
  },
)
```

### 3. اقتصاص متعدد للصور

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.multiple,
  folderPath: 'gallery',
  maxImages: 5,
  cropParameters: CropParameters.square(
    size: 300,
    quality: 80,
    format: ImageFormat.jpeg,
    cropType: CropType.center,
  ),
  onImagesUploaded: (images) {
    print('Gallery images: $images');
  },
  onError: (error) {
    print('Error: $error');
  },
)
```

## استخدام ImageUploadFormField

```dart
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
)
```

## التكامل مع النماذج

### نموذج الفئة مع الاقتصاص التلقائي

```dart
class CategoryForm extends StatefulWidget {
  // ...
}

class _CategoryFormState extends State<CategoryForm> {
  List<String> _categoryImages = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // حقول النص
          TextFormField(/* ... */),
          
          // رفع الصور مع الاقتصاص التلقائي
          ImageUploadFormField(
            folderPath: 'categories',
            label: 'صورة الفئة',
            hint: 'سيتم اقتصاص الصورة تلقائياً إلى مربع 300x300',
            initialImages: _categoryImages,
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
                SnackBar(content: Text('خطأ: $error')),
              );
            },
          ),
          
          // زر الحفظ
          ElevatedButton(
            onPressed: _saveCategory,
            child: Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _saveCategory() {
    if (_categoryImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى اختيار صورة للفئة')),
      );
      return;
    }

    // حفظ البيانات مع URL الصورة
    final category = CategoryModel(
      name: _nameController.text,
      image: _categoryImages.first,
      // ... باقي البيانات
    );
    
    // حفظ في قاعدة البيانات
  }
}
```

## أفضل الممارسات

### 1. اختيار نوع الاقتصاص المناسب

- **Center**: للصور العامة والمنتجات
- **Top**: للبانرات والعناوين
- **Bottom**: للصور التي تحتوي على نص في الأسفل
- **Smart**: للصور المعقدة
- **Circular**: للصور الشخصية والأيقونات
- **Rounded**: للبطاقات والعناصر الحديثة

### 2. اختيار التنسيق المناسب

- **JPEG**: للصور العادية (أصغر حجماً)
- **PNG**: للصور التي تحتاج شفافية (دائرية، بزوايا مدورة)
- **WebP**: للصور الحديثة (أفضل ضغط)

### 3. ضبط الجودة

```dart
// للصور الصغيرة (أيقونات، صور شخصية)
quality: 90

// للصور المتوسطة (منتجات، فئات)
quality: 85

// للصور الكبيرة (بانرات، معارض)
quality: 80
```

### 4. تحسين الأداء

```dart
// اقتصاص الصور الكبيرة قبل الرفع
CropParameters(
  width: 800,
  height: 600,
  quality: 85, // ضغط إضافي
  format: ImageFormat.jpeg,
  cropType: CropType.center,
)
```

## استكشاف الأخطاء

### مشاكل شائعة

1. **الصور لا تظهر بشكل صحيح**
   - تحقق من نوع الاقتصاص
   - تحقق من الأبعاد المحددة
   - تحقق من تنسيق الصورة

2. **جودة الصورة منخفضة**
   - زيادة قيمة الجودة
   - تغيير تنسيق الصورة إلى PNG
   - تحقق من الأبعاد الأصلية

3. **اقتصاص غير صحيح**
   - تحقق من نوع الاقتصاص
   - تحقق من النسبة المطلوبة
   - جرب الاقتصاص الذكي

### سجلات التصحيح

```dart
if (kDebugMode) {
  print('✂️ Applying crop parameters...');
  print('   - Width: ${parameters.width}');
  print('   - Height: ${parameters.height}');
  print('   - Quality: ${parameters.quality}');
  print('   - Format: ${parameters.format}');
  print('   - CropType: ${parameters.cropType}');
}
```

## التحديثات المستقبلية

- [ ] اقتصاص متقدم بالذكاء الاصطناعي
- [ ] دعم الفيديو
- [ ] اقتصاص متعدد الأشكال
- [ ] دعم الصور المتحركة (GIF)
- [ ] اقتصاص تفاعلي
- [ ] دعم الفلاتر والتأثيرات
- [ ] اقتصاص بالتعرف على الوجوه
- [ ] دعم الصور ثلاثية الأبعاد

## الدعم

للمساعدة أو الإبلاغ عن مشاكل، يرجى:
1. التحقق من هذا الدليل أولاً
2. البحث في Issues الموجودة
3. إنشاء Issue جديد مع تفاصيل المشكلة
4. إرفاق سجلات التصحيح إن أمكن
