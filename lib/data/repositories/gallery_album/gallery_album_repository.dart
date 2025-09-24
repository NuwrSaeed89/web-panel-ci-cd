import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GalleryAlbumRepository extends GetxController {
  static GalleryAlbumRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  // Add image to album (create relationship)
  Future<void> addImageToAlbum(String galleryId, String albumId) async {
    try {
      await _db.collection('GalleryAlbum').add({
        'GalleryId': galleryId,
        'AlbumId': albumId,
      });
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Remove image from album (delete relationship)
  Future<void> removeImageFromAlbum(String galleryId, String albumId) async {
    try {
      final query = await _db
          .collection('GalleryAlbum')
          .where('GalleryId', isEqualTo: galleryId)
          .where('AlbumId', isEqualTo: albumId)
          .get();

      for (var doc in query.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Get all albums for a specific image
  Future<List<String>> getAlbumsForImage(String galleryId) async {
    try {
      final query = await _db
          .collection('GalleryAlbum')
          .where('GalleryId', isEqualTo: galleryId)
          .get();

      return query.docs.map((doc) => doc['AlbumId'] as String).toList();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Get all images for a specific album
  Future<List<String>> getImagesForAlbum(String albumId) async {
    try {
      final query = await _db
          .collection('GalleryAlbum')
          .where('AlbumId', isEqualTo: albumId)
          .get();

      return query.docs.map((doc) => doc['GalleryId'] as String).toList();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Check if image is in album
  Future<bool> isImageInAlbum(String galleryId, String albumId) async {
    try {
      final query = await _db
          .collection('GalleryAlbum')
          .where('GalleryId', isEqualTo: galleryId)
          .where('AlbumId', isEqualTo: albumId)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Remove all relationships for an album (when deleting album)
  Future<void> removeAllRelationshipsForAlbum(String albumId) async {
    try {
      final query = await _db
          .collection('GalleryAlbum')
          .where('AlbumId', isEqualTo: albumId)
          .get();

      for (var doc in query.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Remove all relationships for an image (when deleting image)
  Future<void> removeAllRelationshipsForImage(String galleryId) async {
    try {
      final query = await _db
          .collection('GalleryAlbum')
          .where('GalleryId', isEqualTo: galleryId)
          .get();

      for (var doc in query.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }
}
