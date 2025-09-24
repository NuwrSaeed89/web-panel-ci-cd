# إعداد Firebase للـ OTP (رمز التحقق)

## 📋 المتطلبات الأساسية

### 1. تفعيل Phone Authentication في Firebase Console

1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. اختر مشروعك
3. اذهب إلى **Authentication** > **Sign-in method**
4. فعّل **Phone** provider
5. أضف رقم هاتف للاختبار في **Test phone numbers**

### 2. إعداد Firebase Rules

#### Authentication Rules
```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```

#### Firestore Rules
```json
{
  "rules": {
    "permissions": {
      ".read": "auth != null",
      ".write": "auth != null"
    }
  }
}
```

### 3. إعداد Android

#### في ملف `android/app/build.gradle`
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

#### في ملف `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

### 4. إعداد iOS

#### في ملف `ios/Runner/Info.plist`
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

### 5. إعداد Web (اختياري)

#### في ملف `web/index.html`
```html
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.0.0/firebase-auth.js"></script>
```

## 🔧 إعدادات Firebase Console

### 1. إضافة أرقام الهواتف للاختبار
- اذهب إلى **Authentication** > **Sign-in method** > **Phone**
- أضف أرقام الهواتف في **Test phone numbers**
- مثال: `+966501234567` مع رمز التحقق `123456`

### 2. إعداد Quotas
- اذهب إلى **Authentication** > **Usage**
- اضبط **SMS daily quota** حسب احتياجاتك
- الافتراضي: 10,000 رسالة يومياً

### 3. إعداد App Check (اختياري)
- اذهب إلى **App Check**
- فعّل **App Check** لحماية أفضل
- أضف **SafetyNet** للـ Android

## 📱 اختبار OTP

### 1. أرقام الاختبار
```
رقم الهاتف: +966501234567
رمز التحقق: 123456
```

### 2. تدفق العمل
1. المستخدم يدخل رقم الهاتف
2. النظام يتحقق من الصلاحيات
3. إرسال OTP عبر Firebase
4. المستخدم يدخل الرمز
5. التحقق من الرمز
6. تسجيل الدخول

## 🚨 ملاحظات مهمة

### 1. التكاليف
- Firebase يفرض رسوم على رسائل SMS
- السعر: ~$0.01 لكل رسالة
- استخدم أرقام الاختبار لتجنب التكاليف

### 2. الأمان
- تأكد من تفعيل **App Check**
- استخدم **reCAPTCHA** للويب
- حدد **SMS quotas** لتجنب الإساءة

### 3. الأداء
- OTP صالح لمدة 10 دقائق
- يمكن إعادة الإرسال بعد 60 ثانية
- الحد الأقصى: 5 محاولات في الساعة

## 🔍 استكشاف الأخطاء

### 1. أخطاء شائعة
```
invalid-phone-number: رقم الهاتف غير صحيح
too-many-requests: طلبات كثيرة
quota-exceeded: تجاوز الحد المسموح
invalid-verification-code: رمز التحقق غير صحيح
```

### 2. حلول
- تأكد من تنسيق رقم الهاتف (+966XXXXXXXXX)
- تحقق من إعدادات Firebase
- تأكد من تفعيل Phone Authentication
- تحقق من صحة ملفات التكوين

## 📞 دعم إضافي

- [Firebase Phone Auth Documentation](https://firebase.google.com/docs/auth/flutter/phone)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
