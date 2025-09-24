import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/gallery_controller.dart';
import 'package:brother_admin_panel/localization/language_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:brother_admin_panel/common/widgets/mobile_simulator/album_images_widget.dart';

class MobileGalleryWidget extends StatelessWidget {
  const MobileGalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GalleryController>(
      builder: (galleryController) {
        final themeController = Get.find<ThemeController>();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'albums'.tr,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // قائمة الألبومات
              Obx(() {
                if (galleryController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (galleryController.galleryImages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_album_outlined,
                          size: 64,
                          color: themeController.isDarkMode
                              ? Colors.white54
                              : Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'noAlbums'.tr,
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

                return SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: galleryController.galleryImages.length,
                    itemBuilder: (_, index) {
                      final galleryItem =
                          galleryController.galleryImages[index];
                      return GestureDetector(
                        onTap: () {
                          // يمكن إضافة تفاعل هنا
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // صورة الألبوم
                              GestureDetector(
                                onTap: () {
                                  // يمكن إضافة تفاعل هنا
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: galleryItem.image,
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
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: themeController.isDarkMode
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade200,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                size: 48,
                                                color:
                                                    themeController.isDarkMode
                                                        ? Colors.white54
                                                        : Colors.grey,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'imageLoadError'.tr,
                                                style: TextStyle(
                                                  fontFamily:
                                                      'IBM Plex Sans Arabic',
                                                  fontSize: 14,
                                                  color:
                                                      themeController.isDarkMode
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
                                ),
                              ),

                              const SizedBox(height: 12),

                              // عنوان الألبوم
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _getDisplayName(galleryItem, index),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'IBM Plex Sans Arabic',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: themeController.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _openAlbumImages(galleryItem);
                                    },
                                    child: Text(
                                      'viewAll'.tr,
                                      style: TextStyle(
                                        fontFamily: 'IBM Plex Sans Arabic',
                                        fontSize: 14,
                                        color: themeController.isDarkMode
                                            ? Colors.blue
                                            : Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // وصف الألبوم (إذا كان متوفراً)
                              // if (galleryItem.arabicDescription?.isNotEmpty ==
                              //         true ||
                              //     galleryItem.description?.isNotEmpty == true)
                              //   Padding(
                              //     padding: const EdgeInsets.only(top: 8),
                              //     child: Text(
                              //       _getDisplayDescription(galleryItem),
                              //       textAlign: TextAlign.right,
                              //       style: TextStyle(
                              //         fontFamily: 'IBM Plex Sans Arabic',
                              //         fontSize: 14,
                              //         color: themeController.isDarkMode
                              //             ? Colors.white70
                              //             : Colors.grey.shade600,
                              //       ),
                              //       maxLines: 2,
                              //       overflow: TextOverflow.ellipsis,
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /// الحصول على الاسم المعروض حسب اللغة الحالية
  String _getDisplayName(dynamic galleryItem, int index) {
    final languageController = Get.find<LanguageController>();

    if (languageController.isArabic) {
      // إذا كانت اللغة عربية، اعرض الاسم العربي أولاً
      if (galleryItem.arabicName?.isNotEmpty == true) {
        return galleryItem.arabicName!;
      } else if (galleryItem.name?.isNotEmpty == true) {
        return galleryItem.name!;
      } else {
        return 'صورة ${index + 1}';
      }
    } else {
      // إذا كانت اللغة إنجليزية، اعرض الاسم الإنجليزي أولاً
      if (galleryItem.name?.isNotEmpty == true) {
        return galleryItem.name!;
      } else if (galleryItem.arabicName?.isNotEmpty == true) {
        return galleryItem.arabicName!;
      } else {
        return 'Image ${index + 1}';
      }
    }
  }

  /// فتح صفحة صور الألبوم
  void _openAlbumImages(dynamic galleryItem) {
    final languageController = Get.find<LanguageController>();

    // الحصول على اسم الألبوم حسب اللغة الحالية
    String albumName;
    if (languageController.isArabic) {
      albumName = galleryItem.arabicName?.isNotEmpty == true
          ? galleryItem.arabicName!
          : galleryItem.name?.isNotEmpty == true
              ? galleryItem.name!
              : 'ألبوم';
    } else {
      albumName = galleryItem.name?.isNotEmpty == true
          ? galleryItem.name!
          : galleryItem.arabicName?.isNotEmpty == true
              ? galleryItem.arabicName!
              : 'Album';
    }

    // الانتقال إلى صفحة صور الألبوم
    Get.to(
      () => AlbumImagesWidget(
        albumId: galleryItem.albumId,
        albumName: albumName,
      ),
    );
  }
}
