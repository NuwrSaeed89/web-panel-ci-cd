# Universal Image Upload Widget

## نظرة عامة

`UniversalImageUploadWidget` هو ويدجت شامل ومرن لرفع الصور في تطبيق Flutter. يدعم رفع صورة واحدة أو عدة صور مع ميزات متقدمة مثل المعاينة، التحقق من صحة الملفات، وتتبع التقدم.

## المميزات

### ✅ **مميزات أساسية**
- رفع صورة واحدة أو عدة صور
- دعم جميع المنصات (Web, Mobile, Desktop)
- رفع فوري أو عند الطلب
- معاينة الصور قبل وبعد الرفع
- تتبع تقدم الرفع
- التحقق من صحة الملفات
- رسائل خطأ واضحة

### ✅ **مميزات متقدمة**
- أزرار حذف وإعادة ترتيب
- تخصيص شكل الحاوية والأزرار
- دعم الصور الأولية (للتعديل)
- تحديد الحد الأقصى للصور
- ضغط الصور تلقائياً
- دعم Base64 و URLs

## الاستخدام الأساسي

### 1. رفع صورة واحدة

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.single,
  folderPath: 'categories',
  label: 'صورة الفئة',
  hint: 'اختر صورة تمثل الفئة',
  onImagesUploaded: (images) {
    print('Uploaded images: $images');
  },
  onError: (error) {
    print('Error: $error');
  },
)
```

### 2. رفع عدة صور

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.multiple,
  folderPath: 'products',
  label: 'صور المنتج',
  maxImages: 5,
  onImagesUploaded: (images) {
    print('Uploaded images: $images');
  },
  onError: (error) {
    print('Error: $error');
  },
)
```

### 3. استخدام ImageUploadFormField

```dart
ImageUploadFormField(
  folderPath: 'banners',
  label: 'صورة البانر',
  hint: 'اختر صورة للبانر',
  onChanged: (images) {
    // معالجة الصور المرفوعة
  },
  onError: (error) {
    // معالجة الأخطاء
  },
)
```

## المعاملات

### المعاملات المطلوبة

| المعامل | النوع | الوصف |
|---------|-------|--------|
| `uploadType` | `UploadType` | نوع الرفع: single أو multiple |
| `folderPath` | `String` | مسار المجلد في Firebase Storage |
| `onImagesUploaded` | `Function(List<String>)` | دالة الاستدعاء عند نجاح الرفع |
| `onError` | `Function(String)` | دالة الاستدعاء عند حدوث خطأ |

### المعاملات الاختيارية

| المعامل | النوع | الافتراضي | الوصف |
|---------|-------|-----------|--------|
| `initialImages` | `List<String>` | `[]` | الصور الأولية (للتعديل) |
| `maxImages` | `int` | `10` | الحد الأقصى للصور |
| `width` | `double?` | `null` | عرض الحاوية |
| `height` | `double?` | `null` | ارتفاع الحاوية |
| `label` | `String?` | `null` | تسمية الحقل |
| `hint` | `String?` | `null` | وصف الحقل |
| `autoUpload` | `bool` | `true` | رفع فوري عند الاختيار |
| `showPreview` | `bool` | `true` | عرض معاينة الصور |
| `showDeleteButtons` | `bool` | `true` | عرض أزرار الحذف |
| `showReorderButtons` | `bool` | `true` | عرض أزرار إعادة الترتيب |
| `containerDecoration` | `BoxDecoration?` | `null` | تخصيص شكل الحاوية |
| `buttonStyle` | `ButtonStyle?` | `null` | تخصيص شكل الأزرار |

## أمثلة متقدمة

### 1. تخصيص شكل الحاوية

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.single,
  folderPath: 'profiles',
  containerDecoration: BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    border: Border.all(color: Colors.blue, width: 2),
  ),
  height: 150,
  width: 150,
  // ... باقي المعاملات
)
```

### 2. تخصيص شكل الأزرار

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.multiple,
  folderPath: 'gallery',
  buttonStyle: ElevatedButton.styleFrom(
    backgroundColor: Colors.purple,
    foregroundColor: Colors.white,
  ),
  // ... باقي المعاملات
)
```

