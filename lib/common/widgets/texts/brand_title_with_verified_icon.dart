// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brother_admin_panel/common/widgets/texts/brand_title_text.dart';
import 'package:brother_admin_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';

class TBrandTitleWithVerifiedIcon extends StatelessWidget {
  const TBrandTitleWithVerifiedIcon(
      {Key? key,
      this.title = " ",
      this.textColor,
      this.maxLines = 1,
      this.iconColor = TColors.primary,
      this.textAlign = TextAlign.center,
      this.brandTextSize = TextSizes.small})
      : super(key: key);

  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: TBrandTitleText(
          title: title,
          color: textColor,
          maxLines: maxLines,
          textAlign: textAlign,
          brandTextSize: brandTextSize,
        )),
        const SizedBox(height: TSizes.xs),
        const Icon(
          Iconsax.verify5,
          color: TColors.primary,
          size: TSizes.iconXs,
        )
      ],
    );
  }
}
