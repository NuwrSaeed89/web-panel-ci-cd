import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/banner_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MobileBannersWidget extends StatelessWidget {
  const MobileBannersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(
      builder: (bannerController) {
        final themeController = Get.find<ThemeController>();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'البنرات',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // سلايدر البنرات
              Obx(() {
                if (bannerController.isLoading) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (bannerController.banners.isEmpty) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: themeController.isDarkMode
                                ? Colors.white54
                                : Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'لا توجد بنرات',
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
                    ),
                  );
                }

                // إنشاء قائمة بصور البنرات
                final List<String> bannerImages = bannerController.banners
                    .map((b) => b.image)
                    .where((image) => image.isNotEmpty)
                    .toList();

                if (bannerImages.isEmpty) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'لا توجد صور للبنرات',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 16,
                          color: themeController.isDarkMode
                              ? Colors.white70
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    // السلايدر
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayCurve: Curves.easeInOut,
                        viewportFraction: 1.0,
                        height: 200,
                        enableInfiniteScroll: bannerImages.length > 1,
                        onPageChanged: (index, reason) {
                          // يمكن إضافة منطق إضافي هنا عند تغيير الصفحة
                        },
                      ),
                      items: bannerImages.map((imageUrl) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: themeController.isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: themeController.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: themeController.isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: themeController.isDarkMode
                                            ? Colors.white54
                                            : Colors.grey,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'فشل في تحميل الصورة',
                                        style: TextStyle(
                                          fontFamily: 'IBM Plex Sans Arabic',
                                          fontSize: 14,
                                          color: themeController.isDarkMode
                                              ? Colors.white70
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // مؤشرات الصفحات
                    if (bannerImages.length > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          bannerImages.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeController.isDarkMode
                                  ? Colors.white54
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
