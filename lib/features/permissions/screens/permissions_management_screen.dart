import 'package:brother_admin_panel/features/permissions/controllers/permissions_controller.dart';
import 'package:brother_admin_panel/features/permissions/screens/responsive-screens/permissions_desktop_tablet.dart';
import 'package:brother_admin_panel/features/permissions/screens/responsive-screens/permissions_mobile.dart';
import 'package:brother_admin_panel/features/permissions/widgets/add_permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionsManagementScreen extends StatelessWidget {
  const PermissionsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تهيئة وحدة التحكم عند دخول الصفحة (فقط إذا لم تكن موجودة)
    if (!Get.isRegistered<PermissionsController>()) {
      Get.put(PermissionsController());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // تحديد نوع الشاشة بناءً على العرض
        if (constraints.maxWidth >= 1200) {
          // Desktop
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const PermissionsDesktopTablet(),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => Get.dialog(const AddPermissionDialog()),
              backgroundColor: Theme.of(context).primaryColor,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'addPermission'.tr,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else if (constraints.maxWidth >= 768) {
          // Tablet
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const PermissionsDesktopTablet(),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => Get.dialog(const AddPermissionDialog()),
              backgroundColor: Theme.of(context).primaryColor,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'addPermission'.tr,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else {
          // Mobile
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const PermissionsMobile(),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.dialog(const AddPermissionDialog()),
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        }
      },
    );
  }
}