### 3. رفع بدون معاينة فورية

```dart
UniversalImageUploadWidget(
  uploadType: UploadType.single,
  folderPath: 'documents',
  autoUpload: false,
  showPreview: false,
  onImagesUploaded: (images) {
    // رفع الصور عند الطلب
    _uploadImages(images);
  },
  // ... باقي المعاملات
)
```

## التكامل مع النماذج

### نموذج الفئة

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
          
          // رفع الصور
          ImageUploadFormField(
            folderPath: 'categories',
            label: 'صورة الفئة',
            initialImages: _categoryImages,
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

## إدارة الأخطاء

### أنواع الأخطاء المدعومة

1. **أخطاء اختيار الملفات**
   - نوع الملف غير مدعوم
   - حجم الملف كبير جداً
   - فشل في قراءة الملف

2. **أخطاء الرفع**
   - فشل الاتصال بالإنترنت
   - خطأ في Firebase Storage
   - انتهاء المهلة الزمنية

3. **أخطاء التحقق**
   - عدم وجود صورة
   - تجاوز الحد الأقصى للصور
   - صورة تالفة

### معالجة الأخطاء

```dart
UniversalImageUploadWidget(
  // ...
  onError: (error) {
    // تسجيل الخطأ
    print('Upload error: $error');
    
    // عرض رسالة للمستخدم
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('فشل في رفع الصورة: $error'),
        backgroundColor: Colors.red,
      ),
    );
    
    // إرسال تقرير خطأ
    _reportError(error);
  },
)
```

## أفضل الممارسات

### 1. تنظيم مجلدات Firebase Storage

```
categories/
  ├── category_1.jpg
  ├── category_2.png
  └── ...

products/
  ├── product_1/
  │   ├── main.jpg
  │   ├── gallery_1.jpg
  │   └── gallery_2.jpg
  └── product_2/
      └── main.jpg

profiles/
  ├── user_1.jpg
  └── user_2.png
```

### 2. ضغط الصور

```dart
// في EnhancedImageUploadService
static Future<Uint8List> compressImage(Uint8List imageBytes, {int quality = 85}) async {
  // استخدام مكتبة ضغط الصور
  return imageBytes;
}
```

### 3. التحقق من صحة الملفات

```dart
// التحقق قبل الرفع
if (!EnhancedImageUploadService.isValidImageFile(file)) {
  widget.onError('نوع الملف غير مدعوم');
  return;
}

final fileSize = await EnhancedImageUploadService.getFileSizeInMB(file);
if (fileSize > 10.0) {
  widget.onError('حجم الملف كبير جداً');
  return;
}
```

### 4. إدارة الذاكرة

```dart
@override
void dispose() {
  _uploadController.reset();
  super.dispose();
}
```

## استكشاف الأخطاء

### مشاكل شائعة

1. **الصور لا تظهر**
   - تحقق من صحة URL
   - تحقق من إعدادات CORS
   - تحقق من صلاحيات Firebase Storage

2. **فشل الرفع**
   - تحقق من الاتصال بالإنترنت
   - تحقق من إعدادات Firebase
   - تحقق من حجم الملف

3. **أخطاء التحقق**
   - تحقق من نوع الملف
   - تحقق من حجم الملف
   - تحقق من صحة البيانات

### سجلات التصحيح

```dart
if (kDebugMode) {
  print('🚀 Starting image upload...');
  print('📁 Folder: $folderPath');
  print('📊 Image data type: ${imageData.runtimeType}');
}
```

## التحديثات المستقبلية

- [ ] دعم الفيديو
- [ ] ضغط الصور المتقدم
- [ ] إنشاء thumbnails تلقائياً
- [ ] دعم الصور المتحركة (GIF)
- [ ] رفع متوازي للصور المتعددة
- [ ] دعم السحب والإفلات
- [ ] معاينة الصور بالتكبير
- [ ] دعم التصفية والتحسين

## الدعم

للمساعدة أو الإبلاغ عن مشاكل، يرجى:
1. التحقق من هذا الدليل أولاً
2. البحث في Issues الموجودة
3. إنشاء Issue جديد مع تفاصيل المشكلة
4. إرفاق سجلات التصحيح إن أمكن
