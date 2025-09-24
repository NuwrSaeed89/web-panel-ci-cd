import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/product_controller.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/products/product_card.dart';

class ProductsList extends StatelessWidget {
  final bool isDark;
  final ProductController controller;

  const ProductsList({
    super.key,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: GetBuilder<ProductController>(
        builder: (productController) {
          if (productController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productController.filteredProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: isDark ? Colors.white54 : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد منتجات',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'قم بإضافة منتج جديد أو تغيير معايير البحث',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ResponsiveHelper.responsiveBuilder(
            context: context,
            mobile: _buildMobileMasonry(productController),
            tablet: _buildTabletMasonry(productController),
            desktop: _buildDesktopMasonry(productController),
          );
        },
      ),
    );
  }

  Widget _buildMobileMasonry(ProductController controller) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2, // 2 أعمدة للهاتف
      crossAxisSpacing: 8, // مسافة بين الأعمدة
      mainAxisSpacing: 8, // مسافة بين الصفوف
      itemCount: controller.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = controller.filteredProducts[index];
        return ProductCard(
          product: product,
          isDark: isDark,
          controller: controller,
        );
      },
    );
  }

  Widget _buildTabletMasonry(ProductController controller) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4, // 4 أعمدة للتابلت
      crossAxisSpacing: 16, // مسافة بين الأعمدة
      mainAxisSpacing: 16, // مسافة بين الصفوف
      itemCount: controller.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = controller.filteredProducts[index];
        return ProductCard(
          product: product,
          isDark: isDark,
          controller: controller,
        );
      },
    );
  }

  Widget _buildDesktopMasonry(ProductController controller) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 6, // 6 أعمدة للحاسب
      crossAxisSpacing: 20, // مسافة بين الأعمدة
      mainAxisSpacing: 20, // مسافة بين الصفوف
      itemCount: controller.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = controller.filteredProducts[index];
        return ProductCard(
          product: product,
          isDark: isDark,
          controller: controller,
        );
      },
    );
  }
}
