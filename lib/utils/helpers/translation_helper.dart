import 'package:get/get.dart';

/// مساعد للترجمة مع المعاملات
class TranslationHelper {
  /// ترجمة نص مع استبدال المعاملات
  static String trWithParams(String key, Map<String, String> params) {
    String translation = key.tr;

    params.forEach((paramKey, value) {
      translation = translation.replaceAll('{$paramKey}', value);
    });

    return translation;
  }

  /// ترجمة نص مع معامل واحد
  static String trWithParam(String key, String paramKey, String value) {
    return trWithParams(key, {paramKey: value});
  }

  /// ترجمة نص مع عدد
  static String trWithCount(String key, int count) {
    return trWithParams(key, {'count': count.toString()});
  }

  /// ترجمة نص مع عدد وصفة
  static String trWithCountAndLabel(String key, int count, String label) {
    return trWithParams(key, {
      'count': count.toString(),
      'label': label,
    });
  }

  /// ترجمة نص مع اسم
  static String trWithName(String key, String name) {
    return trWithParams(key, {'name': name});
  }

  /// ترجمة نص مع رسالة
  static String trWithMessage(String key, String message) {
    return trWithParams(key, {'message': message});
  }

  /// ترجمة نص مع خطأ
  static String trWithError(String key, String error) {
    return trWithParams(key, {'error': error});
  }
}

/// امتداد للترجمة مع المعاملات
extension TranslationExtension on String {
  /// ترجمة مع معاملات
  String trParams(Map<String, String> params) {
    return TranslationHelper.trWithParams(this, params);
  }

  /// ترجمة مع معامل واحد
  String trParam(String paramKey, String value) {
    return TranslationHelper.trWithParam(this, paramKey, value);
  }

  /// ترجمة مع عدد
  String trCount(int count) {
    return TranslationHelper.trWithCount(this, count);
  }

  /// ترجمة مع اسم
  String trName(String name) {
    return TranslationHelper.trWithName(this, name);
  }

  /// ترجمة مع رسالة
  String trMessage(String message) {
    return TranslationHelper.trWithMessage(this, message);
  }

  /// ترجمة مع خطأ
  String trError(String error) {
    return TranslationHelper.trWithError(this, error);
  }
}
