import 'package:brother_admin_panel/localization/language_controller.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/image_strings.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TOtpLoginHeader extends StatelessWidget {
  const TOtpLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Spacer(),
              GetBuilder<LanguageController>(
                builder: (languageController) {
                  return IconButton(
                    onPressed: () {
                      if (languageController.isArabic) {
                        languageController.changeToEnglish();
                      } else {
                        languageController.changeToArabic();
                      }
                    },
                    icon: const Icon(
                      Icons.language,
                      color: TColors.primary,
                      size: 24,
                    ),
                    tooltip: languageController.isArabic
                        ? 'Change to English'
                        : 'تغيير إلى العربية',
                  );
                },
              ),
            ],
          ),
          Image(
            width: 120,
            height: 120,
            image: AssetImage(THelperFunctions.isDarkMode(context)
                ? TImages.bwhite
                : TImages.bBlack),
          ),
          const SizedBox(height: TSizes.spaceBtWsections),
          Text(
            'login'.tr,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: TSizes.sm),
          Text(
            'enterPhoneForOTP'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
