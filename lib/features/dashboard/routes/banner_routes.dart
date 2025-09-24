import 'package:get/get.dart';
import 'package:brother_admin_panel/features/dashboard/screens/banners_screen.dart';
import 'package:brother_admin_panel/features/dashboard/bindings/banner_binding.dart';

class BannerRoutes {
  static final routes = [
    GetPage(
      name: '/banners',
      page: () => const BannersScreen(),
      binding: BannerBinding(),
    ),
  ];
}
