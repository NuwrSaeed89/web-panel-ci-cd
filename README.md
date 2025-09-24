# 🏪 Brother Admin Panel

لوحة تحكم متقدمة لإدارة المتجر الإلكتروني، مبنية باستخدام Flutter مع Clean Architecture و Riverpod.

## 🚀 المميزات

- ✅ إدارة الفئات والمنتجات
- ✅ رفع وإدارة الصور
- ✅ نظام مصادقة آمن
- ✅ واجهة مستخدم حديثة
- ✅ دعم متعدد اللغات
- ✅ تصميم متجاوب

## 🏗️ التقنيات المستخدمة

- **Frontend**: Flutter 3.6.1
- **State Management**: Riverpod 2.4.9
- **Architecture**: Clean Architecture
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Code Generation**: Freezed, JSON Serializable, Retrofit

## 📱 المنصات المدعومة

- 🌐 Web (Chrome, Firefox, Safari)
- 📱 Android (API 21+)
- 🍎 iOS (12.0+)
- 🪟 Windows
- 🐧 Linux
- 🖥️ macOS

## 🛠️ التثبيت والتشغيل

### المتطلبات
- Flutter 3.6.1+
- Dart 3.0.0+
- Firebase CLI

### التثبيت
```bash
# استنساخ المشروع
git clone <repository-url>
cd brother_admin_panel

# تثبيت dependencies
flutter pub get

# إنشاء الكود المُنشأ
flutter packages pub run build_runner build

# تشغيل التطبيق
flutter run -d chrome --web-port=8080
```

### الأوامر المفيدة
```bash
# تحديث dependencies
flutter pub upgrade

# إنشاء الكود
flutter packages pub run build_runner build

# مراقبة التغييرات
flutter packages pub run build_runner watch

# تنظيف الكود
flutter packages pub run build_runner clean

# تحليل الكود
flutter analyze

# تشغيل الاختبارات
flutter test
```

## 🏛️ هيكل المشروع

```
lib/
├── 📱 presentation/          # طبقة العرض
│   ├── pages/               # الصفحات
│   ├── widgets/              # العناصر
│   └── providers/            # مزودي الحالة
├── 🔧 domain/                # طبقة منطق الأعمال
│   ├── entities/             # الكيانات
│   ├── repositories/         # واجهات المستودعات
│   ├── usecases/             # حالات الاستخدام
│   └── failures/             # أنواع الفشل
├── 💾 data/                  # طبقة البيانات
│   ├── datasources/          # مصادر البيانات
│   ├── models/               # نماذج البيانات
│   └── repositories/         # تنفيذ المستودعات
└── 🏗️ core/                  # الخدمات المشتركة
    ├── error/                # معالجة الأخطاء
    ├── network/              # خدمات الشبكة
    ├── utils/                # أدوات مساعدة
    └── constants/            # الثوابت
```

## 🔧 الإعدادات

### Firebase
1. إنشاء مشروع Firebase جديد
2. تفعيل Authentication, Firestore, Storage
3. تحديث `lib/firebase_options.dart`
4. رفع قواعد الأمان

### CORS (للويب)
```bash
# رفع قواعد CORS
firebase deploy --only storage
```

## 📚 الوثائق

- [Clean Architecture Guide](CLEAN_ARCHITECTURE_README.md)
- [Firebase Setup](FIREBASE_STORAGE_README.md)
- [Dark Mode](DARK_MODE_README.md)

## 🤝 المساهمة

1. Fork المشروع
2. إنشاء branch جديد (`git checkout -b feature/amazing-feature`)
3. Commit التغييرات (`git commit -m 'Add amazing feature'`)
4. Push إلى branch (`git push origin feature/amazing-feature`)
5. فتح Pull Request

## 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](LICENSE) للتفاصيل.

## 📞 الدعم

للدعم والاستفسارات:
- 📧 البريد الإلكتروني: [your-email@example.com]
- 🐛 تقارير الأخطاء: [Issues](https://github.com/username/repo/issues)
- 💬 المناقشات: [Discussions](https://github.com/username/repo/discussions)

---

**تم التطوير بـ ❤️ باستخدام Flutter و Clean Architecture**
