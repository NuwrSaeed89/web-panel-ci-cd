//import 'package:brother_admin_panel/data/repositoies/authentication/authentication_repository.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/image_strings.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final dark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: TColors.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
              onPressed: () {
                //  AuthenticationRepository.instance.signInWithGoogle();
              },
              icon: const Image(
                  width: TSizes.iconMd,
                  height: TSizes.iconMd,
                  image: AssetImage(TImages.googleIcon))),
        ),
        const SizedBox(
          width: TSizes.spaceBtWItems,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: TColors.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
              onPressed: () {},
              icon: const Image(
                  width: TSizes.iconMd,
                  height: TSizes.iconMd,
                  image: AssetImage(TImages.appleIcon))),
        ),
      ],
    );
  }
}
