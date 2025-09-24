import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/data/models/brother_model.dart';
import 'package:brother_admin_panel/data/repositories/brothers/brothers_repository.dart';

class BrotherController extends GetxController {
  static BrotherController get instance => Get.find();

  final BrotherRepository _brotherRepository = BrotherRepository.instance;

  // Observable variables
  final Rx<BrotherModel> _brotherData = BrotherModel.empty().obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isSaving = false.obs;
  final RxString _errorMessage = ''.obs;

  // Text controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _arabicNameController = TextEditingController();
  final TextEditingController _aboutUsController = TextEditingController();
  final TextEditingController _arabicAboutUsController =
      TextEditingController();
  final TextEditingController _cancellationPolicyController =
      TextEditingController();
  final TextEditingController _arabicCancellationPolicyController =
      TextEditingController();
  final TextEditingController _privacyPolicyController =
      TextEditingController();
  final TextEditingController _arabicPrivacyPolicyController =
      TextEditingController();
  final TextEditingController _returnPolicyController = TextEditingController();
  final TextEditingController _arabicReturnPolicyController =
      TextEditingController();
  final TextEditingController _termsConditionController =
      TextEditingController();
  final TextEditingController _arabicTermsConditionController =
      TextEditingController();
  final TextEditingController _primaryColorController = TextEditingController();
  final TextEditingController _phoneNumbersController = TextEditingController();

  // Getters
  BrotherModel get brotherData => _brotherData.value;
  bool get isLoading => _isLoading.value;
  bool get isSaving => _isSaving.value;
  String get errorMessage => _errorMessage.value;

  // Text controllers getters
  TextEditingController get nameController => _nameController;
  TextEditingController get arabicNameController => _arabicNameController;
  TextEditingController get aboutUsController => _aboutUsController;
  TextEditingController get arabicAboutUsController => _arabicAboutUsController;
  TextEditingController get cancellationPolicyController =>
      _cancellationPolicyController;
  TextEditingController get arabicCancellationPolicyController =>
      _arabicCancellationPolicyController;
  TextEditingController get privacyPolicyController => _privacyPolicyController;
  TextEditingController get arabicPrivacyPolicyController =>
      _arabicPrivacyPolicyController;
  TextEditingController get returnPolicyController => _returnPolicyController;
  TextEditingController get arabicReturnPolicyController =>
      _arabicReturnPolicyController;
  TextEditingController get termsConditionController =>
      _termsConditionController;
  TextEditingController get arabicTermsConditionController =>
      _arabicTermsConditionController;
  TextEditingController get primaryColorController => _primaryColorController;
  TextEditingController get phoneNumbersController => _phoneNumbersController;

  @override
  void onInit() {
    super.onInit();
    fetchBrotherData();
  }

  @override
  void onClose() {
    // Dispose text controllers
    _nameController.dispose();
    _arabicNameController.dispose();
    _aboutUsController.dispose();
    _arabicAboutUsController.dispose();
    _cancellationPolicyController.dispose();
    _arabicCancellationPolicyController.dispose();
    _privacyPolicyController.dispose();
    _arabicPrivacyPolicyController.dispose();
    _returnPolicyController.dispose();
    _arabicReturnPolicyController.dispose();
    _termsConditionController.dispose();
    _arabicTermsConditionController.dispose();
    _primaryColorController.dispose();
    _phoneNumbersController.dispose();
    super.onClose();
  }

  // Fetch brother data
  Future<void> fetchBrotherData() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      if (kDebugMode) {
        print('🏢 Fetching brother data...');
      }

      final data = await _brotherRepository.getAlldata();

