# نظام رفع الصور - Image Upload System

## 📋 **الملخص**

تم إنشاء نظام رفع صور متكامل لرفع صور الفئات في لوحة التحكم. النظام يدعم تتبع التقدم ويعرض progress bar للمستخدم.

## 🏗️ **المكونات**

### **1. UploadResult Model**
```dart
lib/data/models/upload_result.dart
```
- يحتوي على نتيجة رفع الصورة
- يدعم JSON parsing
- يتعامل مع الأخطاء

### **2. ImageUploadService**
```dart
lib/utils/upload/image_upload_service.dart
```
- Service لرفع الصور إلى الخادم
- يدعم HTTP multipart requests
- يدعم تتبع التقدم
- التحقق من صحة الملفات

### **3. ImagePickerWidget**
```dart
lib/features/dashboard/widgets/image_picker_widget.dart
```
- Widget لاختيار الصور
- دعم الكاميرا والمعرض
- عرض تقدم الرفع
- معالجة الأخطاء

### **4. CategoryController (محدث)**
```dart
lib/features/dashboard/controllers/category_controller.dart
```
- يدير رفع الصور مع تتبع التقدم
- طرق جديدة لإنشاء وتحديث الفئات مع الصور
- إدارة حالة رفع الصور

## 🚀 **كيفية الاستخدام**

### **1. في CategoryForm**
```dart
Widget _buildImageField(bool isDark) {
  return ImagePickerWidget(
    initialImageUrl: _imageController.text.isNotEmpty ? _imageController.text : null,
    onImageSelected: (url) {
      _imageController.text = url;
    },
    onError: (error) {
      Get.snackbar('خطأ في الصورة', error);
    },
    label: 'صورة الفئة',
    width: double.infinity,
    height: 200,
  );
}
```

### **2. حفظ الفئة مع الصورة**
```dart
void _handleSave() async {
  if (_formKey.currentState!.validate()) {
    final controller = Get.find<CategoryController>();

    bool success;
    if (widget.isEditMode) {
      success = await controller.updateCategoryWithImageUpload(
        _nameController.text.trim(),
        _arabicNameController.text.trim(),
        _isFeature,
        _parentIdController.text.trim(),
      );
    } else {
      success = await controller.createCategoryWithImageUpload(
        _nameController.text.trim(),
        _arabicNameController.text.trim(),
        _isFeature,
        _parentIdController.text.trim(),
      );
    }

    if (success) {
      controller.resetImageUploadState();
    }
  }
}
```

## 📊 **تتبع التقدم - Progress Tracking**

### **1. في ImagePickerWidget**
```dart
// عرض progress bar
if (_isUploading) ...[
  GetBuilder<CategoryController>(
    builder: (controller) {
      return Column(
        children: [
          LinearProgressIndicator(
            value: controller.imageUploadProgress,
          ),
          Text('${(controller.imageUploadProgress * 100).toStringAsFixed(1)}%'),
        ],
      );
    },
  ),
]
```

### **2. في CategoryController**
```dart
// رفع الصورة مع تتبع التقدم
Future<bool> uploadImageWithProgress() async {
  try {
    _isImageUploading.value = true;
    _imageUploadProgress.value = 0.0;
    update();

    final result = await ImageUploadService.uploadImageWithProgress(
      imageFile,
      (progress) {
        _imageUploadProgress.value = progress;
        update(); // تحديث الواجهة
      },
    );

    return result.success;
  } finally {
    _isImageUploading.value = false;
    update();
  }
}
```

## ⚙️ **التكوين المطلوب**

### **1. تحديث API URL**
في `lib/utils/upload/image_upload_service.dart`:
```dart
static const String _uploadUrl = 'https://your-api-domain.com/upload';
```

### **2. تحديث Bearer Token**
```dart
static const String _bearerToken = 'your-actual-token';
```

## 🎯 **الميزات**

### **✅ الميزات المدعومة:**
- **اختيار الصور** من المعرض أو الكاميرا
- **تتبع التقدم** مع progress bar
- **التحقق من صحة الملفات** (JPG, PNG, GIF, WebP)
- **التحقق من الحجم** (الحد الأقصى 10 ميجابايت)
- **معالجة الأخطاء** مع رسائل واضحة
- **دعم الثيمات** (فاتح/داكن)
- **رفع تلقائي** عند حفظ الفئة

### **🔄 سير العمل:**
1. **اختيار الصورة** → فتح المعرض/الكاميرا
2. **التحقق من الصحة** → نوع الملف والحجم
3. **رفع الصورة** → مع تتبع التقدم
4. **عرض النتيجة** → URL الصورة في النموذج
5. **حفظ الفئة** → مع الصورة المرفوعة

## 🔧 **الطرق المتاحة في CategoryController**

### **رفع الصور:**
- `selectImageFile(File imageFile)` - تحديد ملف صورة
- `uploadImageWithProgress()` - رفع مع تتبع التقدم
- `uploadImage()` - رفع بدون تتبع التقدم
- `clearSelectedImage()` - مسح الصورة المحددة

### **إدارة الفئات:**
- `createCategoryWithImageUpload()` - إنشاء فئة مع رفع صورة
- `updateCategoryWithImageUpload()` - تحديث فئة مع رفع صورة
- `resetImageUploadState()` - إعادة تعيين حالة رفع الصورة

### **Getters:**
- `isImageUploading` - حالة رفع الصورة
- `imageUploadProgress` - نسبة التقدم (0.0 - 1.0)
- `selectedImageFile` - ملف الصورة المحدد
- `uploadedImageUrl` - URL الصورة المرفوعة

## 📱 **مثال على الاستخدام الكامل**

```dart
// 1. اختيار صورة
final controller = Get.find<CategoryController>();
controller.selectImageFile(imageFile);

// 2. رفع الصورة مع تتبع التقدم
final success = await controller.uploadImageWithProgress();

// 3. إنشاء فئة مع الصورة
if (success) {
  await controller.createCategoryWithImageUpload(
    'Electronics',
    'الإلكترونيات',
    true,
    '',
  );
}
```

## 🚨 **معالجة الأخطاء**

النظام يتعامل مع الأخطاء التالية:
- **ملف غير صالح** - نوع الملف غير مدعوم
- **حجم كبير** - يتجاوز الحد المسموح
- **خطأ في الاتصال** - مشاكل في الشبكة
- **خطأ في الخادم** - استجابة غير صحيحة

## 🔄 **التحديثات المستقبلية**

- دعم رفع متعدد للصور
- ضغط الصور تلقائياً
- دعم المزيد من أنواع الملفات
- رفع مباشر إلى Firebase Storage
- معاينة الصور قبل الرفع
