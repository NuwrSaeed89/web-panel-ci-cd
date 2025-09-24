import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/brand_controller.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';

class BrandHeader extends StatelessWidget {
  final BuildContext context;
  final bool isDark;
  final BrandController controller;

  const BrandHeader({
    super.key,
    required this.context,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ResponsiveHelper.responsiveBuilder(
        context: context,
        mobile: Column(
          children: [
            // Search Bar - full width on mobile
            _buildCompactSearchBar(context, isDark, controller),
            const SizedBox(height: 16),
            // Add Button - full width on mobile
            _buildAddButton(context, isDark, controller),
          ],
        ),
        tablet: Column(
          children: [
            Row(
              children: [
                // Search Bar - takes available space
                Expanded(
                  child: _buildCompactSearchBar(context, isDark, controller),
                ),
                const SizedBox(width: 16),
                // Add Button - fixed width
                _buildAddButton(context, isDark, controller),
              ],
            ),
          ],
        ),
        desktop: Row(
          children: [
            // Search Bar - takes available space
            Expanded(
              child: _buildCompactSearchBar(context, isDark, controller),
            ),
            const SizedBox(width: 16),
            // Add Button - fixed width
            _buildAddButton(context, isDark, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSearchBar(
      BuildContext context, bool isDark, BrandController controller) {
    return GetBuilder<BrandController>(
      builder: (brandController) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: brandController.isSearchExpanded
              ? ResponsiveHelper.isMobile(context)
                  ? double.infinity
                  : ResponsiveHelper.isTablet(context)
                      ? 400
                      : 500
              : 50,
          height: ResponsiveHelper.isMobile(context) ? 45 : 50,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.isMobile(context) ? 22.5 : 25,
            ),
            border: Border.all(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: Row(
            children: [
              // Search Icon Button
              IconButton(
                onPressed: () {
                  brandController.toggleSearchExpansion();
                },
                icon: Icon(
                  brandController.isSearchExpanded ? Icons.close : Icons.search,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                  size: ResponsiveHelper.isMobile(context) ? 18 : 20,
                ),
              ),
              // Search TextField
              if (brandController.isSearchExpanded)
                Expanded(
                  child: TextField(
                    onChanged: (query) {
                      brandController.searchBrands(query);
                    },
                    decoration: InputDecoration(
                      hintText: 'البحث في الماركات...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                        fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.isMobile(context) ? 6 : 8,
                      ),
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddButton(
      BuildContext context, bool isDark, BrandController controller) {
    return SizedBox(
      width: ResponsiveHelper.isMobile(context)
          ? double.infinity
          : ResponsiveHelper.isTablet(context)
              ? 180
              : 150,
      height: ResponsiveHelper.isMobile(context) ? 60 : 50,
      child: ElevatedButton.icon(
        onPressed: () {
          controller.showAddForm();
        },
        icon: Icon(
          Icons.add,
          color: Colors.white,
          size: ResponsiveHelper.isMobile(context) ? 18 : 20,
        ),
        label: Text(
          'إضافة مزود',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.isMobile(context) ? 15 : 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.isMobile(context) ? 22.5 : 25,
            ),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
