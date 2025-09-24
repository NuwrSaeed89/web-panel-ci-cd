# Mobile Simulator Widgets

هذا المجلد يحتوي على صفحات المحاكي المنظمة في widgets منفصلة.

## الملفات

### 1. `mobile_categories_widget.dart`
- **الوظيفة**: عرض الفئات في شاشة المحاكي
- **الميزات**: 
  - عرض الفئات المميزة
  - دعم الوضع الدارك
  - تحديث تلقائي عند تغيير الفئات

### 2. `mobile_banners_widget.dart`
- **الوظيفة**: عرض البنرات في شاشة المحاكي
- **الميزات**:
  - عرض البنرات في قائمة أفقية
  - دعم الوضع الدارك
  - تحديث تلقائي عند تغيير البنرات

### 3. `mobile_gallery_widget.dart`
- **الوظيفة**: عرض الألبومات في شاشة المحاكي
- **الميزات**:
  - عرض الألبومات مع الصور
  - دعم الوضع الدارك
  - تحديث تلقائي عند تغيير الألبومات

### 4. `mobile_clients_widget.dart`
- **الوظيفة**: عرض العملاء في شاشة المحاكي
- **الميزات**:
  - عرض العملاء المميزين
  - دعم الوضع الدارك
  - تحديث تلقائي عند تغيير العملاء

### 5. `mobile_dashboard_widget.dart`
- **الوظيفة**: عرض لوحة التحكم في شاشة المحاكي
- **الميزات**:
  - إحصائيات سريعة
  - إجراءات سريعة
  - دعم الوضع الدارك

### 6. `mobile_settings_widget.dart`
- **الوظيفة**: عرض الإعدادات في شاشة المحاكي
- **الميزات**:
  - إعدادات المظهر
  - إعدادات اللغة
  - إعدادات أخرى

### 7. `mobile_products_widget.dart`
- **الوظيفة**: عرض المنتجات في شاشة المحاكي
- **الميزات**:
  - عرض المنتجات مع الصور
  - دعم الوضع الدارك
  - تحديث تلقائي عند تغيير المنتجات

### 8. `index.dart`
- **الوظيفة**: تصدير جميع الـ widgets
- **الاستخدام**: `import 'package:brother_admin_panel/common/widgets/mobile_simulator/index.dart';`

## كيفية الاستخدام

```dart
import 'package:brother_admin_panel/common/widgets/mobile_simulator/index.dart';

// في MobileScreenSimulator
Widget _getTabContent(int tabIndex) {
  switch (tabIndex) {
    case 0:
      return const MobileDashboardWidget();
    case 4:
      return const MobileCategoriesWidget();
    case 6:
      return const MobileProductsWidget();
    case 8:
      return const MobileGalleryWidget();
    case 9:
      return const MobileBannersWidget();
    case 10:
      return const MobileClientsWidget();
    case 11:
      return const MobileSettingsWidget();
    default:
      return const MobileDashboardWidget();
  }
}
```

## المزايا

1. **تنظيم أفضل**: كل صفحة في ملف منفصل
2. **سهولة الصيانة**: تعديل صفحة واحدة دون التأثير على الباقي
3. **إعادة الاستخدام**: يمكن استخدام الـ widgets في أماكن أخرى
4. **أداء أفضل**: تحميل الـ widgets عند الحاجة فقط
5. **قابلية القراءة**: كود أكثر وضوحاً وسهولة في الفهم

## إضافة صفحة جديدة

1. أنشئ ملف جديد في المجلد
2. اتبع نفس النمط المستخدم في الملفات الموجودة
3. أضف الـ widget إلى `index.dart`
4. استخدم الـ widget في `MobileScreenSimulator`

## مثال على إضافة صفحة جديدة

```dart
// mobile_new_page_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';

class MobileNewPageWidget extends StatelessWidget {
  const MobileNewPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الصفحة الجديدة',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          // محتوى الصفحة
        ],
      ),
    );
  }
}
```

---

**تم إنشاؤه بواسطة**: فريق Brothers Creative  
**التاريخ**: 2024  
**الإصدار**: 1.0.0
