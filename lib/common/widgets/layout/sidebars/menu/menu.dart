import 'package:brother_admin_panel/common/widgets/layout/sidebars/sidebar_controller.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TMenuItem extends StatelessWidget {
  const TMenuItem(
      {super.key,
      required this.route,
      required this.icon,
      required this.itemName});
  final String route;
  final String itemName;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SidebarController());
    return InkWell(
      onTap: () => menuController.menuOnTap(route),
      onHover: (hovering) => hovering
          ? menuController.changeHoverItem(route)
          : menuController.changeHoverItem(''),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Container(
            decoration: BoxDecoration(
                color: menuController.isHovering(route) ||
                        menuController.isActive(route)
                    ? TColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(
                  TSizes.cardRadiusMd,
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(TSizes.md),
                    child: menuController.isActive(route)
                        ? Icon(
                            icon,
                            size: 22,
                            color: TColors.white,
                          )
                        : Icon(
                            icon,
                            size: 22,
                            color: menuController.isHovering(route)
                                ? TColors.white
                                : TColors.darkGrey,
                          )),
                if (menuController.isHovering(route) ||
                    menuController.isActive(route))
                  Flexible(
                    child: Text(
                      itemName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: TColors.white),
                    ),
                  )
                else
                  Flexible(
                    child: Text(
                      itemName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: TColors.darkGrey),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
