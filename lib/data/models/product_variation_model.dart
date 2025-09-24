class ProductVariationModel {
  final String id;
  String sku;
  String image;
  double price;
  double salePrice;
  int stock;
  Map<String, String> atributeValues;

  ProductVariationModel(
      {required this.id,
      this.sku = '',
      this.image = '',
      this.price = 0.0,
      this.salePrice = 0.0,
      this.stock = 0,
      required this.atributeValues});
  toJason() {
    return {
      'Id': id,
      'SKU': sku,
      'Image': image,
      'SalePrice': salePrice,
      'Price': price,
      'Stock': stock,
      'AtributeValues': atributeValues
    };
  }

  static ProductVariationModel empty() =>
      ProductVariationModel(id: '', atributeValues: {});
  factory ProductVariationModel.fromJason(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductVariationModel.empty();

    return ProductVariationModel(
      id: data['Id'] ?? '',
      sku: data['SKU'] ?? '',
      price: double.parse((data['Price'] ?? 0.0).toString()),
      image: data['Image'] ?? '',
      stock: data['Stock'] ?? 0,
      atributeValues: Map<String, String>.from(data['AtributeValues']),
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
    );
  }
}
