import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/clients_controller.dart';
import 'package:brother_admin_panel/features/dashboard/widgets/clients/index.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

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
                GetBuilder<ClientsController>(
                  builder: (controller) {
                    return ClientsHeaderWidget(
                      controller: controller,
                      isDark: isDark,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Content
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF16213e) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade200,
                    ),
                  ),
                  child: GetBuilder<ClientsController>(
                    builder: (controller) {
                      return Obx(() {
                        // Show form if in form mode
                        if (controller.isFormMode) {
                          return ClientFormWidget(
                            controller: controller,
                            isDark: isDark,
                          );
                        }

                        if (controller.isLoading) {
                          return ClientsLoadingWidget(isDark: isDark);
                        }

                        if (controller.clients.isEmpty) {
                          return ClientsEmptyWidget(isDark: isDark);
                        }

                        return ClientsGridWidget(
                          controller: controller,
                          isDark: isDark,
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
}
