import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PermissionsAnalytics extends StatelessWidget {
  const PermissionsAnalytics({super.key});

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
          Row(
            children: [
              const Icon(
                Iconsax.chart_21,
                color: TColors.primary,
                size: 24,
              ),
              const SizedBox(width: TSizes.sm),
              Text(
                'permissionsAnalytics'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.defaultSpace),
          Obx(() {
            final permissions = controller.permissions;

            return Column(
              children: [
                // Analytics Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildAnalyticsCard(
                        context,
                        'activityRate'.tr,
                        '${_calculateActivityRate(permissions)}%',
                        Iconsax.activity,
                        Colors.green,
                        'activeManagers'.tr,
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    Expanded(
                      child: _buildAnalyticsCard(
                        context,
                        'responseRate'.tr,
                        '${_calculateResponseRate(permissions)}%',
                        Iconsax.timer,
                        Colors.blue,
                        'responseSpeed'.tr,
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    Expanded(
                      child: _buildAnalyticsCard(
                        context,
                        'securityRate'.tr,
                        '${_calculateSecurityRate(permissions)}%',
                        Iconsax.shield_tick,
                        Colors.purple,
                        'securityLevel'.tr,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.defaultSpace),

                // Recent Activity
                Container(
                  padding: const EdgeInsets.all(TSizes.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                    border: Border.all(
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'recentActivity'.tr,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontFamily: 'IBM Plex Sans Arabic',
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: TSizes.sm),
                      ..._buildRecentActivityList(permissions, context),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.defaultSpace),

                // Performance Metrics
                Container(
                  padding: const EdgeInsets.all(TSizes.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                    border: Border.all(
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'performanceMetrics'.tr,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontFamily: 'IBM Plex Sans Arabic',
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: TSizes.sm),
                      _buildPerformanceMetrics(permissions, context),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
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
          Icon(icon, color: color, size: 32),
          const SizedBox(height: TSizes.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRecentActivityList(
      List<dynamic> permissions, BuildContext context) {
    // Mock recent activity data
    final activities = [
      {
        'action': 'managerAdded'.tr,
        'time': '5 ${'minutesAgo'.tr}',
        'type': 'add'
      },
      {
        'action': 'permissionActivated'.tr,
        'time': '10 ${'minutesAgo'.tr}',
        'type': 'activate'
      },
      {
        'action': 'managerDataUpdated'.tr,
        'time': '15 ${'minutesAgo'.tr}',
        'type': 'update'
      },
      {
        'action': 'permissionDeactivated'.tr,
        'time': '20 ${'minutesAgo'.tr}',
        'type': 'deactivate'
      },
    ];

    return activities.map((activity) {
      Color color = Colors.green;
      IconData icon = Iconsax.tick_circle;

      switch (activity['type']) {
        case 'add':
          color = Colors.blue;
          icon = Iconsax.add_circle;
          break;
        case 'activate':
          color = Colors.green;
          icon = Iconsax.tick_circle;
          break;
        case 'update':
          color = Colors.orange;
          icon = Iconsax.edit;
          break;
        case 'deactivate':
          color = Colors.red;
          icon = Iconsax.close_circle;
          break;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: TSizes.xs),
            Expanded(
              child: Text(
                activity['action']!,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              activity['time']!,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 10,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildPerformanceMetrics(
      List<dynamic> permissions, BuildContext context) {
    return Column(
      children: [
        _buildMetricRow('totalOperations'.tr, '${permissions.length * 3}',
            Colors.blue, context),
        _buildMetricRow('successfulOperations'.tr,
            '${(permissions.length * 2.8).round()}', Colors.green, context),
        _buildMetricRow('failedOperations'.tr,
            '${(permissions.length * 0.2).round()}', Colors.red, context),
        _buildMetricRow('averageResponseTime'.tr, '1.2 ${'seconds'.tr}',
            Colors.orange, context),
      ],
    );
  }

  Widget _buildMetricRow(
      String label, String value, Color color, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: TSizes.xs, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateActivityRate(List<dynamic> permissions) {
    if (permissions.isEmpty) return 0;
    final activeCount = permissions.where((p) => p.isAuthorized).length;
    return ((activeCount / permissions.length) * 100).round();
  }

  int _calculateResponseRate(List<dynamic> permissions) {
    // Mock calculation - in real app, this would be based on actual response times
    return 85 + (permissions.length % 15);
  }

  int _calculateSecurityRate(List<dynamic> permissions) {
    if (permissions.isEmpty) return 0;
    // Mock calculation based on various security factors
    return 90 + (permissions.length % 10);
  }
}
