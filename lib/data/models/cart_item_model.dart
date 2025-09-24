// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:brother_admin_panel/data/models/product_model.dart';

class CartItemModel {
  String productId;
  ProductModel product;
  String title;
  double price;
  String? image;
  int quantity;
  String variationId;
  String? brandName;
  Map<String, String>? selectedVariation;

  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.product,
    this.title = '',
    this.price = 0.0,
    this.image,
    this.variationId = '',
    this.brandName,
    this.selectedVariation,
  });

  static CartItemModel empty() =>
      CartItemModel(productId: '', quantity: 0, product: ProductModel.empty());

  Map<String, dynamic> toJason() {
    return {
      'title': title,
      'productId': productId,
      'product': product.toJson(),
      'image': image,
      'brandName': brandName,
      'selectedVariation': selectedVariation,
      'price': price,
      'variationId': variationId,
      'quantity': quantity
    };
  }

  factory CartItemModel.fromJason(Map<String, dynamic> json) {
    return CartItemModel(
        productId: json['productId'],
        quantity: json['quantity'],
        title: json['title'],
        price: json['price'],
        image: json['image'],
        product: json['product'] != null
            ? ProductModel.fromJson(json['product'])
            : ProductModel.empty(),
        variationId: json['variationId'],
        brandName: json['brandName'],
        selectedVariation: json['selectedVariation'] != null
            ? Map<String, String>.from(json['selectedVariation'])
            : null);
  }
}
