import 'package:brother_admin_panel/common/widgets/images/rounded_image.dart';
import 'package:brother_admin_panel/routs/routs.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/enums.dart';
import 'package:brother_admin_panel/utils/constants/image_strings.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:brother_admin_panel/common/widgets/layout/sidebars/menu/menu.dart';

class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        shape: const BeveledRectangleBorder(),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: TColors.grey, width: 1))),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TRoundedImage(
                  imageType: ImageType.asset,
                  overLayColor: TColors.primary.withValues(alpha: 0.7),
                  borderRaduis: 100,
                  width: 100,
                  height: 100,
                  image: TImages.bBlack,
                ),
                const SizedBox(
                  height: TSizes.spaceBtWsections,
                ),
                Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Column(
                    children: [
                      Text(
                        'Menu',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(letterSpacingDelta: 1.2),
                      ),
                      // menue items
                      const TMenuItem(
                          route: TRoutes.login,
                          icon: Iconsax.status,
                          itemName: 'Dashboard'),
                      const TMenuItem(
                          route: TRoutes.categories,
                          icon: Iconsax.image,
                          itemName: 'Media'),
                      const TMenuItem(
                          route: TRoutes.banners,
                          icon: Iconsax.picture_frame,
                          itemName: 'Banners')
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
