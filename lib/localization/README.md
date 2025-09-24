# نظام الترجمة (Localization System)

## نظرة عامة
تم إنشاء نظام ترجمة كامل للمشروع باستخدام GetX لدعم اللغتين العربية والإنجليزية.

## الملفات المطلوبة

### 1. `translations.dart`
يحتوي على جميع النصوص المترجمة باللغتين العربية والإنجليزية.

### 2. `language_controller.dart`
يدير تغيير اللغة وحفظ اللغة المفضلة للمستخدم.

### 3. `app_en.arb` و `app_ar.arb`
ملفات الترجمة القياسية (اختيارية).

## كيفية الاستخدام

### استخدام الترجمة في الكود:
```dart
// استخدام الترجمة
Text('appTitle'.tr)  // سيظهر "Brothers Creative" أو "براذرز كرياتيف"

// استخدام الترجمة مع متغيرات
Text('welcomeMessage'.trParams({'name': 'John'}))
```

### تغيير اللغة:
```dart
// تغيير إلى العربية
LanguageController.to.changeToArabic();

// تغيير إلى الإنجليزية
LanguageController.to.changeToEnglish();

// تغيير لغة محددة
LanguageController.to.changeLanguage('ar');
```

### التحقق من اللغة الحالية:
```dart
if (LanguageController.to.isArabic) {
  // اللغة العربية مفعلة
}

if (LanguageController.to.isEnglish) {
  // اللغة الإنجليزية مفعلة
}
```

## إضافة نصوص جديدة

### 1. إضافة النص في `translations.dart`:
```dart
'en': {
  'newText': 'New Text in English',
  // ... باقي النصوص
},
'ar': {
  'newText': 'نص جديد بالعربية',
  // ... باقي النصوص
},
```

### 2. استخدام النص في الكود:
```dart
Text('newText'.tr)
```

## الميزات

- ✅ دعم اللغتين العربية والإنجليزية
- ✅ حفظ اللغة المفضلة للمستخدم
- ✅ تغيير اللغة في الوقت الفعلي
- ✅ دعم النصوص الديناميكية
- ✅ سهولة الاستخدام مع GetX
- ✅ أداء عالي

## ملاحظات مهمة

1. تأكد من إضافة `Get.put(LanguageController())` في `main.dart`
2. استخدم `.tr` بعد كل مفتاح ترجمة
3. احفظ اللغة عند تغييرها
4. استخدم `GetBuilder<LanguageController>` للتحديث التلقائي
