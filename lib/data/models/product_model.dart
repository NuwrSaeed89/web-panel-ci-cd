import 'package:brother_admin_panel/data/models/brand_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ProductModel {
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  String arabicTitle;
  double salePrice;
  String thumbnail;
  bool? isFeature;
  BrandModel? brand;
  String? description;
  String? arabicDescription;
  String? categoryId;
  List<String>? images;
  String productType;

  ProductModel({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.price,
    required this.thumbnail,
    required this.productType,
    required this.stock,
    this.sku,
    this.brand,
    this.images,
    this.salePrice = 0.0,
    this.isFeature,
    this.description,
    this.arabicDescription,
    this.categoryId,
  });

  toJson() {
    return {
      'Id': id,
      'SKU': sku ?? '',
      'Title': title,
      'ArabicTitle': arabicTitle,
      'Thumbnail': thumbnail,
      'ProductType': productType,
      'IsFeature': isFeature,
      'Description': description ?? '',
      'ArabicDescription': arabicDescription ?? '',
      'Brand': brand?.toJson() ?? {},
      'Images': images ?? [],
      'Price': price,
      'SalePrice': salePrice,
      'CategoryId': categoryId,
      'Stock': stock,
    };
  }

  static ProductModel empty() => ProductModel(
        id: '',
        title: '',
        arabicTitle: '',
        productType: '',
        thumbnail: '',
        stock: 0,
        price: 0,
      );

  factory ProductModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() == null) return ProductModel.empty();
    final data = document.data()!;

    return ProductModel(
      id: document.id, // Use document.id instead of data['Id']
      title: data['Title'] ?? '',
      arabicTitle: data['ArabicTitle'] ?? '',
      description: data['Description'],
      arabicDescription: data['ArabicDescription'],
      thumbnail: data['Thumbnail'] ?? '',
      productType: data['ProductType'] ?? '',
      sku: data['SKU'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      isFeature: data['IsFeature'] ?? false,
      price: double.parse((data['Price'] ?? 0.0).toString()),
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],

      stock: data['Stock'] ?? 0,
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      // productAtributes: (data['ProductAttributs'] as List<dynamic>)
      //     .map((e) => ProductAtributeModel.fromJason(e))
      //     .toList(),
      // productVariations: (data['ProductVariations'] as List<dynamic>)
      //     .map((e) => ProductVariationModel.fromJason(e))
      //     .toList()
    );
  }

  factory ProductModel.fromQuerySnapshot(
    QueryDocumentSnapshot<Object?> document,
  ) {
    if (document.data() == null) return ProductModel.empty();
    final data = document.data() as Map<String, dynamic>;
    if (kDebugMode) {
      print(data);
    }
    return ProductModel(
      id: document.id,
      title: data['Title'] ?? '',
      arabicTitle: data['ArabicTitle'] ?? '',
      description: data['Description'],
      arabicDescription: data['ArabicDescription'],
      thumbnail: data['Thumbnail'] ?? '',
      productType: data['ProductType'] ?? '',
      sku: data['SKU'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      isFeature: data['IsFeature'] ?? false,
      price: double.parse((data['Price'] ?? 0.0).toString()),
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      stock: data['Stock'] ?? 0,
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      // productAtributes: (data['ProductAttributs'] as List<dynamic>?)
      //     ?.map((e) => ProductAtributeModel.fromJson(e))
      //     .toList(),
      // productVariations: (data['ProductVariations'] as List<dynamic>?)
      //     ?.map((e) => ProductVariationModel.fromJson(e))
      //     .toList(),
      //     .map((e) => ProductVariationModel.fromJason(e))
      //     .toList()
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> data) {
    return ProductModel(
      id: data['Id'] ?? '',
      sku: data['SKU'] ?? '',
      title: data['Title'] ?? '',
      arabicTitle: data['ArabicTitle'] ?? '',
      thumbnail: data['Thumbnail'] ?? '',
      productType: data['ProductType'] ?? '',
      isFeature: data['IsFeature'] ?? false,
      description: data['Description'] ?? '',
      arabicDescription: data['ArabicDescription'] ?? '',
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      price: double.parse((data['Price'] ?? 0.0).toString()),
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      categoryId: data['CategoryId'],
      stock: data['Stock'] ?? 0,
    );
  }
}
