import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/routs/routs.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PermissionsHeader extends StatelessWidget {
  const PermissionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PermissionsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // على الشاشات الصغيرة، نضع العناصر عمودياً
            if (constraints.maxWidth < 400) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // زر الرجوع
                      IconButton(
                        onPressed: () {
                          Get.offAllNamed(TRoutes.dashboard);
                        },
                        icon: Icon(
                          Iconsax.arrow_right_3,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        tooltip: 'backToDashboard'.tr,
                      ),
                      const SizedBox(width: TSizes.xs),
                      Icon(
                        Iconsax.security_user,
                        size: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.xs),
                  Text(
                    'permissionsManagement'.tr,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              );
            } else {
              // على الشاشات الأكبر، نضع العناصر أفقياً
              return Row(
                children: [
                  // زر الرجوع
                  IconButton(
                    onPressed: () {
                      Get.offAllNamed(TRoutes.dashboard);
                    },
                    icon: Icon(
                      Iconsax.arrow_right_3,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                    tooltip: 'backToDashboard'.tr,
                  ),
                  const SizedBox(width: TSizes.xs),
                  Icon(
                    Iconsax.security_user,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: TSizes.sm),
                  Expanded(
                    child: Text(
                      'permissionsManagement'.tr,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: TSizes.sm),
        Text(
          'permissionsManagementDescription'.tr,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'IBM Plex Sans Arabic',
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: TSizes.defaultSpace),
        // Search bar
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[700]!
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: controller.updateSearchQuery,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            decoration: InputDecoration(
              hintText: 'searchManagers'.tr,
              hintStyle: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[500],
              ),
              prefixIcon: Icon(
                Iconsax.search_normal,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: TSizes.defaultSpace,
                vertical: TSizes.sm,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
