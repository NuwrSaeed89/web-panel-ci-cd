import 'package:brother_admin_panel/routs/routs.dart';
import 'package:brother_admin_panel/utils/constants/image_strings.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final email = Get.arguments ?? '';
    return Column(
      children: [
        ///Header
        IconButton(
            onPressed: () => Get.offAllNamed(TRoutes.login),
            icon: const Icon(CupertinoIcons.clear)),
        const SizedBox(
          height: TSizes.spaceBtWItems,
        ),
        const Image(
          image: AssetImage(TImages.emailSend),
          width: 300,
          height: 300,
        ),
        const SizedBox(
          height: TSizes.spaceBtWItems,
        ),
        Text(
          TTexts.resetPasswordTitle,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: TSizes.spaceBtWItems,
        ),
        Text(
          email,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(
          height: TSizes.spaceBtWItems,
        ),
        Text(
          TTexts.resetPasswordSubTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(
          height: TSizes.spaceBtWsections,
        ),

        ///Form

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () => Get.offAllNamed(TRoutes.login),
              child: const Text('Done')),
        ),
        const SizedBox(
          height: TSizes.spaceBtWItems,
        ),
        SizedBox(
          width: double.infinity,
          child: TextButton(
              onPressed: Get.back, child: const Text('Resend Email')),
        ),
      ],
    );
  }
}
