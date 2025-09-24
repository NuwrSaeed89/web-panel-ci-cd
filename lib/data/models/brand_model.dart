// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BrandModel {
  String id;
  String name;
  String image;
  String cover;
  final int? productCount;
  final bool? isFeature;
  // List<CategoryModel>? categories;

  BrandModel({
    required this.id,
    required this.cover,
    required this.image,
    required this.name,
    this.productCount,
    this.isFeature,
    // this.categories
  });
  static BrandModel empty() =>
      BrandModel(id: '', name: '', image: '', cover: '');

  toJson() {
    return {
      'Id': id,
      'Image': image,
      'Cover': cover,
      'Name': name,
      'ProductsCounts': productCount,
      'IsFeature': isFeature
    };
  }

  factory BrandModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return BrandModel.empty();
    return BrandModel(
        id: data['Id'] ?? '',
        image: data['Image'] ?? '',
        cover: data['Cover'] ?? '',
        name: data['Name'] ?? '',
        isFeature: data['IsFeature'] ?? false,
        productCount: data['ProductsCount'] ?? data['ProductsCounts'] ?? 0);
  }

  factory BrandModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      if (kDebugMode) {
        print(data);
      }

      return BrandModel(
          id: document.id,
          image: data['Image'] ?? '',
          cover: data['Cover'] ?? '',
          name: data['Name'] ?? '',
          isFeature: data['IsFeature'] ?? false,
          productCount: data['ProductsCount'] ?? data['ProductsCounts'] ?? 0);
    } else {
      return BrandModel.empty();
    }
  }
}
