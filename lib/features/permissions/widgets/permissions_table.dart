import 'package:brother_admin_panel/data/models/permission_model.dart';
import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/features/permissions/widgets/edit_permission_dialog.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PermissionsTable extends StatelessWidget {
  const PermissionsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PermissionsController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final permissions = controller.filteredPermissions;

      if (permissions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.security_user,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: TSizes.defaultSpace),
              Text(
                'noPermissions'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: 'IBM Plex Sans Arabic',
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: TSizes.sm),
              Text(
                'addNewPermissionHint'.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'IBM Plex Sans Arabic',
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        );
      }

      return Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  'name'.tr,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'phoneNumber'.tr,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'email'.tr,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'role'.tr,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'status'.tr,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'actions'.tr,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            rows: permissions.map((permission) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      permission.name,
                      style:
                          const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                    ),
                  ),
                  DataCell(
                    Text(
                      permission.phoneNumber,
                      style:
                          const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                    ),
                  ),
                  DataCell(
                    Text(
                      permission.email,
                      style:
                          const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.sm,
                        vertical: TSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: TColors.primary.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(TSizes.borderRadiusSm),
                      ),
                      child: Text(
                        permission.role == 'manager'
                            ? 'manager'.tr
                            : permission.role,
                        style: const TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          color: TColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    GestureDetector(
                      onTap: () =>
                          controller.toggleAuthorization(permission.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm,
                          vertical: TSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: permission.isAuthorized
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(TSizes.borderRadiusSm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              permission.isAuthorized
                                  ? Iconsax.tick_circle
                                  : Iconsax.close_circle,
                              size: 16,
                              color: permission.isAuthorized
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: TSizes.xs),
                            Text(
                              permission.isAuthorized
                                  ? 'authorized'.tr
                                  : 'unauthorized'.tr,
                              style: TextStyle(
                                fontFamily: 'IBM Plex Sans Arabic',
                                color: permission.isAuthorized
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _showEditDialog(context, permission),
                          icon: const Icon(Iconsax.edit, size: 20),
                          color: TColors.primary,
                        ),
                        IconButton(
                          onPressed: () =>
                              _showDeleteDialog(context, permission),
                          icon: const Icon(Iconsax.trash, size: 20),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  void _showEditDialog(BuildContext context, PermissionModel permission) {
    try {
      if (!Get.isRegistered<PermissionsController>()) {
        Get.snackbar(
          'خطأ',
          'وحدة التحكم غير متاحة. يرجى إعادة تحميل الصفحة.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      Get.dialog(EditPermissionDialog(permission: permission));
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في فتح حوار التعديل: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showDeleteDialog(BuildContext context, PermissionModel permission) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'confirmDelete'.tr,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        content: Text(
          'confirmDeletePermission'.trParams({'name': permission.name}),
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'cancel'.tr,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.find<PermissionsController>().deletePermission(permission.id);
              Get.back();
            },
            child: Text(
              'delete'.tr,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
