import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/features/permissions/widgets/add_permission_dialog.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PermissionsManagementToolbar extends StatelessWidget {
  const PermissionsManagementToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PermissionsController>();

    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search and Filter Row
          Row(
            children: [
              // Search Field
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                    border: Border.all(
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      controller.updateSearchQuery(value);
                      controller.searchPermissions(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'searchManagers'.tr,
                      hintStyle: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        color: Theme.of(context).hintColor,
                      ),
                      prefixIcon: const Icon(Iconsax.search_normal),
                      suffixIcon:
                          Obx(() => controller.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    controller.updateSearchQuery('');
                                    controller.searchPermissions('');
                                  },
                                  icon: const Icon(Iconsax.close_circle),
                                )
                              : const SizedBox.shrink()),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: TSizes.defaultSpace,
                        vertical: TSizes.sm,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: TSizes.sm),

              // Filter Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                  border: Border.all(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'all',
                    items: [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text(
                          'allPermissions'.tr,
                          style: const TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'authorized',
                        child: Text(
                          'authorizedOnly'.tr,
                          style: const TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'unauthorized',
                        child: Text(
                          'unauthorizedOnly'.tr,
                          style: const TextStyle(
                              fontFamily: 'IBM Plex Sans Arabic'),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == 'authorized') {
                        controller.getPermissionsByStatus(true);
                      } else if (value == 'unauthorized') {
                        controller.getPermissionsByStatus(false);
                      } else {
                        controller.loadPermissions();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: TSizes.sm),

              // Refresh Button
              IconButton(
                onPressed: controller.refreshPermissions,
                icon: const Icon(Iconsax.refresh),
                color: TColors.primary,
                tooltip: 'refresh'.tr,
              ),
            ],
          ),

          const SizedBox(height: TSizes.defaultSpace),

          // Action Buttons Row
          Row(
            children: [
              // Bulk Actions
              Expanded(
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showBulkActionsDialog(context),
                      icon: const Icon(Iconsax.more_circle),
                      label: Text(
                        'bulkActions'.tr,
                        style:
                            const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    OutlinedButton.icon(
                      onPressed: () => _showExportDialog(context),
                      icon: const Icon(Iconsax.export),
                      label: Text(
                        'export'.tr,
                        style:
                            const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    OutlinedButton.icon(
                      onPressed: () => _showImportDialog(context),
                      icon: const Icon(Iconsax.import),
                      label: Text(
                        'import'.tr,
                        style:
                            const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                      ),
                    ),
                  ],
                ),
              ),

              // Add Permission Button
              ElevatedButton.icon(
                onPressed: () => Get.dialog(const AddPermissionDialog()),
                icon: const Icon(Iconsax.add),
                label: Text(
                  'addPermission'.tr,
                  style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBulkActionsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'bulkActions'.tr,
          style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.tick_circle, color: Colors.green),
              title: Text(
                'authorizeAllPermissions'.tr,
                style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
              ),
              onTap: () {
                Get.back();
                _bulkAuthorizeAll();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.close_circle, color: Colors.red),
              title: Text(
                'unauthorizeAllPermissions'.tr,
                style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
              ),
              onTap: () {
                Get.back();
                _bulkUnauthorizeAll();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.trash, color: Colors.red),
              title: Text(
                'deleteAllPermissions'.tr,
                style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
              ),
              onTap: () {
                Get.back();
                _showBulkDeleteConfirmation();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'cancel'.tr,
              style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'exportPermissions'.tr,
          style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        content: Text(
          'exportPermissionsMessage'.tr,
          style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'cancel'.tr,
              style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _exportPermissions();
            },
            child: Text(
              'export'.tr,
              style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'importPermissions'.tr,
          style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        content: Text(
          'importPermissionsMessage'.tr,
          style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'cancel'.tr,
              style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _importPermissions();
            },
            child: Text(
              'import'.tr,
              style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
        ],
      ),
    );
  }

  void _bulkAuthorizeAll() {
    final controller = Get.find<PermissionsController>();
    for (var permission in controller.permissions) {
      if (!permission.isAuthorized) {
        controller.toggleAuthorization(permission.id);
      }
    }
  }

  void _bulkUnauthorizeAll() {
    final controller = Get.find<PermissionsController>();
    for (var permission in controller.permissions) {
      if (permission.isAuthorized) {
        controller.toggleAuthorization(permission.id);
      }
    }
  }

  void _showBulkDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'confirmBulkDelete'.tr,
          style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        content: Text(
          'confirmBulkDeleteMessage'.tr,
          style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'cancel'.tr,
              style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _bulkDeleteAll();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'deleteAll'.tr,
              style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
        ],
      ),
    );
  }

  void _bulkDeleteAll() {
    final controller = Get.find<PermissionsController>();
    for (var permission in controller.permissions) {
      controller.deletePermission(permission.id);
    }
  }

  void _exportPermissions() {
    // TODO: Implement CSV export
    Get.snackbar('comingSoon'.tr, 'exportFeatureComingSoon'.tr);
  }

  void _importPermissions() {
    // TODO: Implement CSV import
    Get.snackbar('comingSoon'.tr, 'importFeatureComingSoon'.tr);
  }
}
