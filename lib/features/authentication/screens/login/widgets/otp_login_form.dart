import 'package:brother_admin_panel/features/authentication/controllers/otp_login_controller.dart';
import 'package:brother_admin_panel/routs/routs.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/validators/validator.dart';
import 'package:brother_admin_panel/common/widgets/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TOtpLoginForm extends StatelessWidget {
  const TOtpLoginForm({super.key});

  // التحقق من صحة رقم الهاتف باستخدام TValidator
  String? _validatePhoneNumber(String? value) {
    return TValidator.validatePhoneNumber(value);
  }

  // إظهار منتقي رمز الدولة
  void _showCountryCodePicker(
    BuildContext context,
    OtpLoginController controller,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'selectCountry'.tr,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 500, // زيادة ارتفاع النافذة
          child: CountryCodePicker(
            selectedCountryCode: controller.selectedCountryCode.value,
            onCountryChanged: (countryCode) {
              controller.selectedCountryCode.value = countryCode;
              // إغلاق النافذة بعد التحديث
              Navigator.of(context).pop();
            },
            isDark: isDark,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpLoginController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtWsections),
        child: Column(
          children: [
            // Country Code and Phone Number Input
            LayoutBuilder(
              builder: (context, constraints) {
                // على الشاشات الصغيرة، نضع العناصر عمودياً
                if (constraints.maxWidth < 400) {
                  return Column(
                    children: [
                      // Country Code Picker
                      CountryCodeButton(
                        selectedCountryCode: controller.selectedCountryCode,
                        onTap: () => _showCountryCodePicker(
                          context,
                          controller,
                          isDark,
                        ),
                        isDark: isDark,
                        isVertical: true, // للتخطيط العمودي
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      // Phone Number Input
                      TextFormField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhoneNumber,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.mobile),
                          labelText: 'phoneNumber'.tr,
                          hintText: 'phoneNumberHint'.tr,
                          helperText: 'phoneNumberHelper'.tr,
                          helperMaxLines: 3,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: TColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // على الشاشات الأكبر، نضع العناصر أفقياً
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Country Code Picker
                      CountryCodeButton(
                        selectedCountryCode: controller.selectedCountryCode,
                        onTap: () => _showCountryCodePicker(
                          context,
                          controller,
                          isDark,
                        ),
                        isDark: isDark,
                        isVertical: false, // للتخطيط الأفقي
                      ),

                      // Phone Number Input
                      Expanded(
                        child: TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          validator: _validatePhoneNumber,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Iconsax.mobile),
                            labelText: 'phoneNumber'.tr,
                            hintText: 'phoneNumberHint'.tr,
                            helperText: 'phoneNumberHelper'.tr,
                            helperMaxLines: 3,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              borderSide: BorderSide(
                                color: TColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // OTP Input (shown after phone verification)
            Obx(
              () => controller.isOtpSent.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return TextFormField(
                              controller: controller.otpController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: constraints.maxWidth < 400 ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing:
                                    constraints.maxWidth < 400 ? 4 : 8,
                                fontFamily: 'IBM Plex Sans Arabic',
                              ),
                              decoration: InputDecoration(
                                labelText: 'verificationCode'.tr,
                                hintText: '503780091'.tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    TSizes.borderRadiusSm,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    TSizes.borderRadiusSm,
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    TSizes.borderRadiusSm,
                                  ),
                                  borderSide: const BorderSide(
                                    color: TColors.primary,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields),
                        Row(
                          children: [
                            Text(
                              'didntReceiveCode'.tr,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                  ),
                            ),
                            Obx(
                              () => controller.countdown.value > 0
                                  ? Text(
                                      ' (${controller.countdown.value}s)',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                            color: Colors.grey[600],
                                            fontFamily: 'IBM Plex Sans Arabic',
                                          ),
                                    )
                                  : TextButton(
                                      onPressed: controller.resendOtp,
                                      child: Text(
                                        'resend'.tr,
                                        style: const TextStyle(
                                          fontFamily: 'IBM Plex Sans Arabic',
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: TSizes.spaceBtWsections),
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (controller.isOtpSent.value) {
                              controller.verifyOtp();
                            } else {
                              controller.sendOtp();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: constraints.maxWidth < 400
                            ? TSizes.spaceBtwInputFields
                            : TSizes.bottomHeight,
                        horizontal: constraints.maxWidth < 400
                            ? TSizes.sm
                            : TSizes.defaultSpace,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          TSizes.borderRadiusSm,
                        ),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            width: constraints.maxWidth < 400 ? 16 : 20,
                            height: constraints.maxWidth < 400 ? 16 : 20,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            controller.isOtpSent.value
                                ? 'confirmCode'.tr
                                : 'sendOTP'.tr,
                            style: TextStyle(
                              fontSize: constraints.maxWidth < 400 ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                          ),
                  ),
                );
              },
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Link to Brother Creative Login
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 400) {
                  // على الشاشات الصغيرة، نضع النص في عمود
                  return Column(
                    children: [
                      Text(
                        'loginViaBrotherCreative'.tr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: TSizes.xs),
                      TextButton(
                        onPressed: () {
                          // Navigate to Brother Creative login
                          Get.toNamed(TRoutes.brotherCreativeLogin);
                        },
                        child: Text(
                          'Brother Creative',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                                color: TColors.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                fontFamily: 'IBM Plex Sans Arabic',
                              ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // على الشاشات الأكبر، نضع النص في صف
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'loginViaBrotherCreative'.tr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to Brother Creative login
                          Get.toNamed(TRoutes.brotherCreativeLogin);
                        },
                        child: Text(
                          'Brother Creative',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                                color: TColors.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                fontFamily: 'IBM Plex Sans Arabic',
                              ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
