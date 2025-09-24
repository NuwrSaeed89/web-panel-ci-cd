import 'package:brother_admin_panel/data/models/gallery_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GalleryRepository extends GetxController {
  static GalleryRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<GalleryModel>> fetchgalleryPhoto() async {
    try {
      final result = await _db
          .collection('Gallery')
          .where('IsFeature', isEqualTo: true)
          .get();

      return result.docs.map(GalleryModel.fromSnapshot).toList();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<List<GalleryModel>> getPhotoForAlbum(
      {required String albumId, int limit = -1}) async {
    try {
      final QuerySnapshot galleryAlbumQuery = limit == -1
          ? await _db
              .collection('GalleryAlbum')
              .where('AlbumId', isEqualTo: albumId)
              .get()
          : await _db
              .collection('GalleryAlbum')
              .where('AlbumId', isEqualTo: albumId)
              .limit(limit)
              .get();

      final List<String> galleryIds = galleryAlbumQuery.docs
          .map((doc) => doc['GalleryId'] as String)
          .toList();
      if (galleryIds.isEmpty) return [];
      final galleryQuery = await _db
          .collection('Gallery')
          .where(FieldPath.documentId, whereIn: galleryIds)
          .get();
      final List<GalleryModel> gallery =
          galleryQuery.docs.map(GalleryModel.fromSnapshot).toList();
      return gallery;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Get all gallery images
  Future<List<GalleryModel>> getAllGalleryImages() async {
    try {
      final snapshot = await _db.collection('Gallery').get();
      return snapshot.docs.map(GalleryModel.fromSnapshot).toList();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Create new gallery image
  Future<String> createGalleryImage(GalleryModel gallery) async {
    try {
      final docRef = await _db.collection('Gallery').add(gallery.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Update existing gallery image
  Future<void> updateGalleryImage(String imageId, GalleryModel gallery) async {
    try {
      await _db.collection('Gallery').doc(imageId).update(gallery.toJson());
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Delete gallery image
  Future<void> deleteGalleryImage(String imageId) async {
    try {
      await _db.collection('Gallery').doc(imageId).delete();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Get gallery image by ID
  Future<GalleryModel?> getGalleryImageById(String imageId) async {
    try {
      final doc = await _db.collection('Gallery').doc(imageId).get();
      if (doc.exists) {
        return GalleryModel.fromSnapshot(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }
}
