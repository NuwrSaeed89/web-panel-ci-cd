import 'package:brother_admin_panel/data/models/permission_model.dart';
import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/validators/validator.dart';
import 'package:brother_admin_panel/common/widgets/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditPermissionDialog extends StatefulWidget {
  final PermissionModel permission;

  const EditPermissionDialog({
    super.key,
    required this.permission,
  });

  @override
  State<EditPermissionDialog> createState() => _EditPermissionDialogState();
}

class _EditPermissionDialogState extends State<EditPermissionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  late bool _isAuthorized;
  late String _selectedCountryCode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.permission.name);
    _phoneController =
        TextEditingController(text: widget.permission.phoneNumber);
    _emailController = TextEditingController(text: widget.permission.email);
    _roleController = TextEditingController(text: widget.permission.role);
    _isAuthorized = widget.permission.isAuthorized;
    _selectedCountryCode = widget.permission.country;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
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
              // Header
              Row(
                children: [
                  Icon(
                    Iconsax.edit,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: TSizes.sm),
                  Text(
                    'editPermission'.tr,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtWsections),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'name'.tr,
                  hintText: 'enterManagerName'.tr,
                  prefixIcon: const Icon(Iconsax.user),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'nameRequired'.tr;
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
                        labelText: 'phoneNumber'.tr,
                        hintText: 'phoneNumberHint'.tr,
                        prefixIcon: const Icon(Iconsax.mobile),
                        helperText: 'phoneNumberHelper'.tr,
                        helperMaxLines: 2,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(TSizes.borderRadiusSm),
                        ),
                      ),
                      validator: _validatePhoneNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  hintText: 'emailHint'.tr,
                  prefixIcon: const Icon(Iconsax.sms),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'emailRequired'.tr;
                  }
                  if (!GetUtils.isEmail(value.trim())) {
                    return 'invalidEmail'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Role Field
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(
                  labelText: 'role'.tr,
                  hintText: 'roleHint'.tr,
                  prefixIcon: const Icon(Iconsax.user_tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'roleRequired'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Authorization Switch
              Row(
                children: [
                  Switch(
                    value: _isAuthorized,
                    onChanged: (value) {
                      setState(() {
                        _isAuthorized = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: TSizes.sm),
                  Expanded(
                    child: Text(
                      'authorizedToLogin'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'IBM Plex Sans Arabic',
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtWsections),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      'cancel'.tr,
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.sm),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final updatedPermission = PermissionModel(
                            id: widget.permission.id,
                            phoneNumber: _phoneController.text.trim(),
                            email: _emailController.text.trim(),
                            name: _nameController.text.trim(),
                            role: _roleController.text.trim(),
                            isAuthorized: _isAuthorized,
                            country: _selectedCountryCode,
                            createdAt: widget.permission.createdAt,
                            updatedAt: DateTime.now(),
                          );

                          // محاولة العثور على وحدة التحكم
                          try {
                            final controller =
                                Get.find<PermissionsController>();
                            await controller
                                .updatePermission(updatedPermission);
                            Get.back();
                          } catch (e) {
                            // إذا فشل Get.find، جرب Get.put
                            final controller = Get.put(PermissionsController());
                            await controller
                                .updatePermission(updatedPermission);
                            Get.back();
                          }
                        } catch (e) {
                          Get.snackbar(
                            'خطأ',
                            'فشل في تحديث الصلاحية: $e',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(TSizes.borderRadiusSm),
                      ),
                    ),
                    child: Text(
                      'update'.tr,
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
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
}
