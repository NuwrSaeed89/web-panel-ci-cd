import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PermissionsStats extends StatelessWidget {
  const PermissionsStats({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PermissionsController>();

    return Obx(() {
      final stats = controller.stats;
      final isLoading = controller.isLoading.value;

      if (isLoading && stats.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                // على الشاشات الصغيرة، نضع العناصر عمودياً
                if (constraints.maxWidth < 600) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان والأيقونة
                      Row(
                        children: [
                          const Icon(
                            Iconsax.chart_2,
                            color: TColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: TSizes.sm),
                          Expanded(
                            child: Text(
                              'permissionsStats'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontFamily: 'IBM Plex Sans Arabic',
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.sm),
                      // الأزرار في صف واحد مع ScrollView
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Grant All Button
                            ElevatedButton.icon(
                              onPressed: () => _grantAllPermissions(controller),
                              icon: const Icon(Iconsax.tick_circle, size: 16),
                              label: Text(
                                'grantAll'.tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                            ),
                            const SizedBox(width: TSizes.xs),
                            // Revoke All Button
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _revokeAllPermissions(controller),
                              icon: const Icon(Iconsax.close_circle, size: 16),
                              label: Text(
                                'revokeAll'.tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                            ),
                            const SizedBox(width: TSizes.xs),
                            // Refresh Button
                            IconButton(
                              onPressed: controller.refreshPermissions,
                              icon: const Icon(Iconsax.refresh),
                              color: TColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // على الشاشات الأكبر، نضع العناصر أفقياً
                  return Row(
                    children: [
                      const Icon(
                        Iconsax.chart_2,
                        color: TColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: TSizes.sm),
                      Text(
                        'permissionsStats'.tr,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontFamily: 'IBM Plex Sans Arabic',
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      // Grant All Button
                      ElevatedButton.icon(
                        onPressed: () => _grantAllPermissions(controller),
                        icon: const Icon(Iconsax.tick_circle, size: 16),
                        label: Text(
                          'grantAll'.tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(width: TSizes.xs),
                      // Revoke All Button
                      ElevatedButton.icon(
                        onPressed: () => _revokeAllPermissions(controller),
                        icon: const Icon(Iconsax.close_circle, size: 16),
                        label: Text(
                          'revokeAll'.tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(width: TSizes.xs),
                      // Refresh Button
                      IconButton(
                        onPressed: controller.refreshPermissions,
                        icon: const Icon(Iconsax.refresh),
                        color: TColors.primary,
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: TSizes.defaultSpace),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'totalPermissions'.tr,
                    stats['total']?.toString() ?? '0',
                    Iconsax.security_user,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'authorized'.tr,
                    stats['authorized']?.toString() ?? '0',
                    Iconsax.tick_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'unauthorized'.tr,
                    stats['unauthorized']?.toString() ?? '0',
                    Iconsax.close_circle,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: TSizes.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: color,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _grantAllPermissions(PermissionsController controller) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'grantAllPermissions'.tr,
          style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        content: Text(
          'grantAllPermissionsMessage'.tr,
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
              _performGrantAll(controller);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(
              'grantAll'.tr,
              style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
        ],
      ),
    );
  }

  void _revokeAllPermissions(PermissionsController controller) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'revokeAllPermissions'.tr,
          style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
        ),
        content: Text(
          'revokeAllPermissionsMessage'.tr,
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
              _performRevokeAll(controller);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'revokeAll'.tr,
              style: const TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
            ),
          ),
        ],
      ),
    );
  }

  void _performGrantAll(PermissionsController controller) {
    try {
      int grantedCount = 0;
      for (var permission in controller.permissions) {
        if (!permission.isAuthorized) {
          controller.toggleAuthorization(permission.id);
          grantedCount++;
        }
      }

      Get.snackbar(
        'success'.tr,
        'grantedPermissionsCount'
            .tr
            .replaceAll('{count}', grantedCount.toString()),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'grantAllPermissionsError'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _performRevokeAll(PermissionsController controller) {
    try {
      int revokedCount = 0;
      for (var permission in controller.permissions) {
        if (permission.isAuthorized) {
          controller.toggleAuthorization(permission.id);
          revokedCount++;
        }
      }

      Get.snackbar(
        'success'.tr,
        'revokedPermissionsCount'
            .tr
            .replaceAll('{count}', revokedCount.toString()),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'revokeAllPermissionsError'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
