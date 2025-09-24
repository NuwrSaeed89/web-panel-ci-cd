import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';

class MobileSettingsWidget extends StatelessWidget {
  const MobileSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    // final languageController = Get.find<LanguageController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإعدادات',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 24),

          // إعدادات المظهر
          _buildSettingsSection(
            'المظهر',
            Icons.palette,
            [
              _buildSwitchTile(
                'الوضع الدارك',
                'تفعيل الوضع الدارك',
                themeController.isDarkMode,
                (value) => themeController.toggleTheme(),
                themeController,
              ),
            ],
            themeController,
          ),

          const SizedBox(height: 24),

          // إعدادات اللغة
          _buildSettingsSection(
            'اللغة',
            Icons.language,
            [
              _buildListTile(
                'اللغة الحالية',
                'English',
                Icons.arrow_forward_ios,
                () {
                  // يمكن إضافة تفاعل هنا
                },
                themeController,
              ),
            ],
            themeController,
          ),

          const SizedBox(height: 24),

          // إعدادات أخرى
          _buildSettingsSection(
            'أخرى',
            Icons.settings,
            [
              _buildListTile(
                'حول التطبيق',
                'إصدار 1.0.0',
                Icons.info_outline,
                () {
                  // يمكن إضافة تفاعل هنا
                },
                themeController,
              ),
              _buildListTile(
                'سياسة الخصوصية',
                'اقرأ سياسة الخصوصية',
                Icons.privacy_tip_outlined,
                () {
                  // يمكن إضافة تفاعل هنا
                },
                themeController,
              ),
              _buildListTile(
                'تسجيل الخروج',
                'تسجيل الخروج من التطبيق',
                Icons.logout,
                () {
                  // يمكن إضافة تفاعل هنا
                },
                themeController,
                isDestructive: true,
              ),
            ],
            themeController,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    String title,
    IconData icon,
    List<Widget> children,
    ThemeController themeController,
  ) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: themeController.isDarkMode
                      ? Colors.blue
                      : Colors.blue.shade700,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    ThemeController themeController,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'IBM Plex Sans Arabic',
          color: themeController.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'IBM Plex Sans Arabic',
          color: themeController.isDarkMode ? Colors.white70 : Colors.grey,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor:
          themeController.isDarkMode ? TColors.primary : Colors.blue.shade700,
    );
  }

  Widget _buildListTile(
    String title,
    String subtitle,
    IconData trailing,
    VoidCallback onTap,
    ThemeController themeController, {
    bool isDestructive = false,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'IBM Plex Sans Arabic',
          color: isDestructive
              ? Colors.red
              : (themeController.isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'IBM Plex Sans Arabic',
          color: themeController.isDarkMode ? Colors.white70 : Colors.grey,
        ),
      ),
      trailing: Icon(
        trailing,
        color: isDestructive
            ? Colors.red
            : (themeController.isDarkMode ? Colors.white70 : Colors.grey),
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
