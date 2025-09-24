import 'dart:convert';
import 'dart:io';

import 'package:brother_admin_panel/data/models/category_model.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/category_controller.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/category_form.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/foundation.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GetBuilder<CategoryController>(
        builder: (categoryController) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Title Section
                Container(
                  width: double.infinity,
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bool isMobile = constraints.maxWidth < 600;
                      return Text(
                        'Categories',
                        style: TTextStyles.heading3.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: isMobile ? 20 : 28,
                        ),
                      );
                    },
                  ),
                ),

                // Header with Search and Add Button
                _buildHeaderWithSearch(context, isDark, controller),

                // Content
                if (categoryController.isFormMode)
                  _buildFormView(context, isDark, categoryController)
                else
                  _buildCategoriesList(context, isDark, categoryController),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderWithSearch(
      BuildContext context, bool isDark, CategoryController controller) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            // Mobile: Stack vertically
            return Column(
              children: [
                // Search Bar
                _buildCompactSearchBar(context, isDark, controller),
                const SizedBox(height: 12),
                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: _buildRefreshButton(context, isDark, controller),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildAddButton(context, isDark, controller),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // Desktop: Horizontal layout
            return Row(
              children: [
                // Search Bar - takes available space
                Expanded(
                  child:
                      _buildCompactSearchBarForRow(context, isDark, controller),
                ),
                const SizedBox(width: 16),
                // Refresh Button
                _buildRefreshButton(context, isDark, controller),
                const SizedBox(width: 8),
                // Add Button - fixed width
                _buildAddButton(context, isDark, controller),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCompactSearchBar(
      BuildContext context, bool isDark, CategoryController controller) {
    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        // استخدام AnimatedContainer مع قيود ثابتة
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: categoryController.isSearchExpanded
              ? double.infinity // عرض كامل في الموبايل
              : 52,
          height: 50,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              // Search Icon Button
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  onPressed: () {
                    controller.toggleSearchExpansion();
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      categoryController.isSearchExpanded
                          ? Icons.close
                          : Icons.search,
                      key: ValueKey(categoryController.isSearchExpanded),
                      color: isDark ? Colors.white : Colors.blue.shade600,
                      size: 22,
                    ),
                  ),
                ),
              ),

              // Search TextField
              if (categoryController.isSearchExpanded)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: TextField(
                      onChanged: controller.searchCategories,
                      onSubmitted: (_) {
                        if (controller.searchQuery.isEmpty) {
                          controller.toggleSearchExpansion();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'searchInCategories'.tr,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                      autofocus: true,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),

              // Clear Button (only when there's text)
              if (categoryController.searchQuery.isNotEmpty)
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {
                      controller.clearSearch();
                      if (controller.searchQuery.isEmpty) {
                        controller.toggleSearchExpansion();
                      }
                    },
                    icon: Icon(
                      Icons.clear,
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                      size: 18,
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
      BuildContext context, bool isDark, CategoryController controller) {
    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        // استخدام AnimatedContainer مع قيود ثابتة للـ Row
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: categoryController.isSearchExpanded ? 300 : 50,
          height: 50,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              // Search Icon Button
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  onPressed: () {
                    controller.toggleSearchExpansion();
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      categoryController.isSearchExpanded
                          ? Icons.close
                          : Icons.search,
                      key: ValueKey(categoryController.isSearchExpanded),
                      color: isDark ? Colors.white : Colors.blue.shade600,
                      size: 22,
                    ),
                  ),
                ),
              ),

              // Search TextField
              if (categoryController.isSearchExpanded)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: TextField(
                      onChanged: controller.searchCategories,
                      onSubmitted: (_) {
                        if (controller.searchQuery.isEmpty) {
                          controller.toggleSearchExpansion();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'searchInCategories'.tr,
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                      autofocus: true,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),

              // Clear Button (only when there's text)
              if (categoryController.searchQuery.isNotEmpty)
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {
                      controller.clearSearch();
                      if (controller.searchQuery.isEmpty) {
                        controller.toggleSearchExpansion();
                      }
                    },
                    icon: Icon(
                      Icons.clear,
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRefreshButton(
      BuildContext context, bool isDark, CategoryController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        return SizedBox(
          height: isMobile ? 44 : 50,
          child: ElevatedButton(
            onPressed: () async {
              if (kDebugMode) {
                print('🔄 Refresh button pressed - reloading from Firebase');
              }
              await controller.refreshData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(isMobile ? 8 : 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Icon(
              Icons.refresh,
              size: isMobile ? 18 : 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton(
      BuildContext context, bool isDark, CategoryController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        return Container(
          height: isMobile ? 44 : 50,
          constraints: BoxConstraints(
            minWidth: isMobile ? 100 : 140,
            maxWidth: isMobile ? 200 : 200,
          ),
          child: ElevatedButton.icon(
            onPressed: () => controller.showAddForm(),
            icon: Icon(Icons.add, size: isMobile ? 16 : 20),
            label: Text(
              'Add Category',
              style: TextStyle(
                fontSize: isMobile
                    ? 12
                    : ResponsiveHelper.getResponsiveFontSize(context,
                        mobile: 14),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0055ff),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 8 : 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormView(
      BuildContext context, bool isDark, CategoryController controller) {
    return Container(
      margin: ResponsiveHelper.getResponsiveMargin(context),
      child: CategoryForm(
        category: controller.selectedCategory,
        isEditMode: controller.isEditMode,
      ),
    );
  }

  Widget _buildCategoriesList(
      BuildContext context, bool isDark, CategoryController controller) {
    if (controller.isLoading) {
      return _buildLoadingState(context, isDark);
    }

    if (controller.filteredCategories.isEmpty) {
      return _buildEmptyState(context, isDark, controller);
    }

    return Container(
      margin: ResponsiveHelper.getResponsiveMargin(context),
      child: ResponsiveHelper.responsiveBuilder(
        context: context,
        mobile: _buildMobileGrid(context, isDark, controller),
        tablet: _buildTabletGrid(
            context, isDark, controller), // إضافة تخطيط للـ tablet
        desktop: _buildDesktopGrid(context, isDark, controller),
      ),
    );
  }

  Widget _buildMobileGrid(
      BuildContext context, bool isDark, CategoryController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // عمودين للـ mobile
        childAspectRatio: 0.6, // تقليل النسبة لمنع الـ overflow
        crossAxisSpacing: 12, // مسافة أقل للـ mobile
        mainAxisSpacing: 12, // مسافة أقل للـ mobile
      ),
      itemCount: controller.filteredCategories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(
          context,
          controller.filteredCategories[index],
          isDark,
          controller,
        );
      },
    );
  }

  Widget _buildTabletGrid(
      BuildContext context, bool isDark, CategoryController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 أعمدة للـ tablet
        childAspectRatio: 0.8, // تقليل النسبة لمنع الـ overflow
        crossAxisSpacing: 12, // مسافة أقل للـ tablet
        mainAxisSpacing: 12, // مسافة أقل للـ tablet
      ),
      itemCount: controller.filteredCategories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(
          context,
          controller.filteredCategories[index],
          isDark,
          controller,
        );
      },
    );
  }

  Widget _buildDesktopGrid(
      BuildContext context, bool isDark, CategoryController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // تحديث عدد الأعمدة إلى 6 للـ desktop
        childAspectRatio: 0.7, // تقليل النسبة لمنع الـ overflow
        crossAxisSpacing: 16, // تقليل المسافة بين الأعمدة
        mainAxisSpacing: 16, // تقليل المسافة بين الصفوف
      ),
      itemCount: controller.filteredCategories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(
          context,
          controller.filteredCategories[index],
          isDark,
          controller,
        );
      },
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    CategoryModel category,
    bool isDark,
    CategoryController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          // Image Section - عرض دائري مع خلفية بيضاء
          Expanded(
            flex: 5, // زيادة نسبة الصورة
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16), // مسافة داخلية للصورة
                child: category.image.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white, // خلفية بيضاء
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: _buildCategoryImage(category, isDark),
                        ),
                      )
                    : Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported_outlined,
                                size: 32,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'noImage'.tr,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
          // Content Section - تقليل نسبة المحتوى وإصلاح الـ overflow
          Expanded(
            flex: 5, // تقليل نسبة المحتوى
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8), // تقليل padding أكثر
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // إضافة هذا لمنع الـ overflow
                children: [
                  // Category Names - تقليل حجم الخط أكثر
                  Flexible(
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            mobile: 12,
                            tablet: 12,
                            desktop: 14),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4), // تقليل المسافة أكثر
                  Flexible(
                    child: Text(
                      category.arabicName,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            mobile: 10,
                            tablet: 10,
                            desktop: 12),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4), // تقليل المسافة أكثر

                  // Feature Badge - تقليل الحجم
                  if (category.isFeature)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'featured'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 6,
                                tablet: 8,
                                desktop: 10),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  const Spacer(flex: 1), // تقليل المساحة المرنة

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Feature Badge (إذا لم تكن مميزة)
                      // if (!category.isFeature)
                      //   Flexible(
                      //     child: Container(
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: 6, vertical: 2),
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey.shade400,
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //       child: Text(
                      //         ' ',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize:
                      //               ResponsiveHelper.getResponsiveFontSize(
                      //                   context,
                      //                   mobile: 6,
                      //                   tablet: 8,
                      //                   desktop: 10),
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //     ),
                      //   ),

                      // Action Buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit Button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (kDebugMode) {
                                  print('✏️ Edit button pressed for category:');
                                  print('   - ID: "${category.id}"');
                                  print('   - Name: "${category.name}"');
                                  print(
                                      '   - ID is empty: ${category.id.isEmpty}');
                                  print(
                                      '   - ID length: ${category.id.length}');
                                }

                                if (category.id.isEmpty) {
                                  Get.snackbar(
                                    'error'.tr,
                                    'categoryIdEmptyError'.tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                // إضافة تأخير صغير للتأكد من اكتمال العملية
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  controller.showEditForm(category);
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                size: ResponsiveHelper.getResponsiveIconSize(
                                    context,
                                    mobile: 14,
                                    tablet: 16,
                                    desktop: 18),
                                color: Colors.blue,
                              ),
                              padding: const EdgeInsets.all(6),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ),

                          const SizedBox(width: 6),

                          // Delete Button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (kDebugMode) {
                                  print(
                                      '🗑️ Delete button pressed for category:');
                                  print('   - ID: "${category.id}"');
                                  print('   - Name: "${category.name}"');
                                  print(
                                      '   - ID is empty: ${category.id.isEmpty}');
                                  print(
                                      '   - ID length: ${category.id.length}');
                                }

                                if (category.id.isEmpty) {
                                  Get.snackbar(
                                    'error'.tr,
                                    'categoryIdEmptyDeleteError'.tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                // إضافة تأخير صغير للتأكد من اكتمال العملية
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  _showDeleteDialog(category, controller);
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                size: ResponsiveHelper.getResponsiveIconSize(
                                    context,
                                    mobile: 14,
                                    tablet: 16,
                                    desktop: 18),
                                color: Colors.red,
                              ),
                              padding: const EdgeInsets.all(6),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: isDark ? Colors.white : Colors.blue,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading categories...',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: ResponsiveHelper.getResponsiveFontSize(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, bool isDark, CategoryController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 80,
            color: isDark ? Colors.white54 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            controller.searchQuery.isNotEmpty
                ? 'No categories found'
                : 'No categories yet',
            style: TTextStyles.heading3.copyWith(
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.searchQuery.isNotEmpty
                ? 'Try adjusting your search terms'
                : 'Create your first category to get started',
            style: TTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // إضافة معلومات تصحيح
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  'Debug Info:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Categories: ${controller.categories.length}',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  'Filtered: ${controller.filteredCategories.length}',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  'Loading: ${controller.isLoading}',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  'Form Mode: ${controller.isFormMode}',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (controller.searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.showAddForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Category'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteDialog(
      CategoryModel category, CategoryController controller) {
    if (kDebugMode) {
      print('🗑️ Showing delete dialog for category:');
      print('   - ID: "${category.id}"');
      print('   - Name: "${category.name}"');
      print('   - ID is empty: ${category.id.isEmpty}');
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete "${category.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (kDebugMode) {
                print(
                    '🗑️ Confirming delete for category ID: "${category.id}"');
              }
              Get.back();

              // انتظار اكتمال العملية
              final result = await controller.deleteCategory(category.id);
              if (kDebugMode) {
                print('🗑️ Delete operation result: $result');
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// بناء صورة الفئة مع دعم base64 و network URLs
  Widget _buildCategoryImage(CategoryModel category, bool isDark) {
    if (category.image.isEmpty) {
      return Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                size: 32,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                'noImage'.tr,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // فحص إذا كانت الصورة base64 أم URL
    if (category.image.startsWith('data:image')) {
      // عرض صورة base64
      return _buildBase64Image(category.image, isDark);
    } else if (category.image.startsWith('http')) {
      // عرض صورة من URL
      return _buildNetworkImage(category.image, isDark);
    } else {
      // عرض صورة محلية (File)
      return _buildFileImage(category.image, isDark);
    }
  }

  /// بناء صورة base64
  Widget _buildBase64Image(String base64Image, bool isDark) {
    try {
      final base64String = base64Image.split(',')[1];
      final bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        key: ValueKey('base64_${base64Image.hashCode}'),
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          if (kDebugMode) {
            print('❌ Error displaying base64 image: $error');
          }
          return _buildErrorImage(isDark);
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error decoding base64 image: $e');
      }
      return _buildErrorImage(isDark);
    }
  }

  /// بناء صورة من URL
  Widget _buildNetworkImage(String imageUrl, bool isDark) {
    return Image.network(
      imageUrl,
      key: ValueKey('network_${imageUrl.hashCode}'),
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingImage(isDark);
      },
      errorBuilder: (context, error, stackTrace) {
        if (kDebugMode) {
          print('❌ Error loading network image: $error');
          print('❌ Image URL: $imageUrl');
        }
        return _buildErrorImage(isDark);
      },
    );
  }

  /// بناء صورة من ملف محلي
  Widget _buildFileImage(String imagePath, bool isDark) {
    return Image.file(
      File(imagePath),
      key: ValueKey('file_${imagePath.hashCode}'),
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        if (kDebugMode) {
          print('❌ Error loading file image: $error');
          print('❌ Image path: $imagePath');
        }
        return _buildErrorImage(isDark);
      },
    );
  }

  /// بناء صورة التحميل
  Widget _buildLoadingImage(bool isDark) {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 2,
            ),
            const SizedBox(height: 8),
            Text(
              'loading'.tr,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء صورة الخطأ
  Widget _buildErrorImage(bool isDark) {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 32,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'loadFailed'.tr,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'tapToRetry'.tr,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
