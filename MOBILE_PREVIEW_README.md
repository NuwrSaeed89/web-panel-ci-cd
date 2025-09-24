# شاشة الموبايل العائمة - Mobile Preview Widget

## نظرة عامة
شاشة الموبايل العائمة هي ميزة تسمح بعرض محتوى التطبيق كما سيظهر على الهاتف المحمول، مع إمكانية التحديث التلقائي عند إجراء تغييرات على البيانات.

## الميزات

### 🎯 الميزات الأساسية
- **عرض تلقائي**: تظهر فقط في المتصفح (Web)
- **قابلة للسحب**: يمكن تحريكها في جميع أنحاء الشاشة
- **قابلة للإغلاق**: زر X لإغلاق الشاشة
- **قابلة لتغيير الحجم**: بالسحب من الزاوية السفلية اليمنى
- **تحديث تلقائي**: مع تغيير التاب الحالي

### 📱 محتوى الشاشة
- **شريط الحالة**: محاكي لشريط حالة الهاتف
- **شريط التنقل**: مع زر الرجوع وعنوان الصفحة
- **محتوى ديناميكي**: يتغير حسب التاب المحدد

### 🔄 التحديث التلقائي
- **الفئات**: تحديث فوري عند إضافة/تعديل/حذف فئة
- **البنرات**: تحديث فوري عند إضافة/تعديل/حذف بانر
- **التابات**: تحديث فوري عند تغيير التاب

## كيفية الاستخدام

### 1. فتح شاشة الموبايل العائمة
```dart
// اضغط على أيقونة الهاتف في الهيدر
IconButton(
  onPressed: () => mobilePreviewController.toggleMobilePreview(),
  icon: Icon(Icons.phone_android),
)
```

### 2. تحريك الشاشة
```dart
// اسحب من أي مكان في الشاشة
GestureDetector(
  onPanUpdate: (details) {
    mobilePreviewController.updatePosition(newPosition);
  },
)
```

### 3. تغيير الحجم
```dart
// اسحب من الزاوية السفلية اليمنى
GestureDetector(
  onPanUpdate: (details) {
    mobilePreviewController.updateSize(newSize);
  },
)
```

## الملفات المطلوبة

### Controllers
- `MobilePreviewController`: إدارة حالة الشاشة العائمة
- `CategoryController`: إدارة بيانات الفئات
- `BannerController`: إدارة بيانات البنرات

### Widgets
- `MobilePreviewWidget`: الشاشة العائمة الرئيسية
- `MobileScreenSimulator`: محاكي شاشة الموبايل
- `TVerticalImageText`: عرض الفئات
- `TSectionHeading`: عناوين الأقسام

## التكوين

### 1. تهيئة Controllers
```dart
// في dashboard.dart
if (kIsWeb) {
  Get.put(MobilePreviewController());
  
  // إضافة listener للتحديث التلقائي
  _tabController.addListener(() {
    if (Get.isRegistered<MobilePreviewController>()) {
      Get.find<MobilePreviewController>().update();
    }
  });
}
```

### 2. إضافة زر التحكم
```dart
// في الهيدر
if (kIsWeb)
  GetBuilder<MobilePreviewController>(
    builder: (mobilePreviewController) {
      return IconButton(
        onPressed: () => mobilePreviewController.toggleMobilePreview(),
        icon: Icon(Icons.phone_android),
      );
    },
  ),
```

### 3. إضافة الشاشة العائمة
```dart
// في المحتوى الرئيسي
if (kIsWeb)
  MobilePreviewWidget(
    currentTabIndex: _tabController.index,
    child: MobileScreenSimulator(
      currentTabIndex: _tabController.index,
    ),
  ),
```

## التخصيص

### تغيير الحجم الافتراضي
```dart
// في MobilePreviewController
static const double minWidth = 280;
static const double maxWidth = 400;
static const double minHeight = 500;
static const double maxHeight = 800;
```

### تغيير الموضع الافتراضي
```dart
// في MobilePreviewController
final Rx<Offset> position = const Offset(20, 100).obs;
```

### إضافة محتوى جديد
```dart
// في MobileScreenSimulator
Widget _buildMobileNewFeature() {
  return GetBuilder<NewFeatureController>(
    builder: (controller) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // محتوى الميزة الجديدة
          ],
        ),
      );
    },
  );
}
```

## استكشاف الأخطاء

### المشكلة: الشاشة لا تظهر
**الحل**: تأكد من أن `kIsWeb` يعيد `true`

### المشكلة: المحتوى لا يتحدث
**الحل**: تأكد من إضافة `GetBuilder` أو `Obx` للـ controllers

### المشكلة: الشاشة لا تتحرك
**الحل**: تأكد من إضافة `GestureDetector` مع `onPanUpdate`

## الدعم

للمساعدة أو الإبلاغ عن مشاكل، يرجى التواصل مع فريق التطوير.

---

**تم إنشاؤه بواسطة**: فريق Brothers Creative  
**التاريخ**: 2024  
**الإصدار**: 1.0.0
