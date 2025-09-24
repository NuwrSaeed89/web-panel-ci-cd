import 'package:brother_admin_panel/common/widgets/layout/templates/login_template.dart';
import 'package:brother_admin_panel/features/authentication/controllers/forget_password_controller.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HeaderAndFormWidget extends StatelessWidget {
  const HeaderAndFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TLoginTemplate(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Header
          IconButton(onPressed: Get.back, icon: const Icon(Iconsax.arrow_left)),
          const SizedBox(
            height: TSizes.spaceBtWItems,
          ),
          Text(
            'forgetPasswordTitle'.tr,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
          ),
          const SizedBox(
            height: TSizes.spaceBtWItems,
          ),
          Text(
            'forgetPasswordSubTitle'.tr,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
          ),
          const SizedBox(
            height: TSizes.spaceBtWsections * 2,
          ),

          ///Form
          Form(
            key: controller.forgetPasswordFormKey,
            child: TextFormField(
              controller: controller.email,
              keyboardType: TextInputType.emailAddress,
              validator: TValidator.validateEmail,
              decoration: InputDecoration(
                labelText: 'email'.tr,
                hintText: 'emailHint'.tr,
                prefixIcon: Icon(
                  Iconsax.direct_right,
                  color: isDark ? TColors.white : TColors.black,
                ),
                labelStyle: TextStyle(
                  color: isDark ? TColors.white : TColors.black,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
                hintStyle: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
                  borderSide: BorderSide(
                    color: isDark
                        ? TColors.white.withValues(alpha: 0.3)
                        : TColors.borderPrimary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
                  borderSide: BorderSide(
                    color: isDark ? TColors.primary : TColors.black,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: TSizes.spaceBtWsections,
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.sendPasswordResetEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: TSizes.bottomHeight,
                  horizontal: TSizes.defaultSpace,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                ),
              ),
              child: Text(
                'submit'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtWsections * 2,
          ),
        ],
      ),
    );
  }
}
