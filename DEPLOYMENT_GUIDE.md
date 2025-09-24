# دليل رفع التطبيق إلى الخادم

## الخطوات المطلوبة لرفع التطبيق

### 1. بناء التطبيق للويب
```bash
# تنظيف المشروع
flutter clean

# الحصول على التبعيات
flutter pub get

# بناء التطبيق للويب
flutter build web --rel
```

### 2. مجلد البناء
بعد البناء الناجح، ستجد الملفات في مجلد `build/web/` تحتوي على:
- `index.html` - الصفحة الرئيسية
- `main.dart.js` - ملف JavaScript الرئيسي
- `assets/` - الصور والخطوط والملفات الثابتة
- `canvaskit/` - مكتبة CanvasKit

### 3. خيارات الرفع

#### أ) رفع إلى Firebase Hosting
```bash
# تثبيت Firebase CLI
npm install -g firebase-tools

# تسجيل الدخول
firebase login

# تهيئة المشروع
firebase init hosting

# رفع التطبيق
firebase deploy
```

#### ب) رفع إلى Netlify
1. اذهب إلى [netlify.com](https://netlify.com)
2. اسحب مجلد `build/web/` إلى منطقة الرفع
3. أو استخدم Netlify CLI:
```bash
npm install -g netlify-cli
netlify deploy --dir=build/web --prod
```

#### ج) رفع إلى Vercel
```bash
npm install -g vercel
vercel --prod build/web
```

#### د) رفع إلى خادم عادي
1. ارفع محتويات مجلد `build/web/` إلى مجلد `public_html` أو `www`
2. تأكد من أن الخادم يدعم SPA (Single Page Application)
3. أضف ملف `.htaccess` للمساعدة في التوجيه:

```apache
RewriteEngine On
RewriteBase /
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.html [L]
```

### 4. إعدادات مهمة

#### Firebase Configuration
تأكد من أن ملف `web/index.html` يحتوي على إعدادات Firebase الصحيحة:
```html
<script type="module">
  import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
  import { getAuth } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";
  import { getFirestore } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";
  import { getStorage } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-storage.js";

  const firebaseConfig = {
    apiKey: "your-api-key",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-project-id",
    storageBucket: "your-project.appspot.com",
    messagingSenderId: "123456789",
    appId: "your-app-id"
  };

  const app = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db = getFirestore(app);
  const storage = getStorage(app);
</script>
```

### 5. اختبار التطبيق
بعد الرفع، تأكد من:
- [ ] تسجيل الدخول يعمل
- [ ] عرض الفئات والمنتجات
- [ ] رفع الصور يعمل
- [ ] التعديل والحذف يعمل
- [ ] جميع الصفحات تعمل بشكل صحيح

### 6. نصائح مهمة
- تأكد من أن Firebase Storage مُفعل في مشروعك
- تحقق من قواعد الأمان في Firestore
- تأكد من أن CORS مُفعل للصور
- اختبر التطبيق على أجهزة مختلفة

## استكشاف الأخطاء

### مشكلة في بناء التطبيق
إذا واجهت مشكلة في البناء:
```bash
# تنظيف كامل
flutter clean
rm -rf build/
rm -rf .dart_tool/

# إعادة التثبيت
flutter pub get
flutter build web --release --no-tree-shake-icons
```

### مشكلة في الصور
تأكد من أن جميع الصور في مجلد `assets/images/` موجودة وصحيحة.

### مشكلة في Firebase
تحقق من إعدادات Firebase في `lib/firebase_options.dart`.
