import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/album_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/gallery_controller.dart';
import 'package:brother_admin_panel/data/models/album_model.dart';
import 'package:brother_admin_panel/data/models/gallery_model.dart';
import 'dart:convert';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor:
                isDark ? const Color(0xFF0a0a0a) : const Color(0xFFfafafa),
            appBar: AppBar(
              backgroundColor: isDark ? const Color(0xFF111111) : Colors.white,
              foregroundColor: isDark ? Colors.white : Color(0xFF111111),
              toolbarHeight: 0,
              elevation: 0,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF0055ff),
                labelColor: const Color(0xFF0055ff),
                unselectedLabelColor: isDark ? Colors.white70 : Colors.black54,
                labelStyle: TTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: TTextStyles.bodyMedium,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.photo_library, size: 20),
                    iconMargin: EdgeInsets.zero,
                    text: 'images'.tr,
                  ),
                  Tab(
                    icon: const Icon(Icons.album, size: 20),
                    iconMargin: EdgeInsets.zero,
                    text: 'albums'.tr,
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                // Images Tab
                _buildImagesTab(isDark),
                // Albums Tab
                _buildAlbumsTab(isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagesTab(bool isDark) {
    return GetBuilder<GalleryController>(
      builder: (galleryController) {
        if (galleryController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0055ff),
            ),
          );
        }

        if (galleryController.isFormMode) {
          return _buildGalleryForm(galleryController, isDark);
        }

        return _buildImagesList(galleryController, isDark);
      },
    );
  }

  Widget _buildImagesList(GalleryController controller, bool isDark) {
    if (controller.galleryImages.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111111) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF222222) : Colors.grey.shade200,
          ),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 80,
                color: isDark ? Colors.white54 : Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'noImages'.tr,
                style: TTextStyles.heading3.copyWith(
                  color: isDark ? Colors.white : Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'startByAddingImage'.tr,
                style: TTextStyles.bodyMedium.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Images Tab Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111111) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF222222) : const Color(0xFFe0e0e0),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.photo_library,
                  color: Color(0xFF0055ff),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'imageManagement'.tr,
                  style: TTextStyles.heading4.copyWith(
                    color: isDark ? Colors.white : Color(0xFF111111),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.showAddForm();
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: Text('addImage'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0055ff),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search bar
          _buildGallerySearchBar(controller, isDark),
          const SizedBox(height: 16),

          // Images grid
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate responsive cross axis count based on screen width
              final double screenWidth = constraints.maxWidth;
              int crossAxisCount;

              if (screenWidth > 1400) {
                crossAxisCount = 4; // Extra large screens
              } else if (screenWidth > 1000) {
                crossAxisCount = 3; // Large screens
              } else if (screenWidth > 700) {
                crossAxisCount = 2; // Medium screens
              } else {
                crossAxisCount = 1; // Small screens
              }

              return GridView.builder(
                shrinkWrap: true, // مهم للسكرول
                physics:
                    const NeverScrollableScrollPhysics(), // منع السكرول المزدوج
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0, // تغيير النسبة لتكون مربعة
                ),
                itemCount: controller.filteredImages.length,
                itemBuilder: (context, index) {
                  final image = controller.filteredImages[index];
                  return _buildImageCard(image, controller, isDark);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySearchBar(GalleryController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideScreen = constraints.maxWidth > 600;

          return isWideScreen
              ? Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: controller.searchImages,
                        decoration: InputDecoration(
                          hintText: 'searchInImages'.tr,
                          hintStyle: TextStyle(
                            color:
                                isDark ? Colors.white54 : Colors.grey.shade500,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color:
                                isDark ? Colors.white54 : Colors.grey.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFF0055ff)),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF222222)
                              : const Color(0xFFf8f8f8),
                        ),
                        style: TextStyle(
                          color: isDark ? Colors.white : Color(0xFF111111),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: controller.refreshData,
                      icon: const Icon(Icons.refresh),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF0055ff),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    TextField(
                      onChanged: controller.searchImages,
                      decoration: InputDecoration(
                        hintText: 'searchInImages'.tr,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color:
                                isDark ? Colors.white24 : Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color:
                                isDark ? Colors.white24 : Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFF0055ff)),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF222222)
                            : const Color(0xFFf8f8f8),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: controller.refreshData,
                        icon: const Icon(Icons.refresh),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF0055ff),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildImageCard(
      GalleryModel image, GalleryController controller, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF222222) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.transparent,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                color: isDark
                    ? Colors.grey.shade800
                    : Colors.grey.shade100, // خلفية للصورة
                image: DecorationImage(
                  image: _getGalleryImageProvider(image),
                  fit: BoxFit
                      .contain, // تغيير من cover إلى contain لعرض الصورة كاملة
                ),
              ),
              child: Stack(
                children: [
                  // Feature status indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: image.isFeature ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        image.isFeature ? 'featured'.tr : 'normal'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Image info and actions
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  image.arabicName?.isNotEmpty == true
                      ? image.arabicName!
                      : (image.name ?? 'بدون اسم'),
                  style: TTextStyles.bodyMedium.copyWith(
                    color: isDark ? Colors.white : Color(0xFF111111),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () => controller.showEditForm(image),
                        icon: const Icon(Icons.edit, size: 18),
                        style: IconButton.styleFrom(
                          // backgroundColor: Colors.blue.shade100,
                          foregroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IconButton(
                        onPressed: () =>
                            controller.toggleImageFeatureStatus(image.id),
                        icon: Icon(
                          image.isFeature ? Icons.star : Icons.star_border,
                          size: 18,
                        ),
                        style: IconButton.styleFrom(
                          // backgroundColor: image.isFeature
                          //     ? Colors.orange.shade100
                          //     : Colors.grey.shade100,
                          foregroundColor: image.isFeature
                              ? Colors.orange.shade700
                              : Color(0xFF222222),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IconButton(
                        onPressed: () =>
                            _showDeleteImageDialog(controller, image),
                        icon: const Icon(Icons.delete, size: 18),
                        style: IconButton.styleFrom(
                          // backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red.shade700,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
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

  // Helper method to get the appropriate ImageProvider for gallery images
  ImageProvider _getGalleryImageProvider(GalleryModel image) {
    if (image.image.startsWith('http')) {
      return NetworkImage(image.image);
    } else {
      try {
        return MemoryImage(base64Decode(image.image));
      } catch (e) {
        // If base64 decode fails, return placeholder
        return const AssetImage('assets/images/placeholder.png');
      }
    }
  }

  void _showDeleteImageDialog(
      GalleryController controller, GalleryModel image) {
    Get.dialog(
      AlertDialog(
        title: Text('confirmDelete'.tr),
        content: Text('confirmDeleteImage'.tr.replaceAll(
            '{name}',
            image.arabicName?.isNotEmpty == true
                ? image.arabicName!
                : (image.name ?? 'بدون اسم'))),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteGalleryImage(image.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumsTab(bool isDark) {
    return GetBuilder<AlbumController>(
      builder: (albumController) {
        if (albumController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0055ff),
            ),
          );
        }

        if (albumController.isFormMode) {
          return _buildAlbumForm(albumController, isDark);
        }

        return _buildAlbumsList(albumController, isDark);
      },
    );
  }

  Widget _buildAlbumsList(AlbumController controller, bool isDark) {
    if (controller.albums.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111111) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF222222) : Colors.grey.shade200,
          ),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.album_outlined,
                size: 80,
                color: isDark ? Colors.white54 : Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'noAlbums'.tr,
                style: TTextStyles.heading3.copyWith(
                  color: isDark ? Colors.white : Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'startByAddingAlbum'.tr,
                style: TTextStyles.bodyMedium.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Albums Tab Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111111) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF222222) : const Color(0xFFe0e0e0),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.album,
                  color: Color(0xFF0055ff),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'albumManagement'.tr,
                  style: TTextStyles.heading4.copyWith(
                    color: isDark ? Colors.white : Color(0xFF111111),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.showAddForm();
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: Text('addAlbum'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0055ff),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search bar
          _buildSearchBar(controller, isDark),
          const SizedBox(height: 16),

          // Albums grid
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate responsive cross axis count based on screen width
              final double screenWidth = constraints.maxWidth;
              int crossAxisCount;

              if (screenWidth > 1200) {
                crossAxisCount = 4; // Large screens
              } else if (screenWidth > 900) {
                crossAxisCount = 3; // Medium screens
              } else if (screenWidth > 600) {
                crossAxisCount = 2; // Small screens
              } else {
                crossAxisCount = 1; // Very small screens
              }

              return GridView.builder(
                shrinkWrap: true, // مهم للسكرول
                physics:
                    const NeverScrollableScrollPhysics(), // منع السكرول المزدوج
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 16 / 14,
                ),
                itemCount: controller.filteredAlbums.length,
                itemBuilder: (context, index) {
                  final album = controller.filteredAlbums[index];
                  return _buildAlbumCard(album, controller, isDark);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AlbumController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideScreen = constraints.maxWidth > 600;

          return isWideScreen
              ? Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: controller.searchAlbums,
                        decoration: InputDecoration(
                          hintText: 'searchInAlbums'.tr,
                          hintStyle: TextStyle(
                            color:
                                isDark ? Colors.white54 : Colors.grey.shade500,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color:
                                isDark ? Colors.white54 : Colors.grey.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFF0055ff)),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF222222)
                              : const Color(0xFFf8f8f8),
                        ),
                        style: TextStyle(
                          color: isDark ? Colors.white : Color(0xFF111111),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: controller.refreshData,
                      icon: const Icon(Icons.refresh),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF0055ff),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    TextField(
                      onChanged: controller.searchAlbums,
                      decoration: InputDecoration(
                        hintText: 'searchInAlbums'.tr,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color:
                                isDark ? Colors.white24 : Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color:
                                isDark ? Colors.white24 : Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFF0055ff)),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF222222)
                            : const Color(0xFFf8f8f8),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: controller.refreshData,
                        icon: const Icon(Icons.refresh),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF0055ff),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildAlbumCard(
      AlbumModel album, AlbumController controller, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF222222) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.transparent,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Album image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: _getAlbumImageProvider(album),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Feature status indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: album.isFeature ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        album.isFeature ? 'featured'.tr : 'normal'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Album info and actions
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.arabicName.isNotEmpty ? album.arabicName : album.name,
                  style: TTextStyles.bodyMedium.copyWith(
                    color: isDark ? Colors.white : Color(0xFF111111),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () => controller.showEditForm(album),
                        icon: const Icon(Icons.edit, size: 18),
                        style: IconButton.styleFrom(
                          //   backgroundColor: Colors.blue.shade100,
                          foregroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IconButton(
                        onPressed: () =>
                            controller.toggleFeatureStatus(album.id),
                        icon: Icon(
                          album.isFeature ? Icons.star : Icons.star_border,
                          size: 18,
                        ),
                        style: IconButton.styleFrom(
                          // backgroundColor: album.isFeature
                          //     ? Colors.orange.shade100
                          //     : Colors.grey.shade100,
                          // foregroundColor: album.isFeature
                          //     ? Colors.orange.shade700
                          //     : Color(0xFF222222),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IconButton(
                        onPressed: () => _showDeleteDialog(controller, album),
                        icon: const Icon(Icons.delete, size: 18),
                        style: IconButton.styleFrom(
                          // backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red.shade700,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
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

  // Helper method to get the appropriate ImageProvider for album cards
  ImageProvider _getAlbumImageProvider(AlbumModel album) {
    if (album.image == null || album.image!.isEmpty) {
      return const AssetImage('assets/images/placeholder.png');
    }

    if (album.image!.startsWith('http')) {
      return NetworkImage(album.image!);
    } else {
      try {
        return MemoryImage(base64Decode(album.image!));
      } catch (e) {
        // If base64 decode fails, return placeholder
        return const AssetImage('assets/images/placeholder.png');
      }
    }
  }

  void _showDeleteDialog(AlbumController controller, AlbumModel album) {
    Get.dialog(
      AlertDialog(
        title: Text('confirmDelete'.tr),
        content: Text('confirmDeleteAlbum'.tr.replaceAll('{name}',
            album.arabicName.isNotEmpty ? album.arabicName : album.name)),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteAlbum(album.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumForm(AlbumController controller, bool isDark) {
    final nameController = TextEditingController(
      text: controller.selectedAlbum?.name ?? '',
    );
    final arabicNameController = TextEditingController(
      text: controller.selectedAlbum?.arabicName ?? '',
    );
    final isFeatureController =
        (controller.selectedAlbum?.isFeature ?? false).obs;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form header
            Row(
              children: [
                Icon(
                  controller.isEditMode ? Icons.edit : Icons.add,
                  color: const Color(0xFF0055ff),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  controller.isEditMode ? 'editAlbum'.tr : 'addNewAlbum'.tr,
                  style: TTextStyles.heading3.copyWith(
                    color: isDark ? Colors.white : Color(0xFF111111),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: controller.hideForm,
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    // backgroundColor: Colors.grey.shade200,
                    foregroundColor: Color(0xFF222222),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Image selection
            Text(
              'albumImage'.tr,
              style: TTextStyles.bodyLarge.copyWith(
                color: isDark ? Colors.white : Color(0xFF111111),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            _buildImageSelector(controller, isDark),
            const SizedBox(height: 24),

            // Album name input
            Text(
              'albumNameInEnglish'.tr,
              style: TTextStyles.bodyLarge.copyWith(
                color: isDark ? Colors.white : Color(0xFF111111),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'مثال: Wedding Photos, Nature Gallery...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF0055ff)),
                ),
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF222222) : Colors.grey.shade50,
              ),
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 24),

            // Arabic name input
            Text(
              'albumNameInArabic'.tr,
              style: TTextStyles.bodyLarge.copyWith(
                color: isDark ? Colors.white : Color(0xFF111111),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: arabicNameController,
              decoration: InputDecoration(
                hintText: 'مثال: صور الزفاف، معرض الطبيعة...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF0055ff)),
                ),
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF222222) : Colors.grey.shade50,
              ),
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 24),

            // Feature status
            Row(
              children: [
                Obx(() => Checkbox(
                      value: isFeatureController.value,
                      onChanged: (value) {
                        isFeatureController.value = value ?? false;
                      },
                      activeColor: const Color(0xFF0055ff),
                    )),
                Text(
                  'featuredAlbum'.tr,
                  style: TTextStyles.bodyMedium.copyWith(
                    color: isDark ? Colors.white : Color(0xFF111111),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : () async {
                            final album = AlbumModel(
                              id: controller.selectedAlbum?.id ?? '',
                              name: nameController.text.trim(),
                              arabicName: arabicNameController.text.trim(),
                              image: controller.selectedAlbum?.image,
                              isFeature: isFeatureController.value,
                            );

                            if (controller.isEditMode) {
                              await controller.updateAlbum(album);
                            } else {
                              await controller.createAlbum(album);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0055ff),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            controller.isEditMode ? 'update'.tr : 'create'.tr,
                            style: TTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.hideForm,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color:
                            isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'cancel'.tr,
                      style: TTextStyles.bodyLarge.copyWith(
                        color: isDark ? Colors.white : Color(0xFF111111),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSelector(AlbumController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          // Current image or selected image
          GetBuilder<AlbumController>(
            builder: (albumController) {
              // Show uploading indicator
              if (albumController.isUploadingImage) {
                return Container(
                  height: THelperFunctions.screenwidth() * 0.3,
                  width: THelperFunctions.screenwidth(),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF222222)
                        : const Color(0xFFe0e0e0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Color(0xFF0055ff),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'uploadingAlbumImage'.tr,
                        style: TTextStyles.bodyMedium.copyWith(
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show uploaded URL image
              if (albumController.uploadedImageUrl != null) {
                return Container(
                  height: THelperFunctions.screenwidth() * 0.3,
                  width: THelperFunctions.screenwidth(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(albumController.uploadedImageUrl!),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: albumController.removeSelectedImage,
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show existing image (URL or base64)
              if (albumController.selectedImageBase64 != null ||
                  (albumController.selectedAlbum?.image?.isNotEmpty == true)) {
                return Container(
                  height: THelperFunctions.screenwidth() * 0.3,
                  width: THelperFunctions.screenwidth(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: albumController.selectedImageBase64 != null
                          ? MemoryImage(base64Decode(
                              albumController.selectedImageBase64!))
                          : (albumController.selectedAlbum?.image
                                          ?.startsWith('http') ==
                                      true
                                  ? NetworkImage(
                                      albumController.selectedAlbum!.image!)
                                  : MemoryImage(base64Decode(
                                      albumController.selectedAlbum!.image!)))
                              as ImageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: albumController.removeSelectedImage,
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: THelperFunctions.screenwidth() * 0.3,
                  width: THelperFunctions.screenwidth(),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF222222)
                        : const Color(0xFFe0e0e0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 48,
                        color: isDark ? Colors.white54 : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'noImageSelected'.tr,
                        style: TTextStyles.bodyMedium.copyWith(
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 16),

          // Image selection buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.pickImageFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: Text('fromGallery'.tr),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.pickImageFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: Text('fromCamera'.tr),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryForm(GalleryController controller, bool isDark) {
    // استخدام متغيرات محلية لحفظ حالة النموذج
    final nameController = TextEditingController(
      text: controller.selectedImage?.name ?? '',
    );
    final arabicNameController = TextEditingController(
      text: controller.selectedImage?.arabicName ?? '',
    );
    final descriptionController = TextEditingController(
      text: controller.selectedImage?.description ?? '',
    );
    final arabicDescriptionController = TextEditingController(
      text: controller.selectedImage?.arabicDescription ?? '',
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form header
            Row(
              children: [
                Icon(
                  controller.isEditMode ? Icons.edit : Icons.add,
                  color: const Color(0xFF0055ff),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  controller.isEditMode ? 'editImage'.tr : 'addNewImage'.tr,
                  style: TTextStyles.heading3.copyWith(
                    color: isDark ? Colors.white : Color(0xFF111111),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: controller.hideForm,
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Color(0xFF222222),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Image selection
            Text(
              'galleryImage'.tr,
              style: TTextStyles.bodyLarge.copyWith(
                color: isDark ? Colors.white : Color(0xFF111111),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            _buildGalleryImageSelector(controller, isDark),
            const SizedBox(height: 24),

            // Image name input
            Text(
              'imageNameInEnglish'.tr,
              style: TTextStyles.bodyLarge.copyWith(
                color: isDark ? Colors.white : Color(0xFF111111),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'مثال: Wedding Photo, Nature View...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF0055ff)),
                ),
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF222222) : Colors.grey.shade50,
              ),
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 24),

            // Arabic name input
            Text(
              'imageNameInArabic'.tr,
              style: TTextStyles.bodyLarge.copyWith(
                color: isDark ? Colors.white : Color(0xFF111111),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: arabicNameController,
              decoration: InputDecoration(
                hintText: 'مثال: صورة زفاف، منظر طبيعي...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF0055ff)),
                ),
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF222222) : Colors.grey.shade50,
              ),
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 24),

            // Description input
            Text(
              'imageDescriptionInEnglish'.tr,
              style: TTextStyles.bodyLarge.copyWith(
                color: isDark ? Colors.white : Color(0xFF111111),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'وصف تفصيلي للصورة...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF0055ff)),
                ),
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF222222) : Colors.grey.shade50,
              ),
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 24),

            // Arabic description input
            Text(
              'imageDescriptionInArabic'.tr,
              style: TTextStyles.bodyLarge.copyWith(
                color: isDark ? Colors.white : Color(0xFF111111),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: arabicDescriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'وصف تفصيلي للصورة بالعربية...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF0055ff)),
                ),
                filled: true,
                fillColor:
                    isDark ? const Color(0xFF222222) : Colors.grey.shade50,
              ),
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 24),

            // Albums selection
            Text(
              'relatedAlbums'.tr,
              style: TTextStyles.bodyLarge.copyWith(
                color: isDark ? Colors.white : Color(0xFF111111),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildAlbumsSelection(controller, isDark),
            const SizedBox(height: 24),

            // Feature status
            Row(
              children: [
                GetBuilder<GalleryController>(
                  builder: (galleryController) => Checkbox(
                    value: galleryController.isFeature,
                    onChanged: (value) {
                      galleryController.toggleFeatureStatus();
                    },
                    activeColor: const Color(0xFF0055ff),
                  ),
                ),
                Text(
                  'featuredImage'.tr,
                  style: TTextStyles.bodyMedium.copyWith(
                    color: isDark ? Colors.white : Color(0xFF111111),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : () async {
                            if (controller.isEditMode) {
                              await controller.updateGalleryImage(
                                name: nameController.text.trim(),
                                arabicName: arabicNameController.text.trim(),
                                description:
                                    descriptionController.text.trim().isEmpty
                                        ? null
                                        : descriptionController.text.trim(),
                                arabicDescription: arabicDescriptionController
                                        .text
                                        .trim()
                                        .isEmpty
                                    ? null
                                    : arabicDescriptionController.text.trim(),
                              );
                            } else {
                              await controller.createGalleryImage(
                                name: nameController.text.trim(),
                                arabicName: arabicNameController.text.trim(),
                                description:
                                    descriptionController.text.trim().isEmpty
                                        ? null
                                        : descriptionController.text.trim(),
                                arabicDescription: arabicDescriptionController
                                        .text
                                        .trim()
                                        .isEmpty
                                    ? null
                                    : arabicDescriptionController.text.trim(),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0055ff),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            controller.isEditMode ? 'update'.tr : 'create'.tr,
                            style: TTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.hideForm,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color:
                            isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'cancel'.tr,
                      style: TTextStyles.bodyLarge.copyWith(
                        color: isDark ? Colors.white : Color(0xFF111111),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumsSelection(GalleryController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'selectRelatedAlbums'.tr,
            style: TTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          if (controller.albums.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF222222) : const Color(0xFFe0e0e0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'noAlbumsAvailable'.tr,
                  style: TTextStyles.bodyMedium.copyWith(
                    color: isDark ? Colors.white54 : Colors.grey.shade500,
                  ),
                ),
              ),
            )
          else
            GetBuilder<GalleryController>(
              builder: (galleryController) => Column(
                children: galleryController.albums.map((album) {
                  final isSelected =
                      galleryController.selectedAlbums.contains(album.id);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (value) {
                        galleryController.toggleAlbumSelection(album.id);
                      },
                      title: Text(
                        album.arabicName.isNotEmpty
                            ? album.arabicName
                            : album.name,
                        style: TTextStyles.bodyMedium.copyWith(
                          color: isDark ? Colors.white : Color(0xFF111111),
                        ),
                      ),
                      subtitle: album.name != album.arabicName
                          ? Text(
                              album.name,
                              style: TTextStyles.bodySmall.copyWith(
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade600,
                              ),
                            )
                          : null,
                      activeColor: const Color(0xFF0055ff),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGalleryImageSelector(GalleryController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222222) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          // Current image or selected image
          GetBuilder<GalleryController>(
            builder: (galleryController) {
              // Show uploading indicator
              if (galleryController.isUploadingImage) {
                return Container(
                  height: THelperFunctions.screenwidth() * 0.3,
                  width: THelperFunctions.screenwidth(),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF222222)
                        : const Color(0xFFe0e0e0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Color(0xFF0055ff),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'uploadingImage'.tr,
                        style: TTextStyles.bodyMedium.copyWith(
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show uploaded URL image
              if (galleryController.uploadedImageUrl != null) {
                return Container(
                  height: THelperFunctions.screenwidth() * 0.3,
                  width: THelperFunctions.screenwidth(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(galleryController.uploadedImageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: galleryController.removeSelectedImage,
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show existing image (URL or base64)
              if (galleryController.selectedImageBase64 != null ||
                  (galleryController.selectedImage?.image.isNotEmpty == true)) {
                return Container(
                  height: THelperFunctions.screenwidth() * 0.3,
                  width: THelperFunctions.screenwidth(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: galleryController.selectedImageBase64 != null
                          ? MemoryImage(base64Decode(
                              galleryController.selectedImageBase64!))
                          : (galleryController.selectedImage?.image
                                          .startsWith('http') ==
                                      true
                                  ? NetworkImage(
                                      galleryController.selectedImage!.image)
                                  : MemoryImage(base64Decode(
                                      galleryController.selectedImage!.image)))
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: galleryController.removeSelectedImage,
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: THelperFunctions.screenwidth() * 0.3,
                  width: THelperFunctions.screenwidth(),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF222222)
                        : const Color(0xFFe0e0e0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 48,
                        color: isDark ? Colors.white54 : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'noImageSelected'.tr,
                        style: TTextStyles.bodyMedium.copyWith(
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 16),

          // Image selection buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.pickImageFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: Text('fromGallery'.tr),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.pickImageFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: Text('fromCamera'.tr),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.white24 : const Color(0xFFd0d0d0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
