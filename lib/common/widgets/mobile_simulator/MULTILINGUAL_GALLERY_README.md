# دعم متعدد اللغات للمعرض - Multilingual Gallery Support

## المشكلة
كانت صفحة `mobile_gallery_widget.dart` تعرض أسماء الألبومات بالعربية فقط، ولم تكن تدعم التبديل بين اللغات العربية والإنجليزية.

## الحل المطبق

### 1. إضافة دعم متعدد اللغات
تم تحديث الصفحة لتدعم التبديل بين اللغتين العربية والإنجليزية باستخدام `LanguageController`.

### 2. عرض الأسماء حسب اللغة
- **اللغة العربية**: تعرض الاسم العربي أولاً، ثم الإنجليزي كبديل
- **اللغة الإنجليزية**: تعرض الاسم الإنجليزي أولاً، ثم العربي كبديل

### 3. ترجمة النصوص الثابتة
تم ترجمة جميع النصوص الثابتة في الصفحة:
- `'albums'.tr` - "الألبومات" / "Albums"
- `'noAlbums'.tr` - "لا توجد ألبومات" / "No Albums"
- `'viewAll'.tr` - "عرض الكل" / "View All"
- `'imageLoadError'.tr` - "خطأ في تحميل الصورة" / "Error loading image"

## الكود المحدث

### 1. إضافة LanguageController
```dart
import 'package:brother_admin_panel/localization/language_controller.dart';
```

### 2. دوال مساعدة للعرض حسب اللغة
```dart
/// الحصول على الاسم المعروض حسب اللغة الحالية
String _getDisplayName(dynamic galleryItem, int index) {
  final languageController = Get.find<LanguageController>();
  
  if (languageController.isArabic) {
    // إذا كانت اللغة عربية، اعرض الاسم العربي أولاً
    if (galleryItem.arabicName?.isNotEmpty == true) {
      return galleryItem.arabicName!;
    } else if (galleryItem.name?.isNotEmpty == true) {
      return galleryItem.name!;
    } else {
      return 'صورة ${index + 1}';
    }
  } else {
    // إذا كانت اللغة إنجليزية، اعرض الاسم الإنجليزي أولاً
    if (galleryItem.name?.isNotEmpty == true) {
      return galleryItem.name!;
    } else if (galleryItem.arabicName?.isNotEmpty == true) {
      return galleryItem.arabicName!;
    } else {
      return 'Image ${index + 1}';
    }
  }
}

/// الحصول على الوصف المعروض حسب اللغة الحالية
String _getDisplayDescription(dynamic galleryItem) {
  final languageController = Get.find<LanguageController>();
  
  if (languageController.isArabic) {
    // إذا كانت اللغة عربية، اعرض الوصف العربي أولاً
    if (galleryItem.arabicDescription?.isNotEmpty == true) {
      return galleryItem.arabicDescription!;
    } else if (galleryItem.description?.isNotEmpty == true) {
      return galleryItem.description!;
    } else {
      return '';
    }
  } else {
    // إذا كانت اللغة إنجليزية، اعرض الوصف الإنجليزي أولاً
    if (galleryItem.description?.isNotEmpty == true) {
      return galleryItem.description!;
    } else if (galleryItem.arabicDescription?.isNotEmpty == true) {
      return galleryItem.arabicDescription!;
    } else {
      return '';
    }
  }
}
```

### 3. استخدام الدوال في العرض
```dart
// عرض الاسم
Text(
  _getDisplayName(galleryItem, index),
  // ... باقي الخصائص
),

// عرض الوصف
Text(
  _getDisplayDescription(galleryItem),
  // ... باقي الخصائص
),
```

## الترجمات المضافة

### الإنجليزية
```dart
'viewAll': 'View All',
'imageLoadError': 'Error loading image',
```

### العربية
```dart
'viewAll': 'عرض الكل',
'imageLoadError': 'خطأ في تحميل الصورة',
```

## الميزات الجديدة

### 1. دعم متعدد اللغات
- ✅ عرض الأسماء حسب اللغة المختارة
- ✅ عرض الأوصاف حسب اللغة المختارة
- ✅ ترجمة جميع النصوص الثابتة
- ✅ تحديث تلقائي عند تغيير اللغة

### 2. منطق العرض الذكي
- ✅ الأولوية للغة المختارة
- ✅ عرض البديل إذا لم تكن اللغة المفضلة متوفرة
- ✅ أسماء افتراضية باللغة المختارة

### 3. تجربة مستخدم محسنة
- ✅ واجهة متسقة مع باقي التطبيق
- ✅ دعم كامل للوضع المظلم والفاتح
- ✅ تحديث فوري عند تغيير اللغة

## كيفية الاستخدام

### 1. تغيير اللغة
```dart
// تغيير إلى العربية
LanguageController.to.changeToArabic();

// تغيير إلى الإنجليزية
LanguageController.to.changeToEnglish();
```

### 2. التحقق من اللغة الحالية
```dart
if (LanguageController.to.isArabic) {
  // اللغة العربية مفعلة
}

if (LanguageController.to.isEnglish) {
  // اللغة الإنجليزية مفعلة
}
```

## الاختبار

### 1. اختبار الأسماء
- [x] عرض الاسم العربي عند اختيار العربية
- [x] عرض الاسم الإنجليزي عند اختيار الإنجليزية
- [x] عرض البديل عند عدم توفر اللغة المفضلة
- [x] أسماء افتراضية باللغة المختارة

### 2. اختبار الأوصاف
- [x] عرض الوصف العربي عند اختيار العربية
- [x] عرض الوصف الإنجليزي عند اختيار الإنجليزية
- [x] عدم عرض الوصف عند عدم توافره

### 3. اختبار الترجمة
- [x] ترجمة جميع النصوص الثابتة
- [x] تحديث فوري عند تغيير اللغة
- [x] دعم الوضع المظلم والفاتح

## النتيجة

الآن تعرض صفحة `mobile_gallery_widget.dart`:
- ✅ **أسماء الألبومات حسب اللغة المختارة**
- ✅ **أوصاف الألبومات حسب اللغة المختارة**
- ✅ **ترجمة كاملة لجميع النصوص**
- ✅ **تحديث تلقائي عند تغيير اللغة**
- ✅ **تجربة مستخدم محسنة ومتسقة**
