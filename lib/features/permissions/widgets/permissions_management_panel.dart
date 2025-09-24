import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PermissionsManagementPanel extends StatelessWidget {
  const PermissionsManagementPanel({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Iconsax.setting_2,
                color: TColors.primary,
                size: 24,
              ),
              const SizedBox(width: TSizes.sm),
              Text(
                'إدارة الصلاحيات المتقدمة',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.defaultSpace),

          // Management Options
          Obx(() {
            final permissions = controller.permissions;
            final authorizedCount =
                permissions.where((p) => p.isAuthorized).length;
            final unauthorizedCount = permissions.length - authorizedCount;

            return Column(
              children: [
                // Quick Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickStatCard(
                        context,
                        'إجمالي المدراء',
                        permissions.length.toString(),
                        Iconsax.people,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    Expanded(
                      child: _buildQuickStatCard(
                        context,
                        'نشط',
                        authorizedCount.toString(),
                        Iconsax.tick_circle,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    Expanded(
                      child: _buildQuickStatCard(
                        context,
                        'معطل',
                        unauthorizedCount.toString(),
                        Iconsax.close_circle,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.defaultSpace),

                // Management Actions
                Wrap(
                  spacing: TSizes.sm,
                  runSpacing: TSizes.sm,
                  children: [
                    _buildActionButton(
                      context,
                      'تفعيل الكل',
                      Iconsax.tick_circle,
                      Colors.green,
                      _bulkAuthorizeAll,
                    ),
                    _buildActionButton(
                      context,
                      'إلغاء الكل',
                      Iconsax.close_circle,
                      Colors.orange,
                      _bulkUnauthorizeAll,
                    ),
                    _buildActionButton(
                      context,
                      'تصدير البيانات',
                      Iconsax.export,
                      Colors.blue,
                      _exportData,
                    ),
                    _buildActionButton(
                      context,
                      'استيراد البيانات',
                      Iconsax.import,
                      Colors.purple,
                      _importData,
                    ),
                    _buildActionButton(
                      context,
                      'نسخ احتياطي',
                      Iconsax.save_2,
                      Colors.teal,
                      _backupData,
                    ),
                    _buildActionButton(
                      context,
                      'استعادة النسخة',
                      Iconsax.refresh,
                      Colors.indigo,
                      _restoreData,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.defaultSpace),

                // Advanced Settings
                ExpansionTile(
                  title: const Text(
                    'الإعدادات المتقدمة',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    ListTile(
                      leading: const Icon(Iconsax.shield_tick),
                      title: const Text(
                        'تفعيل التحقق الثنائي',
                        style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                      ),
                      subtitle: const Text(
                        'يتطلب التحقق من رقم الهاتف والبريد الإلكتروني',
                        style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                      ),
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // TODO: Implement 2FA toggle
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.clock),
                      title: const Text(
                        'انتهاء صلاحية تلقائي',
                        style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                      ),
                      subtitle: const Text(
                        'انتهاء صلاحية المدراء بعد 30 يوم',
                        style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                      ),
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {
                          // TODO: Implement auto-expiry toggle
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.notification),
                      title: const Text(
                        'إشعارات التغييرات',
                        style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                      ),
                      subtitle: const Text(
                        'إرسال إشعارات عند تغيير الصلاحيات',
                        style: TextStyle(fontFamily: 'IBM Plex Sans Arabic'),
                      ),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {
                          // TODO: Implement notifications toggle
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: TSizes.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
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

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(
        title,
        style: const TextStyle(
          fontFamily: 'IBM Plex Sans Arabic',
          fontSize: 12,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: TSizes.sm,
          vertical: TSizes.xs,
        ),
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
    Get.snackbar('نجح', 'تم تفعيل جميع الصلاحيات');
  }

  void _bulkUnauthorizeAll() {
    final controller = Get.find<PermissionsController>();
    for (var permission in controller.permissions) {
      if (permission.isAuthorized) {
        controller.toggleAuthorization(permission.id);
      }
    }
    Get.snackbar('نجح', 'تم إلغاء جميع الصلاحيات');
  }

  void _exportData() {
    Get.snackbar('قريباً', 'ستتوفر ميزة تصدير البيانات قريباً');
  }

  void _importData() {
    Get.snackbar('قريباً', 'ستتوفر ميزة استيراد البيانات قريباً');
  }

  void _backupData() {
    Get.snackbar('قريباً', 'ستتوفر ميزة النسخ الاحتياطي قريباً');
  }

  void _restoreData() {
    Get.snackbar('قريباً', 'ستتوفر ميزة استعادة النسخة قريباً');
  }
}
