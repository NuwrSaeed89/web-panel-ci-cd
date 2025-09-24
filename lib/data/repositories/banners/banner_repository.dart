import 'package:brother_admin_panel/data/models/banner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<BannerModel>> fetchBanners() async {
    try {
      final result = await _db
          .collection('Banners')
          .where('Active', isEqualTo: true)
          .get();

      return result.docs.map(BannerModel.fromSnapshot).toList();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<String> createBanner(BannerModel banner) async {
    try {
      final docRef = await _db.collection('Banners').add(banner.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<void> updateBanner(BannerModel banner) async {
    try {
      await _db.collection('Banners').doc(banner.id).update(banner.toJson());
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<void> deleteBanner(String bannerId) async {
    try {
      await _db.collection('Banners').doc(bannerId).delete();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }
}
