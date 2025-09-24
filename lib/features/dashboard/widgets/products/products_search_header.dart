import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/product_controller.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';

class ProductsSearchHeader extends StatelessWidget {
  final bool isDark;
  final ProductController controller;

  const ProductsSearchHeader({
    super.key,
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
            _buildCompactSearchBar(context, isDark, controller),
            const SizedBox(height: 16),
            _buildAddButton(context, isDark, controller),
            const SizedBox(height: 16),
            _buildFiltersRow(context, isDark, controller),
          ],
        ),
        tablet: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildCompactSearchBarForRow(
                        context, isDark, controller)),
                const SizedBox(width: 16),
                _buildAddButton(context, isDark, controller),
              ],
            ),
            const SizedBox(height: 16),
            _buildFiltersRow(context, isDark, controller),
          ],
        ),
        desktop: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildCompactSearchBarForRow(
                        context, isDark, controller)),
                const SizedBox(width: 16),
                _buildAddButton(context, isDark, controller),
              ],
            ),
            const SizedBox(height: 16),
            _buildFiltersRow(context, isDark, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersRow(
      BuildContext context, bool isDark, ProductController controller) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black12 : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isDark ? Colors.white24 : Colors.grey.shade300),
            ),
            child: DropdownButton<String>(
              value: controller.sortBy,
              onChanged: (String? newValue) {
                if (newValue != null) controller.sortProducts(newValue);
              },
              items: [
                DropdownMenuItem(value: 'title', child: Text('name'.tr)),
                DropdownMenuItem(value: 'price', child: Text('price'.tr)),
                DropdownMenuItem(value: 'stock', child: Text('stock'.tr)),
                DropdownMenuItem(value: 'sku', child: Text('sku'.tr)),
              ],
              underline: Container(),
              icon: Icon(Icons.sort,
                  color: isDark ? Colors.white70 : Colors.grey.shade600),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {
            final newOrder = controller.sortOrder == 'asc' ? 'desc' : 'asc';
            controller.sortProducts(controller.sortBy, order: newOrder);
          },
          icon: Icon(
            controller.sortOrder == 'asc'
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: isDark ? Colors.white70 : Colors.grey.shade600,
          ),
          style: IconButton.styleFrom(
            backgroundColor: isDark ? Colors.black12 : Colors.white,
            side: BorderSide(
                color: isDark ? Colors.white24 : Colors.grey.shade300),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactSearchBar(
      BuildContext context, bool isDark, ProductController controller) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: productController.isSearchExpanded
              ? ResponsiveHelper.isMobile(context)
                  ? null // استخدام null للعرض الكامل في الموبايل
                  : ResponsiveHelper.isTablet(context)
                      ? 400
                      : 500
              : 50,
          height: ResponsiveHelper.isMobile(context) ? 45 : 50,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(
                ResponsiveHelper.isMobile(context) ? 22.5 : 25),
            border: Border.all(
                color: isDark ? Colors.white24 : Colors.grey.shade300),
            boxShadow: isDark
                ? [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]
                : [
                    BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => productController.toggleSearchExpansion(),
                icon: Icon(
                  productController.isSearchExpanded
                      ? Icons.close
                      : Icons.search,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                  size: ResponsiveHelper.isMobile(context) ? 18 : 20,
                ),
              ),
              if (productController.isSearchExpanded)
                Expanded(
                  child: TextField(
                    onChanged: (query) =>
                        productController.searchProducts(query),
                    decoration: InputDecoration(
                      hintText: 'searchInProducts'.tr,
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                        fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal:
                              ResponsiveHelper.isMobile(context) ? 6 : 8),
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

  Widget _buildCompactSearchBarForRow(
      BuildContext context, bool isDark, ProductController controller) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return Flexible(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: productController.isSearchExpanded
                ? ResponsiveHelper.isTablet(context)
                    ? 400
                    : 500
                : 50,
            height: ResponsiveHelper.isMobile(context) ? 45 : 50,
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(
                  ResponsiveHelper.isMobile(context) ? 22.5 : 25),
              border: Border.all(
                  color: isDark ? Colors.white24 : Colors.grey.shade300),
              boxShadow: isDark
                  ? [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ]
                  : [
                      BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => productController.toggleSearchExpansion(),
                  icon: Icon(
                    productController.isSearchExpanded
                        ? Icons.close
                        : Icons.search,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                    size: ResponsiveHelper.isMobile(context) ? 18 : 20,
                  ),
                ),
                if (productController.isSearchExpanded)
                  Expanded(
                    child: TextField(
                      onChanged: (query) =>
                          productController.searchProducts(query),
                      decoration: InputDecoration(
                        hintText: 'searchInProducts'.tr,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                          fontSize:
                              ResponsiveHelper.isMobile(context) ? 14 : 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal:
                                ResponsiveHelper.isMobile(context) ? 6 : 8),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton(
      BuildContext context, bool isDark, ProductController controller) {
    return SizedBox(
      width: ResponsiveHelper.isMobile(context)
          ? double.infinity
          : ResponsiveHelper.isTablet(context)
              ? 180
              : 150,
      height: ResponsiveHelper.isMobile(context) ? 60 : 50,
      child: ElevatedButton.icon(
        onPressed: () => controller.showAddForm(),
        icon: Icon(Icons.add,
            color: Colors.white,
            size: ResponsiveHelper.isMobile(context) ? 18 : 20),
        label: Text(
          'addProduct'.tr,
          style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.isMobile(context) ? 15 : 15),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                ResponsiveHelper.isMobile(context) ? 22.5 : 25),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
