import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AlbumModel {
  String id;
  String name;
  String? image;
  String arabicName;
  bool isFeature;
  AlbumModel({
    required this.id,
    required this.name,
    this.image,
    required this.arabicName,
    required this.isFeature,
  });

  static AlbumModel empty() =>
      AlbumModel(id: '', name: '', arabicName: '', image: '', isFeature: false);

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'ArabicName': arabicName,
      'Image': image,
      'IsFeature': isFeature,
    };
  }

  factory AlbumModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      if (kDebugMode) {
        print('Album data');
        print(data);
      }
      return AlbumModel(
        id: document.id,
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        arabicName: data['ArabicName'] ?? '',
        isFeature: data['IsFeature'] ?? false,
      );
    }
    return AlbumModel.empty();
  }
}
