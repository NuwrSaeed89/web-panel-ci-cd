# Firebase Storage Web Setup - إعداد Firebase Storage للويب

## المشكلة
الصور لا تظهر في المتصفح (Google Chrome) بسبب مشاكل CORS مع Firebase Storage.

## الحلول

### 1. تحديث firebase.json
أضف إعدادات CORS للـ Storage:

```json
{
  "storage": {
    "rules": "storage.rules",
    "cors": [
      {
        "origin": ["*"],
        "method": ["GET", "POST", "PUT", "DELETE", "HEAD"],
        "maxAgeSeconds": 3600,
        "responseHeader": ["Content-Type", "Access-Control-Allow-Origin"]
      }
    ]
  }
}
```

### 2. تطبيق إعدادات CORS
```bash
firebase deploy --only storage
```

### 3. التحقق من قواعد Storage
تأكد من أن `storage.rules` تسمح بالقراءة:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### 4. إعدادات Firebase Console
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. اختر مشروعك
3. اذهب إلى Storage
4. تأكد من أن القواعد تسمح بالقراءة العامة

### 5. اختبار الصور
```bash
# اختبار URL الصورة مباشرة في المتصفح
# يجب أن تعمل بدون أخطاء CORS
```

## ملاحظات مهمة
- إعدادات CORS تعمل فقط مع Firebase Storage
- تأكد من أن الصور تم رفعها بنجاح
- استخدم `CustomCachedNetworkImage` بدلاً من `Image.network`

## استكشاف الأخطاء
1. افتح Developer Tools في المتصفح
2. اذهب إلى Network tab
3. ابحث عن طلبات الصور
4. تحقق من status codes وأخطاء CORS
