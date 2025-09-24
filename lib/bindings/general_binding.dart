import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/localization/language_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/dashboard_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/product_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/category_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/brand_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/banner_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/album_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/gallery_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/blog_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/brother_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/order_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/price_request_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/project_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/statistics_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/navigation_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/clients_controller.dart';
import 'package:brother_admin_panel/features/authentication/controllers/login_controller.dart';
import 'package:brother_admin_panel/data/repositories/product/product_repository.dart';
import 'package:brother_admin_panel/data/repositories/categories/category_repository.dart';
import 'package:brother_admin_panel/data/repositories/Brand/brand_repository.dart';
import 'package:brother_admin_panel/data/repositories/banners/banner_repository.dart';
import 'package:brother_admin_panel/data/repositories/album/album_repository.dart';
import 'package:brother_admin_panel/data/repositories/gallery/gallery_repository.dart';
import 'package:brother_admin_panel/data/repositories/gallery_album/gallery_album_repository.dart';
import 'package:brother_admin_panel/data/repositories/blog/blog_repository.dart';
import 'package:brother_admin_panel/data/repositories/brothers/brothers_repository.dart';
import 'package:brother_admin_panel/data/repositories/order/order_repository.dart';
import 'package:brother_admin_panel/data/repositories/project/project_repository.dart';
import 'package:brother_admin_panel/data/repositories/clients/clients_repository.dart';
import 'package:brother_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:brother_admin_panel/services/firebase_storage_service.dart';
import 'package:flutter/foundation.dart';

class GeneralBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put(FirebaseStorageService(), permanent: true);

    // Repositories
    Get.put(ProductRepository(), permanent: true);
    Get.put(CategoryRepository(), permanent: true);
    Get.put(BrandRepository(), permanent: true);
    Get.put(BannerRepository(), permanent: true);
    Get.put(AlbumRepository(), permanent: true);
    Get.put(GalleryRepository(), permanent: true);
    Get.put(GalleryAlbumRepository(), permanent: true);
    Get.put(BlogRepository(), permanent: true);
    Get.put(BrotherRepository(), permanent: true);
    Get.put(OrderRepository(), permanent: true);
    Get.put(ProjectRepository(), permanent: true);
    Get.put(ClientsRepository(), permanent: true);
    Get.put(AuthenticationRepository(), permanent: true);

    // Theme Controller
    Get.put(ThemeController(), permanent: true);

    // Language Controller
    Get.put(LanguageController(), permanent: true);

    // Dashboard Controllers
    Get.put(DashboardController(), permanent: true);
    Get.put(ProductController(), permanent: true);
    Get.put(CategoryController(), permanent: true);
    Get.put(BrandController(), permanent: true);
    Get.put(BannerController(), permanent: true);
    Get.put(AlbumController(), permanent: true);
    Get.put(GalleryController(), permanent: true);
    Get.put(BlogController(), permanent: true);
    Get.put(BrotherController(), permanent: true);
    Get.put(OrderController(), permanent: true);
    Get.put(PriceRequestController(), permanent: true);
    Get.put(ProjectController(), permanent: true);
    Get.put(StatisticsController(), permanent: true);
    Get.put(NavigationController(), permanent: true);
    Get.put(ClientsController(), permanent: true);

    // Authentication Controller
    Get.put(LoginController(), permanent: true);
  }

  /// طباعة حالة جميع المتحكمات للتأكد من تهيئتها
  static void printControllersStatus() {
    if (kDebugMode) {
      print('🔍 === حالة المتحكمات ===');

      final controllers = [
        'ProductRepository',
        'CategoryRepository',
        'BrandRepository',
        'BannerRepository',
        'AlbumRepository',
        'GalleryRepository',
        'GalleryAlbumRepository',
        'ProjectRepository',
        'AuthenticationRepository',
        'ThemeController',
        'LanguageController',
        'DashboardController',
        'ProductController',
        'CategoryController',
        'BrandController',
        'BannerController',
        'AlbumController',
        'GalleryController',
        'BlogController',
        'PriceRequestController',
        'ProjectController',
        'StatisticsController',
        'NavigationController',
        'ClientsController',
        'LoginController',
      ];

      for (final controllerName in controllers) {
        try {
          Get.find();
          print('✅ $controllerName: تم التهيئة بنجاح');
        } catch (e) {
          print('❌ $controllerName: فشل في التهيئة - $e');
        }
      }

      print('🔍 === نهاية حالة المتحكمات ===');
    }
  }
}
