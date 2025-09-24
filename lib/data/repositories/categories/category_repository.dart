import 'package:brother_admin_panel/data/models/category_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  // CREATE - Add new category
  Future<String> createCategory(CategoryModel category) async {
    try {
      if (kDebugMode) {
        print("Creating category: ${category.name}");
      }

      final docRef = await _db.collection('Categories').add(category.toJson());

      if (kDebugMode) {
        print("Category created with ID: ${docRef.id}");
      }

      return docRef.id;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Firebase error creating category: ${e.code}");
      }
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print("Error creating category: $e");
      }
      throw e.toString();
    }
  }

  // READ - Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      if (kDebugMode) {
        print('🔄 Starting to fetch categories from Firestore...');
        print('📊 Collection path: Categories');
      }

      final snapshot = await _db.collection('Categories').get();

      if (kDebugMode) {
        print('✅ Firestore query completed');
        print('📊 Raw documents count: ${snapshot.docs.length}');
        print(
            '📊 Raw documents: ${snapshot.docs.map((doc) => doc.data()).toList()}');
      }

      final list = snapshot.docs.map((document) {
        if (kDebugMode) {
          print('📋 Processing document:');
          print('   - Document ID: ${document.id}');
          print('   - Raw data: ${document.data()}');
        }

        final category = CategoryModel.fromSnapshot(document);

        if (kDebugMode) {
          print('   - Parsed category:');
          print('     * ID: ${category.id}');
          print('     * Name: ${category.name}');
          print('     * Arabic Name: ${category.arabicName}');
          print('     * Image URL: ${category.image}');
          print('     * Image is empty: ${category.image.isEmpty}');
          print(
              '     * Image starts with http: ${category.image.startsWith('http')}');
          print('     * Is Feature: ${category.isFeature}');
          print('     * Parent ID: ${category.parentId}');
          print('   ---');
        }

        return category;
      }).toList();

      if (kDebugMode) {
        print('✅ Categories parsing completed');
        print('📊 Final parsed categories count: ${list.length}');
        print('📊 All image URLs: ${list.map((c) => c.image).toList()}');
      }

      return list;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error getting categories: ${e.code}');
        print('❌ Firebase error message: ${e.message}');
      }
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting categories: $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: ${StackTrace.current}');
      }
      throw e.toString();
    }
  }

  // READ - Get category by ID
  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      if (kDebugMode) {
        print("Getting category by ID: $categoryId");
      }

      final doc = await _db.collection('Categories').doc(categoryId).get();

      if (doc.exists) {
        return CategoryModel.fromSnapshot(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Firebase error getting category by ID: ${e.code}");
      }
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting category by ID: $e");
      }
      throw e.toString();
    }
  }

  // UPDATE - Update existing category
  Future<bool> updateCategory(CategoryModel category) async {
    try {
      if (kDebugMode) {
        print("🔄 Repository: Starting updateCategory...");
        print("   - Category ID: ${category.id}");
        print("   - Category Name: ${category.name}");
        print("   - Category Arabic Name: ${category.arabicName}");
        print("   - Category Image: ${category.image}");
        print("   - Category Is Feature: ${category.isFeature}");
        print("   - Category Parent ID: ${category.parentId}");
        print("   - JSON to update: ${category.toJson()}");
      }

      // Check if document exists first
      final docRef = _db.collection('Categories').doc(category.id);
      final docSnapshot = await docRef.get();

      if (kDebugMode) {
        print("📋 Document exists: ${docSnapshot.exists}");
        if (docSnapshot.exists) {
          print("📋 Current document data: ${docSnapshot.data()}");
        }
      }

      if (!docSnapshot.exists) {
        if (kDebugMode) {
          print("❌ Document does not exist in Firebase");
        }
        throw "Category with ID ${category.id} does not exist in Firebase";
      }

      await docRef.update(category.toJson());

      if (kDebugMode) {
        print("✅ Repository: Category updated successfully in Firebase");
      }

      return true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("❌ Repository: Firebase error updating category: ${e.code}");
        print("❌ Repository: Firebase error message: ${e.message}");
      }
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Repository: Error updating category: $e");
        print("❌ Repository: Error type: ${e.runtimeType}");
      }
      throw e.toString();
    }
  }

  // DELETE - Delete category
  Future<bool> deleteCategory(String categoryId) async {
    try {
      if (kDebugMode) {
        print("🗑️ Repository: Starting deleteCategory...");
        print("   - Category ID: $categoryId");
      }

      // Check if document exists first
      final docRef = _db.collection('Categories').doc(categoryId);
      final docSnapshot = await docRef.get();

      if (kDebugMode) {
        print("📋 Document exists: ${docSnapshot.exists}");
        if (docSnapshot.exists) {
          print("📋 Current document data: ${docSnapshot.data()}");
        }
      }

      if (!docSnapshot.exists) {
        if (kDebugMode) {
          print("❌ Document does not exist in Firebase");
        }
        throw "Category with ID $categoryId does not exist in Firebase";
      }

      // Check if category has subcategories
      final subCategories = await getSubCategories(categoryId);
      if (kDebugMode) {
        print("🔍 Subcategories found: ${subCategories.length}");
      }

      if (subCategories.isNotEmpty) {
        if (kDebugMode) {
          print("❌ Cannot delete category with subcategories");
        }
        throw "Cannot delete category with subcategories. Please delete subcategories first.";
      }

      await docRef.delete();

      if (kDebugMode) {
        print("✅ Repository: Category deleted successfully from Firebase");
      }

      return true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("❌ Repository: Firebase error deleting category: ${e.code}");
        print("❌ Repository: Firebase error message: ${e.message}");
      }
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Repository: Error deleting category: $e");
        print("❌ Repository: Error type: ${e.runtimeType}");
      }
      throw e.toString();
    }
  }

  // READ - Get subcategories
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    if (kDebugMode) {
      print("=======category id=========");
      print(categoryId);
    }

    try {
      final snapshot = await _db
          .collection("Categories")
          .where('ParentId', isEqualTo: categoryId)
          .get();
      final result = snapshot.docs.map(CategoryModel.fromSnapshot).toList();
      if (kDebugMode) {
        print("=======data= subcategory=============");
        print(result);
      }
      return result;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Firebase error getting subcategories: ${e.code}");
      }
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting subcategories: $e");
      }
      throw e.toString();
    }
  }

  // READ - Get categories for brand
  Future<List<CategoryModel>> getCategoryForBrand(String brandId) async {
    try {
      final QuerySnapshot brandCategoryQuery = await _db
          .collection('BrandCategory')
          .where('BrandId', isEqualTo: brandId)
          .get();
      final List<String> brandIds = brandCategoryQuery.docs
          .map((doc) => doc['CategoryId'] as String)
          .toList();
      final brandQuery = await _db
          .collection('Categories')
          .where(FieldPath.documentId, whereIn: brandIds)
          .limit(4)
          .get();
      final List<CategoryModel> brands =
          brandQuery.docs.map(CategoryModel.fromSnapshot).toList();
      return brands;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Firebase error getting categories for brand: ${e.code}");
      }
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting categories for brand: $e");
      }
      throw (e.toString());
    }
  }

  // SEARCH - Search categories by name
  Future<List<CategoryModel>> searchCategories(String query) async {
    try {
      if (kDebugMode) {
        print("Searching categories with query: $query");
      }

      // Note: Firestore doesn't support full-text search natively
      // This is a simple prefix search implementation
      // For production, consider using Algolia or similar service

      final snapshot = await _db
          .collection('Categories')
          .where('Name', isGreaterThanOrEqualTo: query)
          .where('Name', isLessThan: '$query\uf8ff')
          .get();

      final results = snapshot.docs.map(CategoryModel.fromSnapshot).toList();

      if (kDebugMode) {
        print("Search results: ${results.length} categories found");
      }

      return results;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Firebase error searching categories: ${e.code}");
      }
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print("Error searching categories: $e");
      }
      throw e.toString();
    }
  }

  // UTILITY - Check if category exists
  Future<bool> categoryExists(String categoryId) async {
    try {
      final doc = await _db.collection('Categories').doc(categoryId).get();
      return doc.exists;
    } catch (e) {
      if (kDebugMode) {
        print("Error checking if category exists: $e");
      }
      return false;
    }
  }

  // UTILITY - Get categories count
  Future<int> getCategoriesCount() async {
    try {
      final snapshot = await _db.collection('Categories').get();
      return snapshot.docs.length;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting categories count: $e");
      }
      return 0;
    }
  }
}
