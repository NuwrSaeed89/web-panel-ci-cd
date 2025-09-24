import 'package:get/get.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/banner_controller.dart';
import 'package:brother_admin_panel/data/repositories/banners/banner_repository.dart';

class BannerBinding extends Bindings {
  @override
  void dependencies() {
    // Register BannerRepository
    Get.lazyPut<BannerRepository>(BannerRepository.new);

    // Register BannerController
    Get.lazyPut<BannerController>(BannerController.new);
  }
}
