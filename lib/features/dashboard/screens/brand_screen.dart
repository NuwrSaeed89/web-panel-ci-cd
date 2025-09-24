import 'package:brother_admin_panel/features/dashboard/controllers/brand_controller.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/brand/brand_card.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/brand/brand_form.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/brand/brand_header.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/brand/brand_states.dart';
import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class BrandScreen extends StatelessWidget {
  const BrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BrandController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GetBuilder<BrandController>(
        builder: (brandController) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Title Section
                Container(
                  width: ResponsiveHelper.isMobile(context)
                      ? double.infinity
                      : THelperFunctions.screenwidth() / 3,
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bool isMobile = constraints.maxWidth < 600;
                      return Text(
                        'suppliers'.tr,
                        style: TTextStyles.heading3.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: isMobile ? 20 : 28,
                        ),
                        textAlign:
                            isMobile ? TextAlign.center : TextAlign.right,
                      );
                    },
                  ),
                ),

                // Header with Search and Add Button
                BrandHeader(
                  context: context,
                  isDark: isDark,
                  controller: controller,
                ),

                // Content
                if (brandController.isFormMode)
                  _buildFormView(context, isDark, brandController)
                else
                  _buildBrandsList(context, isDark, brandController),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormView(
      BuildContext context, bool isDark, BrandController controller) {
    return Container(
      margin: ResponsiveHelper.getResponsivePadding(context),
      child: BrandForm(
        brand: controller.selectedBrand,
        isEditMode: controller.isEditMode,
      ),
    );
  }

  Widget _buildBrandsList(
      BuildContext context, bool isDark, BrandController controller) {
    // Force refresh to ensure data is loaded
    if (controller.brands.isEmpty && !controller.isLoading) {
      if (kDebugMode) {
        print('🔄 BrandScreen: No brands found, triggering loadBrands...');
      }
      controller.loadBrands();
      return BrandLoadingState(
        context: context,
        isDark: isDark,
      );
    }

    if (controller.isLoading) {
      if (kDebugMode) {
        print('⏳ BrandScreen: Showing loading state...');
      }
      return BrandLoadingState(
        context: context,
        isDark: isDark,
      );
    }

    if (controller.filteredBrands.isEmpty) {
      if (kDebugMode) {
        print('📭 BrandScreen: No filtered brands, showing empty state...');
      }
      return BrandEmptyState(
        context: context,
        isDark: isDark,
      );
    }

    if (kDebugMode) {
      print(
          '✅ BrandScreen: Building brands list with ${controller.filteredBrands.length} brands');
    }

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: ResponsiveHelper.responsiveBuilder(
        context: context,
        mobile: _buildMobileBrandsList(context, isDark, controller),
        tablet: _buildTabletBrandsList(context, isDark, controller),
        desktop: _buildDesktopBrandsList(context, isDark, controller),
      ),
    );
  }

  Widget _buildMobileBrandsList(
      BuildContext context, bool isDark, BrandController controller) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      itemCount: controller.filteredBrands.length,
      crossAxisCount: 2,
      itemBuilder: (context, index) {
        final brand = controller.filteredBrands[index];
        return BrandCard(
          context: context,
          isDark: isDark,
          brand: brand,
          controller: controller,
          isMobile: true,
        );
      },
    );
  }

  Widget _buildTabletBrandsList(
      BuildContext context, bool isDark, BrandController controller) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2, // 4 أعمدة للتابلت
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,

      itemCount: controller.filteredBrands.length,
      itemBuilder: (context, index) {
        final brand = controller.filteredBrands[index];
        return BrandCard(
          context: context,
          isDark: isDark,
          brand: brand,
          controller: controller,
          isMobile: false,
        );
      },
    );
  }

  Widget _buildDesktopBrandsList(
      BuildContext context, bool isDark, BrandController controller) {
    // Responsive grid based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;

    if (screenWidth > 1400) {
      crossAxisCount = 6; // Extra large screens
    } else if (screenWidth > 1200) {
      crossAxisCount = 5; // Large screens
    } else if (screenWidth > 1000) {
      crossAxisCount = 3; // Medium screens
    } else {
      crossAxisCount = 2; // Small desktop screens
    }

    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      itemCount: controller.filteredBrands.length,
      itemBuilder: (context, index) {
        final brand = controller.filteredBrands[index];
        return BrandCard(
          context: context,
          isDark: isDark,
          brand: brand,
          controller: controller,
          isMobile: false,
        );
      },
    );
  }
}
