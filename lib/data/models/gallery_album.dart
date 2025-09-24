import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryAlbumModel {
  final String galleryId;
  final String albumId;

  GalleryAlbumModel({required this.galleryId, required this.albumId});
  Map<String, dynamic> toJason() {
    return {'GalleryId': galleryId, 'albumId': albumId};
  }

  factory GalleryAlbumModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return GalleryAlbumModel(
        albumId: data['AlbumId'] as String,
        galleryId: data['GalleryId'] as String);
  }
}
