import 'package:brother_admin_panel/data/models/album_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AlbumRepository extends GetxController {
  static AlbumRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<AlbumModel>> getAllAlbums() async {
    try {
      if (kDebugMode) {
        print("=======before Album data==========");
      }

      final snapshot = await _db.collection('Album').get();

      final list = snapshot.docs.map(AlbumModel.fromSnapshot).toList();
      if (kDebugMode) {
        print("=======data==============");
        print(list);
      }
      return list;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Create new album
  Future<String> createAlbum(AlbumModel album) async {
    try {
      final docRef = await _db.collection('Album').add(album.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Update existing album
  Future<void> updateAlbum(AlbumModel album) async {
    try {
      await _db.collection('Album').doc(album.id).update(album.toJson());
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Delete album
  Future<void> deleteAlbum(String albumId) async {
    try {
      await _db.collection('Album').doc(albumId).delete();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Get album by ID
  Future<AlbumModel?> getAlbumById(String albumId) async {
    try {
      final doc = await _db.collection('Album').doc(albumId).get();
      if (doc.exists) {
        return AlbumModel.fromSnapshot(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }
}