      if (data.isNotEmpty) {
        _brotherData.value = data.first;
        _populateControllers();

        if (kDebugMode) {
          print('✅ Successfully fetched brother data');
        }
      } else {
        // If no data exists, use empty model
        _brotherData.value = BrotherModel.empty();
        _populateControllers();

        if (kDebugMode) {
          print('ℹ️ No brother data found, using empty model');
        }
      }
    } catch (e) {
      _errorMessage.value = 'فشل في جلب بيانات الشركة: $e';
      if (kDebugMode) {
        print('❌ Error fetching brother data: $e');
      }
    } finally {
      _isLoading.value = false;
    }
  }

  // Populate text controllers with current data
  void _populateControllers() {
    final data = _brotherData.value;

    _nameController.text = data.name;
    _arabicNameController.text = data.arabicName;
    _aboutUsController.text = data.aboutUs;
    _arabicAboutUsController.text = data.arabicAboutUs;
    _cancellationPolicyController.text = data.cancellationPolicy;
    _arabicCancellationPolicyController.text = data.arabicCancellationPolicy;
    _privacyPolicyController.text = data.privacyPolicy;
    _arabicPrivacyPolicyController.text = data.arabicPrivacyPolicy;
    _returnPolicyController.text = data.returnPolicy;
    _arabicReturnPolicyController.text = data.arabicReturnPolicy;
    _termsConditionController.text = data.termsCondition;
    _arabicTermsConditionController.text = data.arabicTermsCondition;
    _primaryColorController.text = data.primaryColor ?? '';
    _phoneNumbersController.text = data.phoneNumbers.join(', ');
  }

  // Save brother data
  Future<void> saveBrotherData() async {
    try {
      _isSaving.value = true;
      _errorMessage.value = '';

      if (kDebugMode) {
        print('💾 Saving brother data...');
      }

      // Create updated model from form data
      final updatedData = BrotherModel(
        name: _nameController.text.trim(),
        arabicName: _arabicNameController.text.trim(),
        aboutUs: _aboutUsController.text.trim(),
        arabicAboutUs: _arabicAboutUsController.text.trim(),
        cancellationPolicy: _cancellationPolicyController.text.trim(),
        arabicCancellationPolicy:
            _arabicCancellationPolicyController.text.trim(),
        privacyPolicy: _privacyPolicyController.text.trim(),
        arabicPrivacyPolicy: _arabicPrivacyPolicyController.text.trim(),
        returnPolicy: _returnPolicyController.text.trim(),
        arabicReturnPolicy: _arabicReturnPolicyController.text.trim(),
        termsCondition: _termsConditionController.text.trim(),
        arabicTermsCondition: _arabicTermsConditionController.text.trim(),
        primaryColor: _primaryColorController.text.trim(),
        phoneNumbers: _phoneNumbersController.text
            .split(',')
            .map((phone) => phone.trim())
            .where((phone) => phone.isNotEmpty)
            .toList(),
      );

      // Save to repository
      await _brotherRepository.saveBrotherData(updatedData);

      // Update local data
      _brotherData.value = updatedData;

      Get.snackbar(
        'نجح',
        'تم حفظ بيانات الشركة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      if (kDebugMode) {
        print('✅ Brother data saved successfully');
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حفظ بيانات الشركة: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      if (kDebugMode) {
        print('❌ Error saving brother data: $e');
      }
    } finally {
      _isSaving.value = false;
    }
  }

  // Reset form to original data
  void resetForm() {
    _populateControllers();
    Get.snackbar(
      'تم إعادة تعيين النموذج',
      'تم استعادة البيانات الأصلية',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Clear all form fields
  void clearForm() {
    _nameController.clear();
    _arabicNameController.clear();
    _aboutUsController.clear();
    _arabicAboutUsController.clear();
    _cancellationPolicyController.clear();
    _arabicCancellationPolicyController.clear();
    _privacyPolicyController.clear();
    _arabicPrivacyPolicyController.clear();
    _returnPolicyController.clear();
    _arabicReturnPolicyController.clear();
    _termsConditionController.clear();
    _arabicTermsConditionController.clear();
    _primaryColorController.clear();
    _phoneNumbersController.clear();
  }

  // Refresh data
  Future<void> refreshData() async {
    await fetchBrotherData();
  }
}
