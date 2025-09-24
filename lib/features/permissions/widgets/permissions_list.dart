import 'package:brother_admin_panel/data/models/permission_model.dart';
import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/features/permissions/widgets/edit_permission_dialog.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PermissionsList extends StatelessWidget {
  const PermissionsList({super.key});

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
                'لا توجد صلاحيات',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: 'IBM Plex Sans Arabic',
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: TSizes.sm),
              Text(
                'اضغط على + لإضافة صلاحية جديدة',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'IBM Plex Sans Arabic',
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: permissions.length,
        itemBuilder: (context, index) {
          final permission = permissions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: TSizes.sm),
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: TColors.primary.withValues(alpha: 0.1),
                        child: const Icon(
                          Iconsax.user,
                          color: TColors.primary,
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              permission.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              permission.role == 'manager'
                                  ? 'مدير'
                                  : permission.role,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    color: TColors.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
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
                                permission.isAuthorized ? 'مصرح' : 'غير مصرح',
                                style: TextStyle(
                                  fontFamily: 'IBM Plex Sans Arabic',
                                  color: permission.isAuthorized
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.sm),
                  Row(
                    children: [
                      Icon(Iconsax.mobile, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: TSizes.xs),
                      Text(
                        permission.phoneNumber,
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.xs),
                  Row(
                    children: [
                      Icon(Iconsax.sms, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: TSizes.xs),
                      Expanded(
                        child: Text(
                          permission.email,
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => _showEditDialog(context, permission),
                        icon: const Icon(Iconsax.edit, size: 20),
                        color: TColors.primary,
                      ),
                      IconButton(
                        onPressed: () => _showDeleteDialog(context, permission),
                        icon: const Icon(Iconsax.trash, size: 20),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _showEditDialog(BuildContext context, PermissionModel permission) {
    try {
      // التحقق من وجود وحدة التحكم
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
