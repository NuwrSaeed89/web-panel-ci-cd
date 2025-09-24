import 'package:brother_admin_panel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TCouponCode extends StatelessWidget {
  const TCouponCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      showBorder: true,
      backgroundColor: dark ? TColors.dark : TColors.light,
      padding: const EdgeInsets.only(
          top: TSizes.sm, bottom: TSizes.sm, left: TSizes.md, right: TSizes.sm),
      child: Row(
        children: [
          Flexible(
              child: TextFormField(
            decoration: const InputDecoration(
                hintText: 'Have a promo code ?Enter here',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none),
          )),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
                  foregroundColor: dark
                      ? TColors.white.withValues(alpha: 0.5)
                      : TColors.black.withValues(alpha: 0.5)),
              child: const Text('Applay'))
        ],
      ),
    );
  }
}
