import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/product_controller.dart';

class MobileProductsWidget extends StatelessWidget {
  const MobileProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        final themeController = Get.find<ThemeController>();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المنتجات',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // قائمة المنتجات
              Obx(() {
                if (productController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (productController.products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: themeController.isDarkMode
                              ? Colors.white54
                              : Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد منتجات',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 16,
                            color: themeController.isDarkMode
                                ? Colors.white70
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // عمودين
                    crossAxisSpacing: 12, // مسافة بين الأعمدة
                    mainAxisSpacing: 12, // مسافة بين الصفوف
                    childAspectRatio: 0.5, // نسبة العرض إلى الارتفاع
                  ),
                  itemCount: productController.products.length,
                  itemBuilder: (_, index) {
                    final product = productController.products[index];
                    return _buildProductCard(product, themeController);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductCard(dynamic product, ThemeController themeController) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color:
            themeController.isDarkMode ? const Color(0xFF2a2a3e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeController.isDarkMode
              ? Colors.white24
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(product.thumbnail),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // تفاصيل المنتج
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Get.locale?.languageCode == 'en'
                      ? product.title
                      : product.arabicTitle,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode
                        ? Colors.green
                        : Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المخزون: ${product.stock}',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 10,
                        color: themeController.isDarkMode
                            ? Colors.white60
                            : Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // يمكن إضافة تفاعل هنا
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: themeController.isDarkMode
                            ? Colors.white70
                            : Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
