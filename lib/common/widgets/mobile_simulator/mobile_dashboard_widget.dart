import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';

class MobileDashboardWidget extends StatelessWidget {
  const MobileDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'لوحة التحكم',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // إحصائيات سريعة
          _buildQuickStats(themeController),
          const SizedBox(height: 24),

          // إجراءات سريعة
          _buildQuickActions(themeController),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ThemeController themeController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            themeController.isDarkMode ? const Color(0xFF2a2a3e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeController.isDarkMode
              ? Colors.white24
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات سريعة',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('الفئات', '12', Icons.category, themeController),
              _buildStatItem(
                  'المنتجات', '45', Icons.shopping_bag, themeController),
              _buildStatItem('العملاء', '8', Icons.people, themeController),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String count, IconData icon,
      ThemeController themeController) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: themeController.isDarkMode
              ? TColors.primary
              : Colors.blue.shade700,
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontSize: 12,
            color: themeController.isDarkMode ? Colors.white70 : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(ThemeController themeController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            themeController.isDarkMode ? const Color(0xFF2a2a3e) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeController.isDarkMode
              ? Colors.white24
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إجراءات سريعة',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionItem('إضافة فئة', Icons.add, themeController),
              _buildActionItem(
                  'إضافة منتج', Icons.add_shopping_cart, themeController),
              _buildActionItem('إضافة عميل', Icons.person_add, themeController),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
      String title, IconData icon, ThemeController themeController) {
    return GestureDetector(
      onTap: () {
        // يمكن إضافة تفاعل هنا
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeController.isDarkMode
                  ? Colors.blue.withValues(alpha: 0.2)
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: themeController.isDarkMode
                  ? TColors.primary
                  : Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 12,
              color: themeController.isDarkMode ? Colors.white70 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
