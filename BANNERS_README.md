# نظام إدارة البنرات - Banner Management System

## نظرة عامة
تم إنشاء نظام شامل لإدارة البنرات الإعلانية في لوحة الإدارة، مع دعم كامل لعمليات CRUD (إنشاء، قراءة، تحديث، حذف) وإدارة الصور.

## الميزات الرئيسية

### 1. عرض البنرات
- عرض البنرات في شبكة منظمة (3 أعمدة)
- عرض حالة البانر (نشط/غير نشط)
- عرض صورة البانر والشاشة المستهدفة

### 2. إضافة بانر جديد
- رفع صورة من المعرض أو الكاميرا
- تحديد الشاشة المستهدفة
- تحديد حالة البانر (نشط/غير نشط)

### 3. تعديل البنرات
- تعديل صورة البانر
- تعديل الشاشة المستهدفة
- تغيير حالة البانر

### 4. حذف البنرات
- تأكيد الحذف مع رسالة تحذير
- حذف فوري من قاعدة البيانات

### 5. البحث والتصفية
- بحث في البنرات حسب النص
- تحديث البيانات
- عرض عدد البنرات

## الملفات المطلوبة

### 1. النماذج (Models)
- `lib/data/models/banner_model.dart` - نموذج بيانات البانر

### 2. المستودعات (Repositories)
- `lib/data/repositories/banners/banner_repository.dart` - عمليات قاعدة البيانات

### 3. المتحكمات (Controllers)
- `lib/features/dashboard/controllers/banner_controller.dart` - منطق إدارة البنرات

### 4. الشاشات (Screens)
- `lib/features/dashboard/screens/banners_screen.dart` - واجهة المستخدم

### 5. الربط (Bindings)
- `lib/features/dashboard/bindings/banner_binding.dart` - تسجيل التبعيات

### 6. المسارات (Routes)
- `lib/features/dashboard/routes/banner_routes.dart` - مسارات البنرات

## المكتبات المطلوبة

```yaml
dependencies:
  image_picker: ^1.0.7  # لاختيار الصور
  get: ^4.6.5           # لإدارة الحالة والتنقل
  cloud_firestore: ^5.6.0  # لقاعدة البيانات
```

## كيفية الاستخدام

### 1. تسجيل النظام
```dart
// في main.dart أو app_binding.dart
Get.lazyPut<BannerRepository>(() => BannerRepository());
Get.lazyPut<BannerController>(() => BannerController());
```

### 2. إضافة المسارات
```dart
// في app_routes.dart
import 'package:brother_admin_panel/features/dashboard/routes/banner_routes.dart';

// إضافة مسارات البنرات
GetPage(
  name: '/banners',
  page: () => const BannersScreen(),
  binding: BannerBinding(),
),
```

### 3. التنقل إلى شاشة البنرات
```dart
Get.toNamed('/banners');
```

## هيكل قاعدة البيانات

### مجموعة Banners في Firestore
```json
{
  "id": "auto_generated_id",
  "Image": "url_or_path_to_image",
  "TargetScreen": "اسم الشاشة المستهدفة",
  "Active": true/false
}
```

## العمليات المدعومة

### 1. إنشاء بانر
```dart
final banner = BannerModel(
  id: '',
  image: 'image_url',
  targetScreen: 'الصفحة الرئيسية',
  active: true,
);
await bannerController.createBanner(banner);
```

### 2. تحديث بانر
```dart
final updatedBanner = BannerModel(
  id: 'existing_id',
  image: 'new_image_url',
  targetScreen: 'صفحة المنتجات',
  active: false,
);
await bannerController.updateBanner(updatedBanner);
```

### 3. حذف بانر
```dart
await bannerController.deleteBanner('banner_id');
```

### 4. تغيير حالة البانر
```dart
await bannerController.toggleActiveStatus('banner_id');
```

## إدارة الصور

### 1. اختيار صورة من المعرض
```dart
await bannerController.pickImageFromGallery();
```

### 2. التقاط صورة بالكاميرا
```dart
await bannerController.pickImageFromCamera();
```

### 3. إزالة الصورة المحددة
```dart
bannerController.removeSelectedImage();
```

## البحث والتصفية

### 1. البحث في البنرات
```dart
bannerController.searchBanners('نص البحث');
```

### 2. مسح البحث
```dart
bannerController.clearSearch();
```

### 3. تحديث البيانات
```dart
await bannerController.refreshData();
```

## التخصيص

### 1. تغيير عدد الأعمدة في الشبكة
```dart
// في banners_screen.dart
crossAxisCount: 3, // تغيير إلى 2 أو 4 حسب الحاجة
```

### 2. تغيير نسبة العرض إلى الارتفاع
```dart
childAspectRatio: 16 / 9, // تغيير حسب تصميم البنرات
```

### 3. تخصيص الألوان
```dart
// تغيير الألوان في ThemeController
backgroundColor: const Color(0xFF0055ff), // اللون الرئيسي
```

## استكشاف الأخطاء

### 1. مشاكل في تحميل الصور
- تأكد من وجود صلاحيات الوصول للمعرض/الكاميرا
- تحقق من حجم الصورة وجودتها

### 2. مشاكل في قاعدة البيانات
- تحقق من اتصال Firebase
- تأكد من قواعد الأمان في Firestore

### 3. مشاكل في التحديث
- تأكد من تسجيل BannerController
- تحقق من وجود BannerRepository

## التطوير المستقبلي

### 1. دعم تعديل الصور (Crop)
- إضافة مكتبة image_cropper
- دعم نسب أبعاد مختلفة

### 2. رفع الصور إلى Firebase Storage
- رفع الصور المحلية إلى Storage
- الحصول على URLs دائمة

### 3. دعم أنواع البنرات المختلفة
- بنرات ثابتة
- بنرات متحركة
- بنرات تفاعلية

### 4. إحصائيات البنرات
- عدد المشاهدات
- معدل النقر
- تحليل الأداء

## الدعم والمساعدة

لأي استفسارات أو مشاكل، يرجى التواصل مع فريق التطوير أو مراجعة الوثائق الرسمية.
