import 'package:brother_admin_panel/common/widgets/images/rounded_image.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/enums.dart';
import 'package:brother_admin_panel/utils/constants/image_strings.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key, this.scaffoldKey});
  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(bottom: BorderSide(color: TColors.grey, width: 1))),
      padding: const EdgeInsets.symmetric(
          horizontal: TSizes.md, vertical: TSizes.sm),
      child: AppBar(
        leading: !TDeviceUtils.isDesktopScreen(context)
            ? IconButton(
                onPressed: () => scaffoldKey?.currentState?.openDrawer(),
                icon: const Icon(Iconsax.menu),
              )
            : null,
        title: TDeviceUtils.isDesktopScreen(context)
            ? SizedBox(
                width: 400,
                child: TextFormField(
                  decoration: const InputDecoration(
                      //border: OutlineInputBorder(),
                      // enabledBorder: OutlineInputBorder(),
                      prefixIcon: Icon(Iconsax.search_normal),
                      hintText: 'Search Here ......'),
                ),
              )
            : null,
        actions: [
          //Search icon on mobile
          if (!TDeviceUtils.isDesktopScreen(context))
            IconButton(
                onPressed: () {}, icon: const Icon(Iconsax.search_normal)),
          //Notification Icon
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.notification)),
          const SizedBox(
            width: TSizes.spaceBtWItems / 2,
          ),

          //User Data
          Row(
            children: [
              const TRoundedImage(
                  width: 40,
                  height: 40,
                  padding: 2,
                  imageType: ImageType.asset,
                  image: TImages.userprofile),
              const SizedBox(
                width: TSizes.sm,
              ),
              Column(
                children: [
                  Text(
                    'Eng.Nuwar Saed',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'nuwar.m.saeed@gmail.com',
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                ],
              )
            ],
          ),

          // Row(
          //   children: [
          //     SizedBox(
          //       width: 40,
          //       height: 40,
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(3),
          //         child: const Image(
          //           image: AssetImage(TImages.userprofile),
          //         ),
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppbarHeight() + 15);
}
