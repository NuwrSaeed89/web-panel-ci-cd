import 'package:brother_admin_panel/features/authentication/controllers/login_controller.dart';
import 'package:brother_admin_panel/routs/routs.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
        key: controller.loginFormKey,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: TSizes.spaceBtWsections),
          child: Column(
            children: [
              TextFormField(
                controller: controller.email,
                validator: TValidator.validateEmail,
                decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                    // enabledBorder: OutlineInputBorder(),
                    prefixIcon: const Icon(Iconsax.direct_right),
                    labelText: 'email'.tr),
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              Obx(() => TextFormField(
                    controller: controller.password,
                    obscureText: controller.hidePassword.value,
                    validator: TValidator.validatePassword,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                            onPressed: controller.togglePasswordVisibility,
                            icon: Icon(controller.hidePassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye)),
                        labelText: 'password'.tr),
                  )),
              const SizedBox(
                height: TSizes.spaceBtwInputFields / 2,
              ),
              //remember me and forget password

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => GestureDetector(
                            onTap: controller.toggleRememberMe,
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller.rememberMe.value
                                          ? TColors.primary
                                          : Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    color: controller.rememberMe.value
                                        ? TColors.primary
                                        : Colors.transparent,
                                  ),
                                  child: controller.rememberMe.value
                                      ? const Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'rememberMe'.tr,
                                  style: TextStyle(
                                    color: controller.rememberMe.value
                                        ? TColors.primary
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color,
                                    fontWeight: controller.rememberMe.value
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  TextButton(
                      onPressed: () => Get.toNamed(TRoutes.forgetPassword),
                      child: Text(
                        'forgetPassword'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .apply(color: TColors.primary),
                      ))
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtWsections,
              ),

              ///sign in button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: controller.emailAndPasswordSignin,
                    child: Text('login'.tr)),
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
                          'goBackAnd'.tr,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: TSizes.xs),
                        TextButton(
                          onPressed: () {
                            // Navigate to Brother Creative login
                            Get.toNamed(TRoutes.login);
                          },
                          child: Text(
                            'loginviaPhoneNumber'.tr,
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
                          'Go Back and '.tr,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                  ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to Brother Creative login
                            Get.toNamed(TRoutes.login);
                          },
                          child: Text(
                            'Login via Phone Number',
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
        ));
  }
}
