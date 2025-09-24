import 'package:brother_admin_panel/data/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<ProductModel>> getFeaturesProducts() async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('IsFeature', isEqualTo: true)
          .limit(4)
          .get();
      return snapshot.docs.map(ProductModel.fromSnapshot).toList();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<List<ProductModel>> getAllFeaturesProducts() async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('IsFeature', isEqualTo: true)
          // .limit(4)
          .get();

      return snapshot.docs.map(ProductModel.fromSnapshot).toList();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<List<ProductModel>> fetchProductsByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();
      final List<ProductModel> productList =
          querySnapshot.docs.map(ProductModel.fromQuerySnapshot).toList();
      return productList;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<List<ProductModel>> getAllProductsByIds(
      List<String> productIds) async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();
      return snapshot.docs.map(ProductModel.fromSnapshot).toList();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<List<ProductModel>> getProductsbyIds(List<String> productIds) async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();
      return snapshot.docs.map(ProductModel.fromSnapshot).toList();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<List<ProductModel>> gstProductsForBrand(
      {required String brandId, int limit = -1}) async {
    try {
      final querySnapshot = limit == -1
          ? await _db
              .collection('Products')
              .where('Brand.Id', isEqualTo: brandId)
              .get()
          : await _db
              .collection('Products')
              .where('Brand.Id', isEqualTo: brandId)
              .limit(limit)
              .get();
      final products =
          querySnapshot.docs.map(ProductModel.fromSnapshot).toList();
      return products;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Get products count for a specific brand
  Future<int> getProductsCountForBrand(String brandId) async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('Brand.Id', isEqualTo: brandId)
          .get();

      if (kDebugMode) {
        print(
            '📊 ProductRepository: Found ${snapshot.docs.length} products for brand $brandId');
      }

      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Error getting products count for brand $brandId: ${e.code}');
      }
      return 0;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting products count for brand $brandId: $e');
      }
      return 0;
    }
  }

  // Get products count for multiple brands
  Future<Map<String, int>> getProductsCountForBrands(
      List<String> brandIds) async {
    try {
      final Map<String, int> brandProductCounts = {};

      // Process brands in batches to avoid Firestore query limits
      const batchSize = 10;
      for (int i = 0; i < brandIds.length; i += batchSize) {
        final batch = brandIds.skip(i).take(batchSize).toList();

        // Create parallel queries for the batch
        final futures = batch.map((brandId) async {
          final count = await getProductsCountForBrand(brandId);
          return MapEntry(brandId, count);
        });

        final results = await Future.wait(futures);
        brandProductCounts.addAll(Map.fromEntries(results));
      }

      if (kDebugMode) {
        print(
            '📊 ProductRepository: Products count for brands: $brandProductCounts');
      }

      return brandProductCounts;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting products count for brands: $e');
      }
      return {};
    }
  }

  Future<List<ProductModel>> getProductsForCategory(
      {required String categoryId, int limit = 4}) async {
    try {
      final QuerySnapshot productCategoryQuery = limit == -1
          ? await _db
              .collection('ProductCategory')
              .where('CategoryId', isEqualTo: categoryId)
              .get()
          : await _db
              .collection('ProductCategory')
              .where('CategoryId', isEqualTo: categoryId)
              .limit(limit)
              .get();

      final List<String> productIds = productCategoryQuery.docs
          .map((doc) => doc['ProductId'] as String)
          .toList();
      if (productIds.isEmpty) return [];
      final productQuery = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();
      final List<ProductModel> products =
          productQuery.docs.map(ProductModel.fromSnapshot).toList();
      return products;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  Future<bool> addProducts(ProductModel product) async {
    try {
      final currentproduct =
          await _db.collection('Products').add(product.toJson());
      if (kDebugMode) {
        print('currentproduct $currentproduct.id');
      }
      product.id = currentproduct.id;
      _db
          .collection("Products")
          .doc(currentproduct.id)
          .update(product.toJson());
      return true;
    } catch (e) {
      throw 'Some thing wrong while saving product';
    }
  }

  // UPDATE - Update existing product
  Future<bool> updateProduct(ProductModel product) async {
    try {
      if (kDebugMode) {
        print('🔄 Repository: Starting updateProduct...');
        print('   - Product ID: ${product.id}');
        print('   - Product Title: ${product.title}');
        print('   - Product Price: ${product.price}');
        print('   - JSON to update: ${product.toJson()}');
      }

      // Check if document exists first
      final docRef = _db.collection('Products').doc(product.id);
      final docSnapshot = await docRef.get();

      if (kDebugMode) {
        print('📋 Document exists: ${docSnapshot.exists}');
        if (docSnapshot.exists) {
          print('📋 Current document data: ${docSnapshot.data()}');
        }
      }

      if (!docSnapshot.exists) {
        if (kDebugMode) {
          print('❌ Document does not exist in Firebase');
        }
        throw "Product with ID ${product.id} does not exist in Firebase";
      }

      await docRef.update(product.toJson());

      if (kDebugMode) {
        print('✅ Product updated successfully in Firebase');
      }

      return true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error updating product: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw 'Firebase error: ${e.message}';
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating product: $e');
        print('❌ Error type: ${e.runtimeType}');
      }
      throw 'Update error: $e';
    }
  }

  // DELETE - Delete product
  Future<bool> deleteProduct(String productId) async {
    try {
      if (kDebugMode) {
        print('🔄 Repository: Starting deleteProduct...');
        print('   - Product ID: $productId');
      }

      // Check if document exists first
      final docRef = _db.collection('Products').doc(productId);
      final docSnapshot = await docRef.get();

      if (kDebugMode) {
        print('📋 Document exists: ${docSnapshot.exists}');
        if (docSnapshot.exists) {
          print('📋 Current document data: ${docSnapshot.data()}');
        }
      }

      if (!docSnapshot.exists) {
        if (kDebugMode) {
          print('❌ Document does not exist in Firebase');
        }
        throw "Product with ID $productId does not exist in Firebase";
      }

      await docRef.delete();

      if (kDebugMode) {
        print('✅ Product deleted successfully from Firebase');
      }

      return true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error deleting product: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw 'Firebase error: ${e.message}';
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting product: $e');
        print('❌ Error type: ${e.runtimeType}');
      }
      throw 'Delete error: $e';
    }
  }
  // getFavoritesProducts(List<String> list) {

  //       try {
  //     final snapshot = _db
  //         .collection('Products')
  //         .where(FieldPath.documentId, whereIn: list)
  //         .get();
  //     final t = snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
  //     return t;
  //   } on FirebaseException catch (e) {
  //     throw e.code;
  //   }
  // }
}
