import 'package:brother_admin_panel/features/permissions/widgets/permissions_header.dart';
import 'package:brother_admin_panel/features/permissions/widgets/permissions_table.dart';
import 'package:brother_admin_panel/features/permissions/widgets/permissions_stats.dart';
import 'package:brother_admin_panel/features/permissions/widgets/permissions_management_toolbar.dart';
import 'package:brother_admin_panel/features/permissions/widgets/permissions_management_panel.dart';
import 'package:brother_admin_panel/features/permissions/widgets/permissions_analytics.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionsDesktopTablet extends StatelessWidget {
  const PermissionsDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const PermissionsHeader(),
            const SizedBox(height: TSizes.spaceBtWsections),

            // Management Toolbar
            const PermissionsManagementToolbar(),
            const SizedBox(height: TSizes.spaceBtWsections),

            // Stats and Analytics Row
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats
                Expanded(
                  flex: 1,
                  child: PermissionsStats(),
                ),
                SizedBox(width: TSizes.defaultSpace),

                // Analytics
                Expanded(
                  flex: 1,
                  child: PermissionsAnalytics(),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtWsections),

            // Management Panel
            const PermissionsManagementPanel(),
            const SizedBox(height: TSizes.spaceBtWsections),

            // Permissions Table Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'permissionsList'.tr,
                    style: const TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.sm),
                  const PermissionsTable(),
                ],
              ),
            ),

            // Add some bottom padding for the floating action button
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
