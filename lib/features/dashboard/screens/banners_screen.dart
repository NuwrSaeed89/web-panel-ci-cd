import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/banner_controller.dart';
import 'package:brother_admin_panel/data/models/banner_model.dart';
import 'dart:convert'; // Added for base64Decode

class BannersScreen extends StatelessWidget {
  const BannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;

        return Container(
          color: isDark ? const Color(0xFF1a1a2e) : const Color(0xFFf5f5f5),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // color: isDark ? const Color(0xFF16213e) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade200,
                    ),
                  ),
                  child: GetBuilder<BannerController>(
                    builder: (controller) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final bool isWideScreen = constraints.maxWidth > 600;

                          return isWideScreen
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'bannersManagement'.tr,
                                        style: TTextStyles.heading2.copyWith(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Get.find<BannerController>()
                                            .showAddForm();
                                      },
                                      icon: const Icon(Icons.add),
                                      label: Text('addBanner'.tr),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF0055ff),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'إدارة البنرات',
                                            style:
                                                TTextStyles.heading2.copyWith(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Get.find<BannerController>()
                                                .showAddForm();
                                          },
                                          icon: const Icon(Icons.add),
                                          label: Text('addBanner'.tr),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF0055ff),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildSearchBar(controller, isDark),
                                  ],
                                );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Content
                GetBuilder<BannerController>(
                  builder: (bannerController) {
                    if (bannerController.isLoading) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          // color:
                          //     isDark ? const Color(0xFF16213e) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isDark ? Colors.white12 : Colors.grey.shade200,
                          ),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0055ff),
                          ),
                        ),
                      );
                    }

                    if (bannerController.isFormMode) {
                      return _buildBannerForm(bannerController, isDark);
                    }

                    return _buildBannersList(bannerController, isDark);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBannersList(BannerController controller, bool isDark) {
    if (controller.banners.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1a1a2e) : const Color(0xFFf5f5f5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library,
                size: 80,
                color: isDark ? Colors.white54 : Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'noBanners'.tr,
                style: TTextStyles.heading3.copyWith(
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'startByAddingBanner'.tr,
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

    return Container(
      decoration: BoxDecoration(
        //  color: isDark ? const Color(0xFF16213e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideScreen = constraints.maxWidth > 600;

          return Column(
            children: [
              // Search and filters (only for wide screens)
              if (isWideScreen)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildSearchBar(controller, isDark),
                ),

              // Banners grid
              Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate responsive cross axis count based on screen width
                    final double screenWidth = constraints.maxWidth;
                    int crossAxisCount;

                    if (screenWidth > 1400) {
                      crossAxisCount = 5; // Extra large screens
                    } else if (screenWidth > 1200) {
                      crossAxisCount = 4; // Large screens
                    } else if (screenWidth > 900) {
                      crossAxisCount = 3; // Medium screens
                    } else if (screenWidth > 600) {
                      crossAxisCount = 2; // Small screens
                    } else {
                      crossAxisCount = 1; // Very small screens
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2, // تحسين نسبة العرض إلى الارتفاع
                      ),
                      itemCount: controller.filteredBanners.length,
                      itemBuilder: (context, index) {
                        final banner = controller.filteredBanners[index];
                        return _buildBannerCard(banner, controller, isDark);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BannerController controller, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 600;

        return isWideScreen
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: controller.searchBanners,
                      decoration: InputDecoration(
                        hintText: 'searchInBanners'.tr,
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
                            ? const Color(0xFF0f3460)
                            : Colors.grey.shade50,
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
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
                    onChanged: controller.searchBanners,
                    decoration: InputDecoration(
                      hintText: 'searchInBanners'.tr,
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
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF0055ff)),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF0f3460)
                          : Colors.grey.shade50,
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
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
    );
  }

  Widget _buildBannerCard(
      BannerModel banner, BannerController controller, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        // color: isDark ? const Color(0xFF16213e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Banner image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: _getBannerImageProvider(banner),
                  fit: BoxFit.cover, // تغطية كاملة للصورة
                  alignment: Alignment.center, // توسيط الصورة
                ),
              ),
              child: Stack(
                children: [
                  // Active status indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: banner.active ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        banner.active ? 'active'.tr : 'inactive'.tr,
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

          // Banner info and actions
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.targetScreen,
                  style: TTextStyles.bodyMedium.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
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
                        onPressed: () => controller.showEditForm(banner),
                        icon: const Icon(Icons.edit, size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IconButton(
                        onPressed: () =>
                            controller.toggleActiveStatus(banner.id),
                        icon: Icon(
                          banner.active
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 18,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: banner.active
                              ? Colors.orange.shade100
                              : Colors.green.shade100,
                          foregroundColor: banner.active
                              ? Colors.orange.shade700
                              : Colors.green.shade700,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: IconButton(
                        onPressed: () => _showDeleteDialog(controller, banner),
                        icon: const Icon(Icons.delete, size: 18),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
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

  Widget _buildBannerForm(BannerController controller, bool isDark) {
    final targetScreenController = TextEditingController(
      text: controller.selectedBanner?.targetScreen ?? '',
    );
    final activeController = controller.selectedBanner?.active ?? true;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        //  color: isDark ? const Color(0xFF16213e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Make form responsive based on screen width
            final bool isWideScreen = constraints.maxWidth > 800;

            return Column(
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
                      controller.isEditMode
                          ? 'تعديل البانر'
                          : 'إضافة بانر جديد',
                      style: TTextStyles.heading3.copyWith(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: controller.hideForm,
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Image selection
                Text(
                  'bannerImage'.tr,
                  style: TTextStyles.bodyLarge.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                _buildImageSelector(controller, isDark),
                const SizedBox(height: 24),

                // Target screen input
                Text(
                  'targetScreen'.tr,
                  style: TTextStyles.bodyLarge.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: targetScreenController,
                  decoration: InputDecoration(
                    hintText: 'targetScreenHint'.tr,
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF0055ff)),
                    ),
                    filled: true,
                    fillColor:
                        isDark ? const Color(0xFF0f3460) : Colors.grey.shade50,
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Active status
                Row(
                  children: [
                    Checkbox(
                      value: activeController,
                      onChanged: (value) {
                        // Handle active status change
                      },
                      activeColor: const Color(0xFF0055ff),
                    ),
                    Text(
                      'active'.tr,
                      style: TTextStyles.bodyMedium.copyWith(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Action buttons
                if (isWideScreen)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () async {
                                  final banner = BannerModel(
                                    id: controller.selectedBanner?.id ?? '',
                                    image:
                                        controller.selectedBanner?.image ?? '',
                                    targetScreen:
                                        targetScreenController.text.trim(),
                                    active: activeController,
                                  );

                                  if (controller.isEditMode) {
                                    await controller.updateBanner(banner);
                                  } else {
                                    await controller.createBanner(banner);
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  controller.isEditMode
                                      ? 'update'.tr
                                      : 'create'.tr,
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
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'cancel'.tr,
                            style: TTextStyles.bodyLarge.copyWith(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () async {
                                  final banner = BannerModel(
                                    id: controller.selectedBanner?.id ?? '',
                                    image:
                                        controller.selectedBanner?.image ?? '',
                                    targetScreen:
                                        targetScreenController.text.trim(),
                                    active: activeController,
                                  );

                                  if (controller.isEditMode) {
                                    await controller.updateBanner(banner);
                                  } else {
                                    await controller.createBanner(banner);
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  controller.isEditMode
                                      ? 'update'.tr
                                      : 'create'.tr,
                                  style: TTextStyles.bodyLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: controller.hideForm,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'cancel'.tr,
                            style: TTextStyles.bodyLarge.copyWith(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSelector(BannerController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0f3460) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          // Current image or selected image
          GetBuilder<BannerController>(
            builder: (bannerController) {
              // Show uploading indicator
              if (bannerController.isUploadingImage) {
                return Container(
                  height: 250, // زيادة الارتفاع لعرض أفضل
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
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
                        'uploadingBannerImage'.tr,
                        style: TTextStyles.bodyMedium.copyWith(
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show uploaded URL image
              if (bannerController.uploadedImageUrl != null) {
                return Container(
                  height: 250, // زيادة الارتفاع لعرض أفضل
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(bannerController.uploadedImageUrl!),
                      fit: BoxFit.cover, // تغطية كاملة
                      alignment: Alignment.center, // توسيط الصورة
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: bannerController.removeSelectedImage,
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
              if (bannerController.selectedImageBase64 != null ||
                  (bannerController.selectedBanner?.image.isNotEmpty == true)) {
                return Container(
                  height: 250, // زيادة الارتفاع لعرض أفضل
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: bannerController.selectedImageBase64 != null
                          ? MemoryImage(base64Decode(
                              bannerController.selectedImageBase64!))
                          : (bannerController.selectedBanner?.image
                                          .startsWith('http') ==
                                      true
                                  ? NetworkImage(
                                      bannerController.selectedBanner!.image)
                                  : MemoryImage(base64Decode(
                                      bannerController.selectedBanner!.image)))
                              as ImageProvider,
                      fit: BoxFit.cover, // تغطية كاملة
                      alignment: Alignment.center, // توسيط الصورة
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: bannerController.removeSelectedImage,
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
                  height: 250, // زيادة الارتفاع لعرض أفضل
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
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
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
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
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
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

  void _showDeleteDialog(BannerController controller, BannerModel banner) {
    Get.dialog(
      AlertDialog(
        title: Text('confirmDeleteBanner'.tr),
        content: Text('confirmDeleteBannerMessage'
            .tr
            .replaceAll('{title}', banner.targetScreen)),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteBanner(banner.id);
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

  // Helper method to get the appropriate ImageProvider for banner cards
  ImageProvider _getBannerImageProvider(BannerModel banner) {
    if (banner.image.startsWith('http')) {
      return NetworkImage(
        banner.image,
        // إضافة خيارات لتحسين جودة التحميل
        headers: const {
          'Cache-Control': 'max-age=31536000', // تخزين مؤقت لمدة سنة
        },
      );
    } else {
      try {
        return MemoryImage(base64Decode(banner.image));
      } catch (e) {
        // If base64 decode fails, return placeholder
        return const AssetImage('assets/images/placeholder.png');
      }
    }
  }
}
