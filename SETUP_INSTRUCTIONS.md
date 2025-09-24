# 🚀 تعليمات تشغيل Clean Architecture مع Riverpod

## 📋 المتطلبات

- Flutter 3.6.1+
- Dart 3.0.0+
- Firebase CLI (اختياري)

## 🔧 خطوات التشغيل

### 1. تثبيت Dependencies
```bash
flutter pub get
```

### 2. إنشاء الكود المُنشأ (Code Generation)
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**أو لمراقبة التغييرات:**
```bash
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

### 3. تشغيل التطبيق
```bash
flutter run -d chrome --web-port=8080
```

## 🏗️ هيكل الملفات المُنشأة

بعد تشغيل `build_runner`، سيتم إنشاء الملفات التالية:

```
lib/
├── domain/entities/
│   └── product_entity.freezed.dart    # ✅ مُنشأ
│   └── product_entity.g.dart          # ✅ مُنشأ
├── core/error/
│   └── failures.freezed.dart          # ✅ مُنشأ
├── data/models/
│   └── product_model.freezed.dart     # ✅ مُنشأ
│   └── product_model.g.dart           # ✅ مُنشأ
```

## 🔍 حل المشاكل الشائعة

### مشكلة: "Target of URI doesn't exist"
**الحل:** تشغيل `build_runner` أولاً
```bash
flutter packages pub run build_runner build
```

### مشكلة: "The name '_ProductEntity' isn't a type"
**الحل:** تأكد من تشغيل `build_runner` وتحديث الملفات

### مشكلة: "Method 'copyWith' isn't defined"
**الحل:** Freezed لم يتم تشغيله بعد

## 📱 استخدام الملفات الجديدة

### 1. استبدال صفحة المنتجات القديمة
```dart
// في routes أو navigation
import 'package:brother_admin_panel/presentation/pages/products_page.dart';

// استبدال
ProductsScreen() 
// بـ
ProductsPage()
```

### 2. استخدام Providers الجديدة
```dart
// في أي widget
Consumer(
  builder: (context, ref, child) {
    final productsAsync = ref.watch(allProductsProvider);
    return productsAsync.when(
      data: (products) => ListView.builder(...),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  },
)
```

## 🎯 المميزات الجديدة

### ✅ **Clean Architecture:**
- فصل واضح بين الطبقات
- كود قابل للاختبار
- قابل للصيانة والتوسع

### ✅ **Riverpod:**
- إدارة حالة فعالة
- Type safety كامل
- Tree shaking تلقائي

### ✅ **Freezed:**
- نماذج قابلة للتغيير
- JSON serialization
- copyWith, toString, equals تلقائياً

## 🔄 الهجرة التدريجية

### المرحلة 1: ✅ مكتملة
- [x] إضافة dependencies
- [x] إنشاء هيكل Clean Architecture
- [x] إنشاء Product Entity
- [x] إنشاء Product Repository Interface
- [x] إنشاء Product Use Cases
- [x] إنشاء Product Repository Implementation
- [x] إنشاء Product Providers
- [x] إنشاء صفحة المنتجات الجديدة

### المرحلة 2: قيد التطوير
- [ ] إنشاء Category Entity
- [ ] إنشاء Brand Entity
- [ ] إنشاء User Entity
- [ ] إنشاء Order Entity

### المرحلة 3: مستقبلية
- [ ] إنشاء Authentication
- [ ] إنشاء Dashboard
- [ ] إنشاء Reports
- [ ] إنشاء Settings

## 🧪 الاختبار

### تشغيل الاختبارات
```bash
flutter test
```

### تحليل الكود
```bash
flutter analyze
```

### تنسيق الكود
```bash
dart format lib/
```

## 📚 الأوامر المفيدة

### باستخدام Makefile
```bash
make help          # عرض جميع الأوامر
make install       # تثبيت dependencies
make build         # إنشاء الكود
make run-web       # تشغيل على الويب
make clean         # تنظيف المشروع
make test          # تشغيل الاختبارات
make analyze       # تحليل الكود
```

### باستخدام Scripts
```bash
# Windows
scripts\setup.bat
scripts\clean.bat

# PowerShell
scripts\setup.ps1
scripts\clean.ps1

# Linux/macOS
scripts/setup.sh
scripts/clean.sh
```

## 🚨 ملاحظات مهمة

1. **لا تقم بحذف ملفات `.freezed.dart` و `.g.dart`** - هذه ملفات مُنشأة
2. **أعد تشغيل `build_runner`** عند تغيير أي model
3. **استخدم `ref.watch()`** للمراقبة المستمرة
4. **استخدم `ref.read()`** للقراءة مرة واحدة
5. **استخدم `ref.invalidate()`** لتحديث البيانات

## 🎉 تم بنجاح!

الآن لديك:
- ✅ Clean Architecture كامل
- ✅ Riverpod لإدارة الحالة
- ✅ Freezed للنماذج
- ✅ صفحة منتجات جديدة
- ✅ Repository pattern
- ✅ Use Cases
- ✅ Error handling
- ✅ Type safety

يمكنك الآن البدء في استخدام النظام الجديد!
