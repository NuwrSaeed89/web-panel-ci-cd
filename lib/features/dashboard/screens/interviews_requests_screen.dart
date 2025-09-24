import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';

class InterviewsRequestsScreen extends StatelessWidget {
  const InterviewsRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;

        return Container(
          color: isDark ? const Color(0xFF1a1a2e) : const Color(0xFFf5f5f5),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'interviewsRequests'.tr,
                        style: TTextStyles.heading2.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: Text('scheduleInterview'.tr),
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

              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1a1a2e)
                        : const Color(0xFFf5f5f5),
                    borderRadius: BorderRadius.circular(12),
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 80,
                          color: isDark ? Colors.white54 : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'interviewsRequests'.tr,
                          style: TTextStyles.heading3.copyWith(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'manageAndScheduleInterviews'.tr,
                          style: TTextStyles.bodyMedium.copyWith(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'comingSoon'.tr,
                          style: TTextStyles.bodyLarge.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
