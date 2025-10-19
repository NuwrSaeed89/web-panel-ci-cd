import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/brand_controller.dart';
import 'package:brother_admin_panel/data/models/brand_model.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';

import 'package:cached_network_image/cached_network_image.dart';

class MobileBrandsWidget extends StatelessWidget {
  const MobileBrandsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final brandController = Get.find<BrandController>();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: themeController.isDarkMode
          ? const Color(0xFF1a1a2e)
          : const Color(0xFFf5f5f5),
      child: Column(
        children: [
          // شريط البحث
          _buildSearchBar(themeController, brandController),

          // قائمة العلامات التجارية
          Expanded(
            child: _buildBrandsList(themeController, brandController),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
      ThemeController themeController, BrandController brandController) {
    return Text(
      'brands'
          .tr, // Fixed: re.trplaced undefined 'brands.tr' with a string literal
      style: TextStyle(
        fontFamily: 'IBM Plex Sans Arabic',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: themeController.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildBrandsList(
      ThemeController themeController, BrandController brandController) {
    return Obx(() {
      if (brandController.isLoading) {
        return _buildLoadingState(themeController);
      }

      if (brandController.filteredBrands.isEmpty) {
        return _buildEmptyState(themeController);
      }

      return RefreshIndicator(
        onRefresh: () async {
          await brandController.refreshData();
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: brandController.filteredBrands.length,
          itemBuilder: (context, index) {
            final brand = brandController.filteredBrands[index];
            return _buildBrandCard(
                themeController, brandController, brand, context);
          },
        ),
      );
    });
  }

  Widget _buildLoadingState(ThemeController themeController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: themeController.isDarkMode ? Colors.white : Colors.blue,
          ),
          const SizedBox(height: 16),
          Text(
            'جاري تحميل العلامات التجارية...',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              color: themeController.isDarkMode
                  ? Colors.white70
                  : Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeController themeController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: 64,
            color: themeController.isDarkMode
                ? Colors.white30
                : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد علامات تجارية',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              color: themeController.isDarkMode
                  ? Colors.white70
                  : Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على + لإضافة علامة تجارية جديدة',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              color: themeController.isDarkMode
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandCard(ThemeController themeController,
      BrandController brandController, BrandModel brand, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // التحقق من أن الـ widget ما زال محملاً
        if (!context.mounted) return;

        // عرض تفاصيل العلامة التجارية
        brandController.selectBrand(brand);
        _showBrandDetails(themeController, brandController, brand, context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: themeController.isDarkMode
              ? const Color(0xFF222222)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: themeController.isDarkMode
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة العلامة التجارية
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  color: themeController.isDarkMode
                      ? const Color(0xFF222222)
                      : Colors.grey.shade100,
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: brand.image.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: brand.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: themeController.isDarkMode
                                ? const Color(0xFF222222)
                                : Colors.grey.shade100,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: themeController.isDarkMode
                                    ? Colors.white
                                    : Colors.blue,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: themeController.isDarkMode
                                ? const Color(0xFF222222)
                                : Colors.grey.shade100,
                            child: Icon(
                              Icons.business_outlined,
                              color: themeController.isDarkMode
                                  ? Colors.white30
                                  : Colors.grey.shade400,
                              size: 32,
                            ),
                          ),
                        )
                      : Container(
                          color: themeController.isDarkMode
                              ? const Color(0xFF222222)
                              : Colors.grey.shade100,
                          child: Icon(
                            Icons.business_outlined,
                            color: themeController.isDarkMode
                                ? Colors.white30
                                : Colors.grey.shade400,
                            size: 32,
                          ),
                        ),
                ),
              ),
            ),

            // معلومات العلامة التجارية
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم العلامة التجارية
                    Text(
                      brand.name,
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Color(0xFF111111),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // عدد المنتجات
                    Text(
                      '${brand.productCount ?? 0} منتج',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        color: themeController.isDarkMode
                            ? Colors.white60
                            : Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),

                    const Spacer(),

                    // مؤشر المميز
                    if (brand.isFeature == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'مميز',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBrandDetails(ThemeController themeController,
      BrandController brandController, BrandModel brand, BuildContext context) {
    // التحقق من أن الـ widget ما زال محملاً
    if (!context.mounted) return;

    Get.bottomSheet(
      Container(
        height: 300,
        decoration: BoxDecoration(
          color: themeController.isDarkMode
              ? const Color(0xFF222222)
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // مقبض السحب
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: themeController.isDarkMode
                    ? Colors.white30
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // صورة العلامة التجارية
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: themeController.isDarkMode
                    ? const Color(0xFF222222)
                    : Colors.grey.shade100,
              ),
              child: brand.image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CachedNetworkImage(
                        imageUrl: brand.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.blue,
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.business_outlined,
                          color: themeController.isDarkMode
                              ? Colors.white30
                              : Colors.grey.shade400,
                          size: 32,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.business_outlined,
                      color: themeController.isDarkMode
                          ? Colors.white30
                          : Colors.grey.shade400,
                      size: 32,
                    ),
            ),

            const SizedBox(height: 16),

            // اسم العلامة التجارية
            Text(
              brand.name,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: themeController.isDarkMode
                    ? Colors.white
                    : Color(0xFF111111),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // عدد المنتجات
            Text(
              '${brand.productCount ?? 0} منتج',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: themeController.isDarkMode
                    ? Colors.white60
                    : Colors.grey.shade600,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            // أزرار الإجراءات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // زر التعديل
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    brandController.showEditForm(brand);
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('تعديل'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                // زر الحذف
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    _showDeleteConfirmation(
                        themeController, brandController, brand, Get.context!);
                  },
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('حذف'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF44336),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _showDeleteConfirmation(ThemeController themeController,
      BrandController brandController, BrandModel brand, BuildContext context) {
    // التحقق من أن الـ widget ما زال محملاً
    if (!context.mounted) return;

    Get.dialog(
      AlertDialog(
        backgroundColor:
            themeController.isDarkMode ? const Color(0xFF222222) : Colors.white,
        title: Text(
          'تأكيد الحذف',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            color:
                themeController.isDarkMode ? Colors.white : Color(0xFF111111),
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف العلامة التجارية "${brand.name}"؟',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            color:
                themeController.isDarkMode ? Colors.white70 : Color(0xFF222222),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: themeController.isDarkMode
                    ? Colors.white60
                    : Colors.grey.shade600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              brandController.deleteBrand(brand.id);
            },
            child: const Text(
              'حذف',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: Color(0xFFF44336),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
