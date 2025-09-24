import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/product_controller.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/products/index.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GetBuilder<ProductController>(
        builder: (productController) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Title Section
                ProductsPageTitle(isDark: isDark),

                // Stats Cards
                ProductsStatsCards(
                  isDark: isDark,
                  controller: productController,
                ),

                // Header with Search and Add Button
                ProductsSearchHeader(
                  isDark: isDark,
                  controller: controller,
                ),

                // Content
                if (productController.isFormMode)
                  ProductsFormView(
                    isDark: isDark,
                    controller: productController,
                    product: productController
                        .selectedProduct, // Pass the selected product
                  )
                else
                  ProductsList(
                    isDark: isDark,
                    controller: productController,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
