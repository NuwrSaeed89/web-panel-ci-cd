import 'package:brother_admin_panel/common/widgets/loaders/animation_loading.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TFullScreenLoader {
  static void openloadingDialog(String text, String animation, {Color? color}) {
    if (color == null) {
      color = THelperFunctions.isDarkMode(Get.context!)
          ? Colors.white
          : Colors.black;
    }

    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => Container(
        color: THelperFunctions.isDarkMode(Get.context!)
            ? TColors.dark
            : TColors.light,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 180),
            TAnimationLoaderWidget(
              text: text,
              animation: animation,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
