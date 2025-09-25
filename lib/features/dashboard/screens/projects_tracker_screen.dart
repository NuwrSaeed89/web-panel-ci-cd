import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/utils/constants/font_constants.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/project_controller.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/project_card.dart';
import 'package:brother_admin_panel/features/dashboard/screens/project_detail_screen.dart';

class ProjectsTrackerScreen extends StatelessWidget {
  const ProjectsTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectController = Get.find<ProjectController>();

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
                    //  color: isDark ? const Color(0xFF16213e) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'projectsTrackerTitle'.tr,
                          style: TTextStyles.heading2.copyWith(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: Text('newProject'.tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0055ff),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search and Filter Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    //  color: isDark ? const Color(0xFF16213e) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Search Bar
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: projectController.searchController,
                              decoration: InputDecoration(
                                hintText: 'searchInProjectName'.tr,
                                hintStyle: TextStyle(
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey.shade500,
                                  fontFamily: FontConstants.primaryFont,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey.shade500,
                                ),
                                suffixIcon: projectController
                                        .searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.grey.shade500,
                                        ),
                                        onPressed: () async {
                                          await projectController.clearSearch();
                                        },
                                      )
                                    : null,
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
                                  borderSide: BorderSide(
                                    color: Colors.blue.shade400,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.grey.shade50,
                              ),
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                                fontFamily: FontConstants.primaryFont,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Status Filter
                      Row(
                        children: [
                          Text(
                            'filterByStatus'.tr,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontFamily: FontConstants.primaryFont,
                              fontWeight: FontConstants.medium,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Obx(() => SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: projectController
                                        .availableStatuses
                                        .map((status) {
                                      final isSelected = projectController
                                              .selectedStatus.value ==
                                          status;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: FilterChip(
                                          label: Text(
                                            projectController
                                                .getTranslatedStatus(status),
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : (isDark
                                                      ? Colors.white70
                                                      : Colors.black87),
                                              fontFamily:
                                                  FontConstants.primaryFont,
                                              fontWeight: isSelected
                                                  ? FontConstants.semiBold
                                                  : FontConstants.regular,
                                            ),
                                          ),
                                          selected: isSelected,
                                          onSelected: (selected) async {
                                            if (selected) {
                                              await projectController
                                                  .changeStatusFilter(status);
                                            }
                                          },
                                          backgroundColor: isDark
                                              ? Colors.white
                                                  .withValues(alpha: 0.1)
                                              : Colors.grey.shade100,
                                          selectedColor: Colors.blue.shade600,
                                          checkmarkColor: Colors.white,
                                          side: BorderSide(
                                            color: isSelected
                                                ? Colors.blue.shade600
                                                : (isDark
                                                    ? Colors.white24
                                                    : Colors.grey.shade300),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Content
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    //  color: isDark ? const Color(0xFF16213e) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade200,
                    ),
                  ),
                  child: Obx(() {
                    if (projectController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // مؤشر البحث
                    if (projectController.searchController.text.isNotEmpty &&
                        projectController.filteredProjects.isEmpty &&
                        projectController.projects.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text('searching'.tr),
                          ],
                        ),
                      );
                    }

                    if (projectController.filteredProjects.isEmpty) {
                      if (projectController.projects.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.work_outline,
                                size: 80,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'noProjects'.tr,
                                style: TTextStyles.heading3.copyWith(
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'startByAddingProject'.tr,
                                style: TTextStyles.bodyMedium.copyWith(
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'tryChangingSearch'.tr,
                                style: TTextStyles.bodyMedium.copyWith(
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Results Count
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            _replaceParams('foundProjects'.tr, {
                              'count': projectController.filteredProjects.length
                                  .toString()
                            }),
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontFamily: FontConstants.primaryFont,
                              fontSize: FontConstants.base,
                            ),
                          ),
                        ),

                        // Projects Grid
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Calculate responsive grid based on screen width
                            final double screenWidth = constraints.maxWidth;
                            int crossAxisCount;
                            double childAspectRatio;

                            if (screenWidth > 1400) {
                              crossAxisCount = 4; // Large screens
                              childAspectRatio = 1.4;
                            } else if (screenWidth > 1000) {
                              crossAxisCount = 3; // Medium screens
                              childAspectRatio = 1.2;
                            } else if (screenWidth > 700) {
                              crossAxisCount = 2; // Small screens
                              childAspectRatio = 1.5;
                            } else {
                              crossAxisCount = 1; // Very small screens
                              childAspectRatio = 1.2;
                            }

                            return RefreshIndicator(
                              onRefresh: projectController.fetchAllProjects,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: childAspectRatio,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount:
                                    projectController.filteredProjects.length,
                                itemBuilder: (context, index) {
                                  final project =
                                      projectController.filteredProjects[index];
                                  return ProjectCard(
                                    project: project,
                                    onTap: () {
                                      Get.to(() => ProjectDetailScreen(
                                          project: project));
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // دالة مساعدة لاستبدال المعاملات في النصوص
  String _replaceParams(String text, Map<String, String> params) {
    String result = text;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}
