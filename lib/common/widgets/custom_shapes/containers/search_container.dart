// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/device/device_utility.dart';
import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer(
      {Key? key,
      required this.text,
      this.icon,
      this.padding =
          const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      this.showBorder = false,
      this.showBackground = true,
      this.onTap})
      : super(key: key);

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
          padding: padding,
          child: Container(
              width: TDeviceUtils.getScreenWidth(context),
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                  color: TColors.white,
                  border: showBorder ? Border.all(color: Colors.grey) : null,
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusLg)),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: dark ? TColors.black : TColors.black,
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtWItems,
                  ),
                  Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .apply(color: dark ? TColors.black : TColors.black),
                  )
                ],
              ))),
    );
  }
}
