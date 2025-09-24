import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/utils/helpers/snackbar_helper.dart';
import 'package:brother_admin_panel/utils/validators/validator.dart';

class OtpLoginController extends GetxController {
  static OtpLoginController get instance => Get.find();

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final isOtpSent = false.obs;
  final isLoading = false.obs;
  final countdown = 0.obs;
  final verificationId = ''.obs;
  final selectedCountryCode = 'SA'.obs; // السعودية كافتراضي

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    // تحميل الصلاحيات عند بدء التطبيق
    Get.put(PermissionsController());
  }

  /// إرسال رمز التحقق
  Future<void> sendOtp({int retryCount = 0}) async {
    try {
      final phoneNumber = phoneController.text.trim();

      // التحقق من صحة رقم الهاتف
      final phoneValidation = TValidator.validatePhoneNumber(phoneNumber);
      if (phoneValidation != null) {
        SnackbarHelper.showError(
          title: 'خطأ في رقم الهاتف',
          message: phoneValidation,
        );
        return;
      }

      // الحصول على رمز الدولة
      final countryCodes = TValidator.getCountryCodes();
      final phoneCode = countryCodes[selectedCountryCode.value] ?? '966';

      // دمج رقم الهاتف مع رمز الدولة للتحقق من الصلاحيات
      String fullPhoneNumber = phoneNumber;

      // إزالة المسافات والرموز الخاصة
      String cleanPhone = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

      if (cleanPhone.startsWith('+')) {
        // إذا كان الرقم يبدأ بـ +، استخدمه كما هو
        fullPhoneNumber = cleanPhone;
      } else if (cleanPhone.startsWith(phoneCode)) {
        // إذا كان الرقم يبدأ برمز الدولة، أضف +
        fullPhoneNumber = '+$cleanPhone';
      } else {
        // إزالة الصفر من البداية إذا كان موجوداً
        if (cleanPhone.startsWith('0')) {
          cleanPhone = cleanPhone.substring(1);
        }
        // إضافة رمز الدولة
        fullPhoneNumber = '+$phoneCode$cleanPhone';
      }

      // التحقق من الصلاحيات
      final permissionsController = Get.find<PermissionsController>();

      final isAuthorized = await permissionsController.isPhoneAuthorized(
        fullPhoneNumber,
      );

      if (!isAuthorized) {
        SnackbarHelper.showError(
          title: 'غير مصرح',
          message: 'هذا رقم الهاتف غير مصرح له بالدخول.',
        );
        return;
      }

      isLoading.value = true;

      // تنسيق رقم الهاتف للـ Firebase مع رمز الدولة المحدد
      final formattedPhone = TValidator.formatPhoneForFirebase(
        fullPhoneNumber,
        countryCode: phoneCode,
      );

      // التحقق من صحة تنسيق الرقم النهائي
      if (formattedPhone.length < 10 || formattedPhone.length > 15) {
        SnackbarHelper.showError(
          title: 'رقم هاتف غير صحيح',
          message: 'طول رقم الهاتف غير صحيح: ${formattedPhone.length} رقم',
        );
        return;
      }

      // إرسال OTP باستخدام Firebase
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // التحقق التلقائي (عندما يكون التطبيق في نفس الجهاز)

          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) async {
          // Handle reCAPTCHA specific errors
          if (e.code == 'invalid-app-credential' ||
              e.code == 'invalid-recaptcha-token' ||
              e.message?.contains('reCAPTCHA') == true) {
            if (retryCount < 2) {
              // Retry after a short delay
              _resetRecaptcha();
              await Future.delayed(const Duration(seconds: 2));
              await sendOtp(retryCount: retryCount + 1);
              return;
            } else {
              SnackbarHelper.showError(
                title: 'خطأ في reCAPTCHA',
                message:
                    'فشل في التحقق من reCAPTCHA بعد عدة محاولات. يرجى إعادة تحميل الصفحة والمحاولة مرة أخرى.',
              );
            }
          } else {
            SnackbarHelper.showError(
              title: 'فشل التحقق',
              message: _getErrorMessage(e.code),
            );
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          isOtpSent.value = true;
          _startCountdown();
          SnackbarHelper.showSuccess(
            title: 'تم الإرسال',
            message: 'تم إرسال رمز التحقق إلى رقم الهاتف',
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في إرسال رمز التحقق: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// التحقق من رمز OTP
  Future<void> verifyOtp() async {
    try {
      if (otpController.text.trim().isEmpty) {
        SnackbarHelper.showError(
          title: 'خطأ',
          message: 'يرجى إدخال رمز التحقق',
        );
        return;
      }

      if (verificationId.value.isEmpty) {
        SnackbarHelper.showError(
          title: 'خطأ',
          message: 'لم يتم إرسال رمز التحقق بعد',
        );
        return;
      }

      isLoading.value = true;

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otpController.text.trim(),
      );

      // تسجيل الدخول باستخدام الرمز
      await _signInWithCredential(credential);
    } catch (e) {
      SnackbarHelper.showError(
        title: 'خطأ',
        message: 'فشل في التحقق من الرمز: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// إعادة إرسال رمز التحقق
  Future<void> resendOtp() async {
    if (countdown.value > 0) {
      SnackbarHelper.showError(
        title: 'انتظر',
        message: 'يرجى الانتظار ${countdown.value} ثانية قبل إعادة الإرسال',
      );
      return;
    }
    await sendOtp();
  }

  /// تسجيل الدخول باستخدام الرمز
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        Get.offAllNamed('/dashboard');
        SnackbarHelper.showSuccess(
          title: 'نجح',
          message: 'تم تسجيل الدخول بنجاح',
        );

        // إعادة تعيين النموذج
        resetForm();
      }
    } catch (e) {
      SnackbarHelper.showError(
        title: 'خطأ في تسجيل الدخول',
        message: _getErrorMessage(e.toString()),
      );
    }
  }

  /// بدء العد التنازلي لإعادة الإرسال
  void _startCountdown() {
    countdown.value = 60; // 60 ثانية
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      countdown.value--;
      return countdown.value > 0;
    });
  }

  /// الحصول على رسالة الخطأ المناسبة
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-phone-number':
        return 'رقم الهاتف غير صحيح';
      case 'too-many-requests':
        return 'تم إرسال طلبات كثيرة، يرجى المحاولة لاحقاً';
      case 'quota-exceeded':
        return 'تم تجاوز الحد المسموح من الطلبات';
      case 'invalid-verification-code':
        return 'رمز التحقق غير صحيح';
      case 'invalid-verification-id':
        return 'معرف التحقق غير صحيح';
      case 'invalid-app-credential':
        return 'خطأ في إعدادات التطبيق';
      case 'credential-already-in-use':
        return 'هذا الرقم مستخدم بالفعل';
      case 'user-disabled':
        return 'هذا الحساب معطل';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموحة';
      case 'network-request-failed':
        return 'فشل في الاتصال بالشبكة';
      case 'app-not-authorized':
        return 'التطبيق غير مصرح له. تحقق من إعدادات Firebase';
      default:
        return 'حدث خطأ غير متوقع: $errorCode';
    }
  }

  /// إعادة تعيين reCAPTCHA
  void _resetRecaptcha() {
    try {
      if (kIsWeb) {
        // For web, call the JavaScript reset function
        // This will be handled by the web implementation
        if (kDebugMode) {
          print('🔄 Resetting reCAPTCHA for web...');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error resetting reCAPTCHA: $e');
      }
    }
  }

  /// إعادة تعيين النموذج
  void resetForm() {
    phoneController.clear();
    otpController.clear();
    isOtpSent.value = false;
    verificationId.value = '';
    countdown.value = 0;
    selectedCountryCode.value = 'SA'; // إعادة تعيين إلى السعودية
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
