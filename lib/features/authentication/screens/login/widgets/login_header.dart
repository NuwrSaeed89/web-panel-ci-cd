import 'package:brother_admin_panel/localization/language_controller.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/image_strings.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
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
              Spacer(),
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
              width: 100,
              height: 100,
              image: AssetImage(THelperFunctions.isDarkMode(context)
                  ? TImages.bwhite
                  : TImages.bBlack)),
          const SizedBox(
            height: TSizes.spaceBtWsections,
          ),
          Text(
            'loginTitle'.tr,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: TSizes.sm,
          ),
          Text(
            'loginSubTitle'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
