import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: themeController.isDarkMode
                ? [Colors.blue.shade900, Colors.purple.shade900]
                : [Colors.orange.shade300, Colors.yellow.shade300],
          ),
          boxShadow: [
            BoxShadow(
              color: themeController.isDarkMode
                  ? Colors.blue.withValues(alpha: 0.3)
                  : Colors.orange.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => themeController.toggleTheme(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      themeController.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      key: ValueKey(themeController.isDarkMode),
                      color: themeController.isDarkMode
                          ? Colors.yellow
                          : Colors.orange.shade800,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      themeController.isDarkMode ? 'نهاري' : 'ليلي',
                      key: ValueKey(themeController.isDarkMode),
                      style: TextStyle(
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget مبسط لتبديل الوضع الليلي
class SimpleThemeSwitcher extends StatelessWidget {
  const SimpleThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) => IconButton(
        onPressed: () => themeController.toggleTheme(),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            key: ValueKey(themeController.isDarkMode),
            color: themeController.isDarkMode ? Colors.yellow : Colors.grey[700],
          ),
        ),
        tooltip: themeController.isDarkMode ? 'الوضع النهاري' : 'الوضع الليلي',
      ),
    );
  }
}
