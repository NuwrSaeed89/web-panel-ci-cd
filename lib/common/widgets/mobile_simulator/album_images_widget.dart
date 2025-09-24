import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/gallery_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumImagesWidget extends StatelessWidget {
  final String albumId;
  final String albumName;

  const AlbumImagesWidget({
    super.key,
    required this.albumId,
    required this.albumName,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor:
            themeController.isDarkMode ? Colors.black : Colors.white,
        foregroundColor:
            themeController.isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
        title: Text(
          albumName,
          style: const TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: Get.back,
        ),
      ),
      body: GetBuilder<GalleryController>(
        builder: (galleryController) {
          return Obx(() {
            if (galleryController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // تصفية الصور حسب الألبوم المحدد
            final albumImages = galleryController.galleryImages
                .where((image) => image.albumId == albumId)
                .toList();

            if (albumImages.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 64,
                      color: themeController.isDarkMode
                          ? Colors.white54
                          : Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'noImages'.tr,
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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // معلومات الألبوم
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode
                          ? Colors.grey.shade900
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: themeController.isDarkMode
                            ? Colors.white12
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          albumName,
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${albumImages.length} ${'images'.tr}',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 14,
                            color: themeController.isDarkMode
                                ? Colors.white70
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // قائمة الصور
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: albumImages.length,
                    itemBuilder: (context, index) {
                      final image = albumImages[index];
                      return GestureDetector(
                        onTap: () {
                          // يمكن إضافة تفاعل إضافي هنا
                        },
                        child: Container(
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
                              imageUrl: image.image,
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
                                        size: 32,
                                        color: themeController.isDarkMode
                                            ? Colors.white54
                                            : Colors.grey,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'imageLoadError'.tr,
                                        style: TextStyle(
                                          fontFamily: 'IBM Plex Sans Arabic',
                                          fontSize: 12,
                                          color: themeController.isDarkMode
                                              ? Colors.white70
                                              : Colors.grey,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
