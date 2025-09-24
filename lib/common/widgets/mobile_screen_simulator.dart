import 'package:brother_admin_panel/common/widgets/mobile_simulator/index.dart';
import 'package:brother_admin_panel/common/widgets/mobile_simulator/mobile_blog_controller.dart';
import 'package:brother_admin_panel/common/widgets/mobile_simulator/mobile_blog_widget.dart';
import 'package:brother_admin_panel/common/widgets/mobile_simulator/mobile_brands_widget.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/banner_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/brand_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/category_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/clients_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/gallery_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/product_controller.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileScreenSimulator extends StatefulWidget {
  final int currentTabIndex;

  const MobileScreenSimulator({
    super.key,
    required this.currentTabIndex,
  });

  @override
  State<MobileScreenSimulator> createState() => _MobileScreenSimulatorState();
}

class _MobileScreenSimulatorState extends State<MobileScreenSimulator> {
  @override
  void initState() {
    super.initState();
    // تهيئة Controllers إذا لم تكن موجودة
    if (!Get.isRegistered<CategoryController>()) {
      Get.put(CategoryController());
    }
    if (!Get.isRegistered<BannerController>()) {
      Get.put(BannerController());
    }
    if (!Get.isRegistered<GalleryController>()) {
      Get.put(GalleryController());
    }
    if (!Get.isRegistered<ClientsController>()) {
      Get.put(ClientsController());
    }
    if (!Get.isRegistered<ProductController>()) {
      Get.put(ProductController());
    }
    if (!Get.isRegistered<BrandController>()) {
      Get.put(BrandController());
    }
    if (!Get.isRegistered<MobileBlogController>()) {
      Get.put(MobileBlogController());
    }

    // إضافة listener لتحديث شاشة المحاكي عند تغيير الفئات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<CategoryController>()) {
        final categoryController = Get.find<CategoryController>();
        // تحديث شاشة المحاكي عند تغيير الفئات
        categoryController.addListener(() {
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // تنظيف listener
    if (Get.isRegistered<CategoryController>()) {
      final categoryController = Get.find<CategoryController>();
      categoryController.removeListener(() {});
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: themeController.isDarkMode
          ? const Color(0xFF1a1a2e)
          : const Color(0xFFf5f5f5),
      child: Column(
        children: [
          // شريط الحالة (Status Bar)
          //   _buildStatusBar(themeController),

          // شريط التنقل (Navigation Bar)
          //  _buildNavigationBar(themeController),

          // المحتوى الرئيسي
          Expanded(
            child: _buildContent(themeController),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeController themeController) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: _getTabContent(widget.currentTabIndex),
    );
  }

  Widget _getTabContent(int tabIndex) {
    // استخدام الـ widgets المنفصلة
    switch (tabIndex) {
      case 0:
        return Container(); //const MobileDashboardWidget();
      case 1:
        return Container(); //_buildMobileProjectsTracker();
      case 2:
        return Container(); //_buildMobilePricesRequest();
      case 3:
        return Container(); //_buildMobileShoppingOrders();
      case 4:
        return const MobileCategoriesWidget();
      case 5:
        return const MobileBrandsWidget();
      case 6:
        return const MobileProductsWidget();
      case 7:
        return const MobileBlogWidget();
      case 8:
        return const MobileGalleryWidget();
      case 9:
        return const MobileBannersWidget();
      case 10:
        return const MobileClientsWidget();
      case 11:
        return const MobileSettingsWidget();
      default:
        return const MobileDashboardWidget();
    }
  }
}
