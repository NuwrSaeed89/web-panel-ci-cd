import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/features/authentication/controllers/login_controller.dart';

class BuildUserInfo extends StatelessWidget {
  const BuildUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? 'user@example.com';
    final userName = user?.displayName ?? userEmail.split('@')[0];
    final themeController = Get.find<ThemeController>();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          _showLogoutDialog(context);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'user_info',
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode
                      ? Colors.white
                      : Colors.black87,
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: themeController.isDarkMode
                      ? Colors.white70
                      : Colors.black54,
                  fontSize: isMobile ? 12 : 14,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red,
                size: isMobile ? 18 : 20,
              ),
              const SizedBox(width: 8),
              Text(
                'logout'.tr,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: Colors.red,
                  fontSize: isMobile ? 12 : 14,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              themeController.isDarkMode ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: themeController.isDarkMode
                ? Colors.grey[700]!
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: isMobile ? 12 : 14,
              backgroundColor: themeController.isDarkMode
                  ? Colors.blue[800]
                  : Colors.blue[100],
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: themeController.isDarkMode
                      ? Colors.white
                      : Colors.blue[800],
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 12 : 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (!isMobile) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      fontWeight: FontWeight.w600,
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'logout'.tr,
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans Arabic',
                      color: themeController.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.arrow_drop_down,
              color:
                  themeController.isDarkMode ? Colors.white70 : Colors.black54,
              size: isMobile ? 16 : 18,
            ),
          ],
        ),
      ),
    );
  }

  /// عرض حوار تأكيد تسجيل الخروج
  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'confirmLogout'.tr,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        content: Text(
          'logoutConfirmationMessage'.tr,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'cancel'.tr,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                final loginController = Get.find<LoginController>();
                await loginController.signOut();
              } catch (e) {
                // إذا لم تكن وحدة التحكم موجودة، استخدم Firebase مباشرة
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed('/login');
              }
            },
            child: Text(
              'logout'.tr,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
