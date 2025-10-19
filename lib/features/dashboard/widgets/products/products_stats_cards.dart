import 'package:flutter/material.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/product_controller.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:get/get.dart';

class ProductsStatsCards extends StatelessWidget {
  final bool isDark;
  final ProductController controller;

  const ProductsStatsCards({
    super.key,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              isDark,
              'totalProducts'.tr,
              '${controller.productsCount}',
              Icons.inventory,
              Colors.blue,
            ),
          ),
          SizedBox(width: ResponsiveHelper.isMobile(context) ? 8 : 16),
          Expanded(
            child: _buildStatCard(
              context,
              isDark,
              'featuredProducts'.tr,
              '${controller.featuredProductsCount}',
              Icons.star,
              Colors.amber,
            ),
          ),
          SizedBox(width: ResponsiveHelper.isMobile(context) ? 8 : 16),
          Expanded(
            child: _buildStatCard(
              context,
              isDark,
              'lowStockProducts'.tr,
              '${controller.lowStockProductsCount}',
              Icons.warning,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, bool isDark, String title,
      String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 12 : 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1a2e) : Colors.white,
        borderRadius:
            BorderRadius.circular(ResponsiveHelper.isMobile(context) ? 12 : 16),
        border:
            Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        boxShadow: isDark
            ? [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: ResponsiveHelper.isMobile(context) ? 6 : 10,
                    offset:
                        Offset(0, ResponsiveHelper.isMobile(context) ? 2 : 4))
              ]
            : [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: ResponsiveHelper.isMobile(context) ? 4 : 8,
                    offset:
                        Offset(0, ResponsiveHelper.isMobile(context) ? 1 : 2))
              ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.isMobile(context) ? 24 : 40,
            color: color,
          ),
          SizedBox(height: ResponsiveHelper.isMobile(context) ? 8 : 12),
          Text(
            value,
            style: ResponsiveHelper.isMobile(context)
                ? TTextStyles.heading3
                    .copyWith(color: isDark ? Colors.white : Color(0xFF111111))
                : TTextStyles.heading2
                    .copyWith(color: isDark ? Colors.white : Color(0xFF111111)),
          ),
          SizedBox(height: ResponsiveHelper.isMobile(context) ? 6 : 8),
          Text(
            title,
            style: ResponsiveHelper.isMobile(context)
                ? TTextStyles.bodySmall.copyWith(
                    color: isDark ? Colors.white70 : Colors.grey.shade600)
                : TTextStyles.bodyMedium.copyWith(
                    color: isDark ? Colors.white70 : Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
