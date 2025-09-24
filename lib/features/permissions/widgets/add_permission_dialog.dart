import 'package:brother_admin_panel/data/models/permission_model.dart';
import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/validators/validator.dart';
import 'package:brother_admin_panel/common/widgets/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddPermissionDialog extends StatefulWidget {
  const AddPermissionDialog({super.key});

  @override
  State<AddPermissionDialog> createState() => _AddPermissionDialogState();
}

class _AddPermissionDialogState extends State<AddPermissionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController(text: 'manager');
  bool _isAuthorized = true;
  String _selectedCountryCode = 'SA'; // السعودية كافتراضي

  // التحقق من صحة رقم الهاتف باستخدام TValidator
  String? _validatePhoneNumber(String? value) {
    return TValidator.validatePhoneNumber(value);
  }

  // إظهار منتقي رمز الدولة
  void _showCountryCodePicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'selectCountry'.tr,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: CountryCodePicker(
            selectedCountryCode: _selectedCountryCode,
            onCountryChanged: (countryCode) {
              setState(() {
                _selectedCountryCode = countryCode;
              });
              Navigator.of(context).pop();
            },
            isDark: isDark,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.add_circle,
                      color: TColors.primary, size: 24),
                  const SizedBox(width: TSizes.sm),
                  Text(
                    'إضافة صلاحية جديدة',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.defaultSpace),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم',
                  hintText: 'أدخل اسم المدير',
                  prefixIcon: const Icon(Iconsax.user),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الاسم مطلوب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Country Code and Phone Field
              Row(
                children: [
                  // Country Code Picker
                  CountryCodeButton(
                    selectedCountryCode: _selectedCountryCode.obs,
                    onTap: () => _showCountryCodePicker(context),
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),

                  // Phone Number Input
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        hintText: '0501234567',
                        prefixIcon: const Icon(Iconsax.mobile),
                        helperText:
                            'اختر رمز الدولة ثم أدخل رقم الهاتف المحلي فقط',
                        helperMaxLines: 2,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            TSizes.borderRadiusSm,
                          ),
                        ),
                      ),
                      validator: _validatePhoneNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  hintText: 'manager@brothercreative.com',
                  prefixIcon: const Icon(Iconsax.sms),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'البريد الإلكتروني مطلوب';
                  }
                  final emailRegExp = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegExp.hasMatch(value)) {
                    return 'بريد إلكتروني غير صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Role field
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(
                  labelText: 'الدور',
                  hintText: 'manager',
                  prefixIcon: const Icon(Iconsax.crown),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الدور مطلوب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Authorization toggle
              Row(
                children: [
                  Checkbox(
                    value: _isAuthorized,
                    onChanged: (value) {
                      setState(() {
                        _isAuthorized = value ?? true;
                      });
                    },
                    activeColor: TColors.primary,
                  ),
                  Text(
                    'مصرح له بالدخول',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      color: _isAuthorized ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.defaultSpace),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      'إلغاء',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.sm),
                  ElevatedButton(
                    onPressed: _addPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          TSizes.borderRadiusSm,
                        ),
                      ),
                    ),
                    child: const Text(
                      'إضافة',
                      style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addPermission() async {
    if (_formKey.currentState!.validate()) {
      try {
        final permission = PermissionModel(
          id: '', // سيتم تعيينه من Firebase
          name: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          role: _roleController.text.trim(),
          isAuthorized: _isAuthorized,
          country: _selectedCountryCode,
          createdAt: DateTime.now(),
        );

        // محاولة العثور على وحدة التحكم
        try {
          final controller = Get.find<PermissionsController>();
          await controller.addPermission(permission);
        } catch (e) {
          // إذا فشل Get.find، جرب Get.put
          final controller = Get.put(PermissionsController());
          await controller.addPermission(permission);
        }
        Get.back();
      } catch (e) {
        Get.snackbar(
          'خطأ',
          'فشل في إضافة الصلاحية: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
