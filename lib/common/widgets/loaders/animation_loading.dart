// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/image_strings.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TAnimationLoaderWidget extends StatelessWidget {
  const TAnimationLoaderWidget({
    Key? key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
    this.color,
  }) : super(key: key);

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image(image: AssetImage(animation)),
            // Lottie.network(
            //     'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json'),
            const SizedBox(height: TSizes.appBarHeight),
            Lottie.asset(
              animation,
              width: THelperFunctions.screenwidth() * 0.5,
              delegates: color == null
                  ? null
                  : LottieDelegates(
                      values: [
                        // محاولة لتلوين جميع التعبئات إلى اللون المحدد
                        ValueDelegate.color(const [
                          '**',
                          'Fill 1',
                          '**',
                        ], value: color!),
                        ValueDelegate.color(const [
                          '**',
                          'Fill 2',
                          '**',
                        ], value: color!),
                        ValueDelegate.color(const [
                          '**',
                          '**',
                          'Color',
                        ], value: color!),
                      ],
                    ),
            ),
            const SizedBox(height: TSizes.defaultSpace),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.defaultSpace),
            if (showAction)
              SizedBox(
                width: 270,
                child: OutlinedButton(
                  onPressed: onActionPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Center(
                      child: Text(
                        actionText!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}
