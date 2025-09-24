import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();
  
  final _storage = GetStorage();
  final _locale = const Locale('en').obs;
  
  Locale get locale => _locale.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }
  
  void _loadSavedLanguage() {
    final savedLanguage = _storage.read('language');
    if (savedLanguage != null) {
      _locale.value = Locale(savedLanguage);
      Get.updateLocale(_locale.value);
    }
  }
  
  void changeLanguage(String languageCode) {
    _locale.value = Locale(languageCode);
    _storage.write('language', languageCode);
    Get.updateLocale(_locale.value);
  }
  
  void changeToArabic() {
    changeLanguage('ar');
  }
  
  void changeToEnglish() {
    changeLanguage('en');
  }
  
  bool get isArabic => locale.languageCode == 'ar';
  bool get isEnglish => locale.languageCode == 'en';
  
  String get currentLanguageName {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return 'English';
    }
  }
}
