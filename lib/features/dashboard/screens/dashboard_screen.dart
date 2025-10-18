import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/widgets/build_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/localization/language_controller.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/statistics_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/navigation_controller.dart';

class DashboardMainScreen extends StatefulWidget {
  const DashboardMainScreen({super.key});

  @override
  State<DashboardMainScreen> createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  @override
  void initState() {
    super.initState();
    // Update statistics when dashboard is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final statisticsController = Get.find<StatisticsController>();
        statisticsController.onDashboardTabOpened();
      } catch (e) {
        if (kDebugMode) {
          print('Error updating statistics on dashboard open: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? 'user@example.com';
    final userPhone = user?.phoneNumber ?? '';
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;

        return Container(
          color: isDark ? const Color(0xFF1a1a2e) : const Color(0xFFf5f5f5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  child: ResponsiveHelper.responsiveBuilder(
                    context: context,
                    mobile: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'dashboardContent'.tr,
                          style: TTextStyles.heading2.copyWith(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildRefreshButton(isDark, context),
                            const SizedBox(width: 16),
                            _buildLanguageToggle(isDark, context),
                          ],
                        ),
                      ],
                    ),
                    desktop: Row(
                      children: [
                        Text(
                          'dashboardContent'.tr,
                          style: TTextStyles.heading2.copyWith(
                            color: isDark ? Colors.white : Colors.red,
                          ),
                        ),
                        const Spacer(),
                        _buildRefreshButton(isDark, context),
                        const SizedBox(width: 16),
                        _buildLanguageToggle(isDark, context),
                        const SizedBox(width: 8),
                        const BuildUserInfo()
                      ],
                    ),
                  ),
                ),

                // Stats Grid
                Container(
                  margin: ResponsiveHelper.getResponsiveMargin(context),
                  child: GetBuilder<StatisticsController>(
                    builder: (statisticsController) {
                      return Obx(() {
                        if (statisticsController.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount;
                            double childAspectRatio;
                            double spacing;

                            if (constraints.maxWidth > 1200) {
                              // Desktop: 4 columns
                              crossAxisCount = 8;
                              childAspectRatio = 1.2;
                              spacing = 16;
                            } else if (constraints.maxWidth > 900) {
                              // Tablet: 3 columns
                              crossAxisCount = 6;
                              childAspectRatio = 1.1;
                              spacing = 12;
                            } else if (constraints.maxWidth > 600) {
                              // Small tablet: 2 columns
                              crossAxisCount = 4;
                              childAspectRatio = 1.0;
                              spacing = 10;
                            } else {
                              // Mobile: 2 columns (max 2 rows)
                              crossAxisCount = 3;
                              childAspectRatio = 0.9;
                              spacing = 8;
                            }

                            return Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth > 1200
                                      ? 1200
                                      : constraints.maxWidth,
                                ),
                                child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: spacing,
                                  mainAxisSpacing: spacing,
                                  childAspectRatio: childAspectRatio,
                                  children: [
                                    // 1. Projects (Tab 1)
                                    _buildStatCard(
                                      title: 'projects'.tr,
                                      value: statisticsController.totalProjects
                                          .toString(),
                                      icon: Icons.work,
                                      color: TColors.primary,
                                      isDark: isDark,
                                      onTap: () =>
                                          Get.find<NavigationController>()
                                              .navigateToProjects(),
                                    ),
                                    // 2. Price Requests (Tab 2)
                                    _buildStatCard(
                                      title: 'pricesRequest'.tr,
                                      value: statisticsController
                                          .totalPriceRequests
                                          .toString(),
                                      icon: Icons.request_quote,
                                      color: TColors.primary,
                                      isDark: isDark,
                                      onTap: () =>
                                          Get.find<NavigationController>()
                                              .navigateToPriceRequests(),
                                    ),
                                    // 3. Shopping Orders (Tab 3)
                                    _buildStatCard(
                                      title: 'shoppingOrders'.tr,
                                      value: statisticsController.totalOrders
                                          .toString(),
                                      icon: Icons.shopping_cart,
                                      color: TColors.primary,
                                      isDark: isDark,
                                      onTap: () =>
                                          Get.find<NavigationController>()
                                              .navigateToOrders(),
                                    ),
                                    // 4. Categories (Tab 4)
                                    _buildStatCard(
                                      title: 'categories'.tr,
                                      value: statisticsController
                                          .totalCategories
                                          .toString(),
                                      icon: Icons.category,
                                      color: TColors.primary,
                                      isDark: isDark,
                                      onTap: () =>
                                          Get.find<NavigationController>()
                                              .navigateToCategories(),
                                    ),
                                    // 5. Products (Tab 5)
                                    _buildStatCard(
                                      title: 'products'.tr,
                                      value: statisticsController.totalProducts
                                          .toString(),
                                      icon: Icons.inventory,
                                      color: TColors.primary,
                                      isDark: isDark,
                                      onTap: () =>
                                          Get.find<NavigationController>()
                                              .navigateToProducts(),
                                    ),
                                    // 6. Blog (Tab 6)
                                    _buildStatCard(
                                      title: 'totalPosts'.tr,
                                      value: statisticsController.totalBlogs
                                          .toString(),
                                      icon: Icons.article,
                                      color: TColors.primary,
                                      isDark: isDark,
                                      onTap: () =>
                                          Get.find<NavigationController>()
                                              .navigateToBlog(),
                                    ),
                                    // 7. Clients (Tab 7)
                                    _buildStatCard(
                                      title: 'clients'.tr,
                                      value: statisticsController.totalClients
                                          .toString(),
                                      icon: Icons.people,
                                      color: TColors.primary,
                                      isDark: isDark,
                                      onTap: () =>
                                          Get.find<NavigationController>()
                                              .navigateToClients(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      });
                    },
                  ),
                ),

                SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context)),

                // Quick Actions
                Container(
                  margin: ResponsiveHelper.getResponsiveMargin(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'quickActions'.tr,
                        style: TTextStyles.heading3.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(
                          height:
                              ResponsiveHelper.getResponsiveSpacing(context)),
                      ResponsiveHelper.responsiveBuilder(
                        context: context,
                        mobile: Column(
                          children: [
                            _buildQuickActionCard(
                              title: 'projectsTracker'.tr,
                              description:
                                  'Track and manage your projects efficiently',
                              icon: Icons.track_changes,
                              color: TColors.primary,
                              isDark: isDark,
                              onTap: () => Get.find<NavigationController>()
                                  .navigateToProjects(),
                            ),
                            const SizedBox(height: 16),
                            _buildQuickActionCard(
                              title: 'pricesRequest'.tr,
                              description:
                                  'Manage and track price requests from clients',
                              icon: Icons.price_check,
                              color: TColors.primary,
                              isDark: isDark,
                              onTap: () => Get.find<NavigationController>()
                                  .navigateToPriceRequests(),
                            ),
                            const SizedBox(height: 16),
                            _buildQuickActionCard(
                              title: 'interviews'.tr,
                              description:
                                  'Manage and schedule interview requests',
                              icon: Icons.person,
                              color: TColors.primary,
                              isDark: isDark,
                              onTap: () => Get.find<NavigationController>()
                                  .navigateToOrders(),
                            ),
                            const SizedBox(height: 16),
                            _buildQuickActionCard(
                              title: 'permissionsManagementTitle'.tr,
                              description: 'permissionsManagementSubtitle'.tr,
                              icon: Icons.security,
                              color: TColors.primary,
                              isDark: isDark,
                              onTap: () => Get.toNamed('/permissions'),
                            ),
                          ],
                        ),
                        desktop: Row(
                          children: [
                            Expanded(
                              child: _buildQuickActionCard(
                                title: 'projectsTracker'.tr,
                                description:
                                    'Track and manage your projects efficiently',
                                icon: Icons.track_changes,
                                color: TColors.primary,
                                isDark: isDark,
                                onTap: () => Get.find<NavigationController>()
                                    .navigateToProjects(),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildQuickActionCard(
                                title: 'pricesRequest'.tr,
                                description:
                                    'Manage and track price requests from clients',
                                icon: Icons.price_check,
                                color: TColors.primary,
                                isDark: isDark,
                                onTap: () => Get.find<NavigationController>()
                                    .navigateToPriceRequests(),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildQuickActionCard(
                                title: 'interviews'.tr,
                                description:
                                    'Manage and schedule interview requests',
                                icon: Icons.person,
                                color: TColors.primary,
                                isDark: isDark,
                                onTap: () => Get.find<NavigationController>()
                                    .navigateToOrders(),
                              ),
                            ),
                            const SizedBox(width: 20),
                            if (userEmail == 'nuwar.m.saeed@gmail.com' ||
                                userEmail == 'n.alhassibi@gmail.com' ||
                                userPhone == '+971503780091')
                              Expanded(
                                child: _buildQuickActionCard(
                                  title: 'permissionsManagementTitle'.tr,
                                  description:
                                      'permissionsManagementSubtitle'.tr,
                                  icon: Icons.security,
                                  color: TColors.primary,
                                  isDark: isDark,
                                  onTap: () => Get.toNamed('/permissions'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context)),

                // Recent Activity
                Visibility(
                  visible: false,
                  child: Container(
                    margin: ResponsiveHelper.getResponsiveMargin(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'recentActivity'.tr,
                          style: TTextStyles.heading3.copyWith(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(
                            height:
                                ResponsiveHelper.getResponsiveSpacing(context)),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return _buildActivityItem(
                              title: '${'activity'.tr} ${index + 1}',
                              description:
                                  'This is a recent activity description',
                              time:
                                  '${index + 1} ${index == 0 ? 'hourAgo'.tr : 'hoursAgo'.tr}',
                              icon: Icons.notifications,
                              isDark: isDark,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRefreshButton(bool isDark, BuildContext context) {
    return GetBuilder<StatisticsController>(
      builder: (statisticsController) {
        return Obx(() {
          return IconButton(
            onPressed: statisticsController.isLoading
                ? null
                : () => statisticsController.refreshStatistics(),
            icon: statisticsController.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            tooltip: 'refreshStatistics'.tr,
            style: IconButton.styleFrom(
              backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
              foregroundColor: isDark ? Colors.white : Colors.black87,
            ),
          );
        });
      },
    );
  }

  Widget _buildLanguageToggle(bool isDark, BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (languageController) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.isMobile(context) ? 16 : 12,
            vertical: ResponsiveHelper.isMobile(context) ? 12 : 8,
          ),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languageController.currentLanguageName,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 16,
                    tablet: 14,
                    desktop: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.language,
                color: isDark ? Colors.white70 : Colors.black54,
                size: ResponsiveHelper.getResponsiveIconSize(
                  context,
                  mobile: 24,
                  tablet: 20,
                  desktop: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: TColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
