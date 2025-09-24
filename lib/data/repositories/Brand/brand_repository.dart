import 'package:brother_admin_panel/data/models/brand_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<BrandModel>> fetchBrands() async {
    try {
      if (kDebugMode) {
        print('🔄 BrandRepository: Starting to fetch brands from Firebase...');
      }

      final snapshot = await _db.collection('Brands').get();

      if (kDebugMode) {
        print(
            '📊 BrandRepository: Firebase returned ${snapshot.docs.length} documents');
      }

      if (snapshot.docs.isEmpty) {
        if (kDebugMode) {
          print(
              '📝 BrandRepository: No brands found in Firebase, returning sample data');
        }
        // إضافة بيانات تجريبية إذا لم تكن هناك بيانات
        return [
          BrandModel(
            id: '1',
            name: 'أبل',
            image:
                'https://via.placeholder.com/300x200/007AFF/FFFFFF?text=Apple',
            cover:
                'https://via.placeholder.com/800x400/007AFF/FFFFFF?text=Apple+Cover',
            productCount: 15,
            isFeature: true,
          ),
          BrandModel(
            id: '2',
            name: 'سامسونج',
            image:
                'https://via.placeholder.com/300x200/1428A0/FFFFFF?text=Samsung',
            cover:
                'https://via.placeholder.com/800x400/1428A0/FFFFFF?text=Samsung+Cover',
            productCount: 23,
            isFeature: false,
          ),
          BrandModel(
            id: '3',
            name: 'نوكيا',
            image:
                'https://via.placeholder.com/300x200/124191/FFFFFF?text=Nokia',
            cover:
                'https://via.placeholder.com/800x400/124191/FFFFFF?text=Nokia+Cover',
            productCount: 8,
            isFeature: true,
          ),
        ];
      }

      final brands = snapshot.docs.map(BrandModel.fromSnapshot).toList();
      if (kDebugMode) {
        print(
            '✅ BrandRepository: Successfully parsed ${brands.length} brands from Firebase');
        for (int i = 0; i < brands.length; i++) {
          final brand = brands[i];
          print('📋 Brand ${i + 1}: ID=${brand.id}, Name="${brand.name}"');
        }
      }

      return brands;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ BrandRepository: FirebaseException: $e');
      }
      // في حالة الخطأ، نعيد بيانات تجريبية
      return [
        BrandModel(
          id: '1',
          name: 'أبل',
          image: 'https://via.placeholder.com/300x200/007AFF/FFFFFF?text=Apple',
          cover:
              'https://via.placeholder.com/800x400/007AFF/FFFFFF?text=Apple+Cover',
          productCount: 15,
          isFeature: true,
        ),
        BrandModel(
          id: '2',
          name: 'سامسونج',
          image:
              'https://via.placeholder.com/300x200/1428A0/FFFFFF?text=Samsung',
          cover:
              'https://via.placeholder.com/800x400/1428A0/FFFFFF?text=Samsung+Cover',
          productCount: 23,
          isFeature: false,
        ),
        BrandModel(
          id: '3',
          name: 'نوكيا',
          image: 'https://via.placeholder.com/300x200/124191/FFFFFF?text=Nokia',
          cover:
              'https://via.placeholder.com/800x400/124191/FFFFFF?text=Nokia+Cover',
          productCount: 8,
          isFeature: true,
        ),
      ];
    } catch (e) {
      if (kDebugMode) {
        print('❌ BrandRepository: General error: $e');
      }
      // في حالة أي خطأ آخر، نعيد بيانات تجريبية
      return [
        BrandModel(
          id: '1',
          name: 'أبل',
          image: 'https://via.placeholder.com/300x200/007AFF/FFFFFF?text=Apple',
          cover:
              'https://via.placeholder.com/800x400/007AFF/FFFFFF?text=Apple+Cover',
          productCount: 15,
          isFeature: true,
        ),
        BrandModel(
          id: '2',
          name: 'سامسونج',
          image:
              'https://via.placeholder.com/300x200/1428A0/FFFFFF?text=Samsung',
          cover:
              'https://via.placeholder.com/800x400/1428A0/FFFFFF?text=Samsung+Cover',
          productCount: 23,
          isFeature: false,
        ),
        BrandModel(
          id: '3',
          name: 'نوكيا',
          image: 'https://via.placeholder.com/300x200/124191/FFFFFF?text=Nokia',
          cover:
              'https://via.placeholder.com/800x400/124191/FFFFFF?text=Nokia+Cover',
          productCount: 8,
          isFeature: true,
        ),
      ];
    }
  }

  Future<List<BrandModel>> getBrandForCategory(String categoryId) async {
    try {
      final QuerySnapshot brandCategoryQuery = await _db
          .collection('BrandCategory')
          .where('CategoryId', isEqualTo: categoryId)
          .get();
      final List<String> brandIds = brandCategoryQuery.docs
          .map((doc) => doc['BrandId'] as String)
          .toList();
      final brandQuery = await _db
          .collection('Brands')
          .where(FieldPath.documentId, whereIn: brandIds)
          .limit(4)
          .get();
      final List<BrandModel> brands =
          brandQuery.docs.map(BrandModel.fromSnapshot).toList();
      return brands;
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      throw (e.toString());
    }
  }

  // Create new brand
  Future<String> createBrand(BrandModel brand) async {
    try {
      final docRef = await _db.collection('Brands').add(brand.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Update existing brand
  Future<void> updateBrand(BrandModel brand) async {
    try {
      await _db.collection('Brands').doc(brand.id).update(brand.toJson());
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Delete brand
  Future<void> deleteBrand(String brandId) async {
    try {
      await _db.collection('Brands').doc(brandId).delete();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Get brands count
  Future<int> getBrandsCount() async {
    try {
      final snapshot = await _db.collection('Brands').get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Search brands
  Future<List<BrandModel>> searchBrands(String query) async {
    try {
      final snapshot = await _db
          .collection('Brands')
          .where('Name', isGreaterThanOrEqualTo: query)
          .where('Name', isLessThan: '$query\uf8ff')
          .get();

      return snapshot.docs.map(BrandModel.fromSnapshot).toList();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }
}
