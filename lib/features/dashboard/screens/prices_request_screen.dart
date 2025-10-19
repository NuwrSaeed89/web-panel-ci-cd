import 'package:brother_admin_panel/features/dashboard/controllers/price_request_controller.dart';
import 'package:brother_admin_panel/features/dashboard/screens/price_request_detail_screen.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/price_request_card.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/font_constants.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/helpers/translation_helper.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PricesRequestScreen extends StatelessWidget {
  const PricesRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;

        // التأكد من وجود المتحكم
        Get.put(PriceRequestController());

        return Container(
          color: isDark ? const Color(0xFF0a0a0a) : const Color(0xFFf5f5f5),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF111111) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF222222)
                          : Colors.grey.shade200,
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
                  child: GetBuilder<PriceRequestController>(
                    builder: (controller) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final bool isWideScreen = constraints.maxWidth > 600;

                          return isWideScreen
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'priceRequests'.tr,
                                        style: TTextStyles.heading2.copyWith(
                                          color: isDark
                                              ? Colors.white
                                              : Color(0xFF111111),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.add),
                                      label: Text('newPriceRequest'.tr),
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
                                            'priceRequests'.tr,
                                            style:
                                                TTextStyles.heading3.copyWith(
                                              color: isDark
                                                  ? Colors.white
                                                  : Color(0xFF111111),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.add, size: 18),
                                          label: Text(
                                            'newPriceRequest'.tr,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF0055ff),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            minimumSize: const Size(0, 36),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildSearchAndFilterSection(
                                        controller, isDark),
                                  ],
                                );
                        },
                      );
                    },
                  ),
                ),

                // const SizedBox(height: 16),

                // Content
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF111111) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF222222)
                          : Colors.grey.shade200,
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
                  child: GetBuilder<PriceRequestController>(
                    builder: (controller) {
                      return Obx(() {
                        if (controller.isLoading.value) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  'loadingProjects'.tr,
                                  style: TTextStyles.bodyMedium.copyWith(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (controller.priceRequests.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.request_quote,
                                  size: 80,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'noPriceRequests'.tr,
                                  style: TTextStyles.heading3.copyWith(
                                    color: isDark
                                        ? Colors.white
                                        : Color(0xFF111111),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'startByAddingRequest'.tr,
                                  style: TTextStyles.bodyMedium.copyWith(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final bool isWideScreen =
                                constraints.maxWidth > 600;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Search and Filter Section (only for wide screens)
                                if (isWideScreen) ...[
                                  _buildSearchAndFilterSection(
                                      controller, isDark),
                                  const SizedBox(height: 24),
                                ],

                                // Results Count
                                if (controller.filteredRequests.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Text(
                                      'foundRequests'.trCount(
                                          controller.filteredRequests.length),
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                        fontFamily: FontConstants.primaryFont,
                                        fontSize: FontConstants.base,
                                      ),
                                    ),
                                  ),

                                // Requests Grid
                                if (controller.filteredRequests.isEmpty)
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.search_off,
                                          size: 80,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'noResults'.tr,
                                          style: TTextStyles.heading3.copyWith(
                                            color: isDark
                                                ? Colors.white
                                                : Color(0xFF111111),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'tryChangingSearch'.tr,
                                          style:
                                              TTextStyles.bodyMedium.copyWith(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  RefreshIndicator(
                                    onRefresh: controller.fetchAllPriceRequests,
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        // Responsive grid based on screen width
                                        int crossAxisCount;
                                        double childAspectRatio;

                                        if (constraints.maxWidth > 1200) {
                                          // Large desktop: 4 columns
                                          crossAxisCount = 5;
                                          childAspectRatio = 1.5;
                                        } else if (constraints.maxWidth > 900) {
                                          // Medium desktop: 3 columns
                                          crossAxisCount = 4;
                                          childAspectRatio = 1.0;
                                        } else if (constraints.maxWidth > 600) {
                                          // Small desktop/tablet: 2 columns
                                          crossAxisCount = 3;
                                          childAspectRatio = 1.2;
                                        } else {
                                          // Mobile: 1 column
                                          crossAxisCount = 1;
                                          childAspectRatio = 1.1;
                                        }

                                        return GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount,
                                            childAspectRatio: childAspectRatio,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12,
                                          ),
                                          itemCount: controller
                                              .filteredRequests.length,
                                          itemBuilder: (context, index) {
                                            final request = controller
                                                .filteredRequests[index];
                                            return PriceRequestCard(
                                              request: request,
                                              onTap: () => Get.to(() =>
                                                  PriceRequestDetailScreen(
                                                      request: request)),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilterSection(
      PriceRequestController controller, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: controller.searchController,
              onChanged: (value) {
                // Trigger immediate filtering when text changes
                controller.onSearchChanged();
              },
              decoration: InputDecoration(
                hintText: 'searchInRequests'.tr,
                prefixIcon: Icon(Icons.search, size: isMobile ? 20 : 24),
                suffixIcon: controller.searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () async {
                          await controller.clearSearch();
                        },
                        icon: Icon(Icons.clear, size: isMobile ? 18 : 20),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                ),
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 12 : 16,
                ),
              ),
              style: TextStyle(
                fontFamily: FontConstants.primaryFont,
                color: isDark ? Colors.white : Color(0xFF111111),
                fontSize: isMobile ? 14 : 16,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),

            // Status Filter
            Text(
              'filterByStatus'.tr,
              style: TTextStyles.bodyMedium.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
                fontFamily: FontConstants.primaryFont,
                fontSize: isMobile ? 13 : 14,
              ),
            ),
            SizedBox(height: isMobile ? 6 : 8),
            Obx(() => Wrap(
                  spacing: isMobile ? 6 : 8,
                  runSpacing: isMobile ? 6 : 8,
                  children: controller.availableStatuses.map((status) {
                    final isSelected =
                        controller.selectedStatus.value == status;
                    return FilterChip(
                      label: Text(
                        status == 'all' ? 'all'.tr : status.tr,
                        style: TextStyle(
                          color: isSelected ? Colors.white : null,
                          fontFamily: FontConstants.primaryFont,
                          fontSize: isMobile ? 12 : 14,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) async {
                        if (selected) {
                          await controller.changeStatusFilter(status);
                        }
                      },
                      backgroundColor:
                          isDark ? Colors.white10 : Colors.grey.shade200,
                      selectedColor: TColors.primary,
                      checkmarkColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 8 : 12,
                        vertical: isMobile ? 4 : 6,
                      ),
                    );
                  }).toList(),
                )),
          ],
        );
      },
    );
  }
}
