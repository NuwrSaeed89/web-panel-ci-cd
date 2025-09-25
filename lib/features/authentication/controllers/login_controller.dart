import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brother_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/utils/helpers/snackbar_helper.dart';
import 'package:flutter/foundation.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final privacyPolicy = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  @override
  void onReady() {
    super.onReady();
    // إعادة تحميل البيانات المحفوظة عند جاهزية الواجهة
    _loadSavedCredentials();
  }

  /// تحميل البيانات المحفوظة من التخزين المحلي
  void _loadSavedCredentials() {
    try {
      final savedEmail = localStorage.read('REMEMBER_ME_EMAIL');
      final savedPassword = localStorage.read('REMEMBER_ME_PASSWORD');
      final savedRememberMe = localStorage.read('REMEMBER_ME_STATE');

      if (kDebugMode) {
        print('🔍 فحص البيانات المحفوظة:');
        print('📧 Saved Email: ${savedEmail ?? 'null'}');
        print(
            '🔑 Saved Password: ${savedPassword != null ? '${savedPassword.substring(0, 3)}***' : 'null'}');
        print('💾 Saved Remember Me: ${savedRememberMe ?? 'null'}');
      }

      // إذا كانت هناك بيانات محفوظة، فعّل "تذكرني" واملأ الحقول
      if (savedEmail != null &&
          savedPassword != null &&
          savedEmail.isNotEmpty &&
          savedPassword.isNotEmpty) {
        // تحديث حالة "تذكرني"
        rememberMe.value = savedRememberMe ?? true;

        // ملء الحقول بالبيانات المحفوظة
        email.text = savedEmail;
        password.text = savedPassword;

        if (kDebugMode) {
          print('✅ تم تحميل البيانات المحفوظة:');
          print('📧 Email: $savedEmail');
          print('🔑 Password: ${savedPassword.substring(0, 3)}***');
          print('💾 Remember Me: ${rememberMe.value}');
        }
      } else {
        // تحقق من حالة "تذكرني" فقط
        if (savedRememberMe == true) {
          rememberMe.value = true;
          if (kDebugMode) {
            print('💾 تم تفعيل "تذكرني" فقط (لا توجد بيانات محفوظة)');
          }
        } else {
          rememberMe.value = false;
          if (kDebugMode) {
            print('ℹ️ لا توجد بيانات محفوظة');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل البيانات المحفوظة: $e');
      }
      // في حالة الخطأ، اجعل "تذكرني" غير مفعل
      rememberMe.value = false;
    }
  }

  /// دالة تسجيل الدخول باستخدام Firebase Auth
  Future<void> emailAndPasswordSignin() async {
    try {
      // التحقق من صحة النموذج
      if (!loginFormKey.currentState!.validate()) {
        return;
      }

      // التحقق من الصلاحيات قبل تسجيل الدخول
      final permissionsController = Get.put(PermissionsController());
      final emailText = email.text.trim();

      final isAuthorized =
          await permissionsController.isEmailAuthorized(emailText);
      if (!isAuthorized) {
        SnackbarHelper.showError(
          title: 'غير مصرح',
          message: 'هذا البريد الإلكتروني غير مصرح له بالدخول',
        );
        return;
      }

      // حفظ بيانات "تذكرني" إذا كان مفعلاً
      if (rememberMe.value) {
        _saveCredentials();
      } else {
        // إذا لم يكن مفعلاً، احذف البيانات المحفوظة
        clearSavedCredentials();
      }

      // استخدام Firebase Auth لتسجيل الدخول
      final userCredential = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(emailText, password.text.trim());

      if (userCredential != null && userCredential.user != null) {
        // نجح تسجيل الدخول
        Get.offAllNamed('/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      // معالجة أخطاء Firebase Auth
      String errorMessage = 'loginError'.tr;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'emailNotRegistered'.tr;
          break;
        case 'wrong-password':
          errorMessage = 'wrongPassword'.tr;
          break;
        case 'invalid-email':
          errorMessage = 'invalidEmail'.tr;
          break;
        case 'user-disabled':
          errorMessage = 'accountDisabled'.tr;
          break;
        case 'too-many-requests':
          errorMessage = 'tooManyRequests'.tr;
          break;
        default:
          errorMessage =
              'generalLoginError'.trParams({'message': e.message ?? ''});
      }

      SnackbarHelper.showError(
        title: 'loginError'.tr,
        message: errorMessage,
      );
    } catch (e) {
      SnackbarHelper.showError(
        title: 'loginError'.tr,
        message: 'loginProcessError'.trParams({'error': e.toString()}),
      );
    }
  }

  /// حفظ بيانات تسجيل الدخول
  void _saveCredentials() {
    try {
      final emailText = email.text.trim();
      final passwordText = password.text.trim();

      if (emailText.isNotEmpty && passwordText.isNotEmpty) {
        localStorage.write('REMEMBER_ME_EMAIL', emailText);
        localStorage.write('REMEMBER_ME_PASSWORD', passwordText);
        localStorage.write('REMEMBER_ME_STATE', true);

        if (kDebugMode) {
          print('💾 تم حفظ بيانات تسجيل الدخول');
          print('📧 Email: $emailText');
          print('🔑 Password: ${passwordText.substring(0, 3)}***');
          print('💾 Remember Me State: true');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ لا يمكن حفظ بيانات فارغة');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في حفظ البيانات: $e');
      }
    }
  }

  /// تبديل إظهار/إخفاء كلمة المرور
  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  /// تبديل "تذكرني"
  void toggleRememberMe() {
    // تبديل القيمة
    rememberMe.value = !rememberMe.value;

    if (kDebugMode) {
      print('🔄 تم تبديل "تذكرني" إلى: ${rememberMe.value}');
    }

    if (rememberMe.value) {
      // إذا تم تفعيل "تذكرني"، احفظ البيانات الحالية
      if (email.text.isNotEmpty && password.text.isNotEmpty) {
        _saveCredentials();
      } else {
        // إذا لم تكن البيانات مملوءة، احفظ الحالة فقط
        localStorage.write('REMEMBER_ME_STATE', true);
      }
    } else {
      // إذا تم إلغاء "تذكرني"، احذف البيانات المحفوظة
      clearSavedCredentials();
      SnackbarHelper.showInfo(
        title: 'cancelled'.tr,
        message: 'willNotSaveCredentials'.tr,
      );
    }
  }

  /// حذف البيانات المحفوظة
  void clearSavedCredentials() {
    try {
      localStorage.remove('REMEMBER_ME_EMAIL');
      localStorage.remove('REMEMBER_ME_PASSWORD');
      localStorage.remove('REMEMBER_ME_STATE');

      if (kDebugMode) {
        print('🗑️ تم حذف البيانات المحفوظة');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في حذف البيانات: $e');
      }
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      // حذف البيانات المحفوظة عند تسجيل الخروج
      clearSavedCredentials();

      Get.offAllNamed('/login');
    } catch (e) {
      SnackbarHelper.showError(
        title: 'loginError'.tr,
        message: 'signOutError'.trParams({'error': e.toString()}),
      );
    }
  }

  /// إعادة تعيين النموذج
  void resetForm() {
    email.clear();
    password.clear();
    rememberMe.value = false;
    hidePassword.value = true;
  }

  /// اختبار التخزين المحلي (للتطوير فقط)
  void testLocalStorage() {
    if (kDebugMode) {
      print('🧪 اختبار التخزين المحلي:');
      print('📧 Email: ${localStorage.read('REMEMBER_ME_EMAIL')}');
      print('🔑 Password: ${localStorage.read('REMEMBER_ME_PASSWORD')}');
      print('💾 Remember Me: ${localStorage.read('REMEMBER_ME_STATE')}');

      // اختبار الكتابة
      localStorage.write('TEST_KEY', 'test_value');
      final testValue = localStorage.read('TEST_KEY');
      print('✅ اختبار الكتابة: $testValue');

      // تنظيف
      localStorage.remove('TEST_KEY');
    }
  }
}
