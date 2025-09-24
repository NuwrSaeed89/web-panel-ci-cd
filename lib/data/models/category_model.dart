import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CategoryModel {
  String id;
  String name;
  String arabicName;
  String image;
  bool isFeature;
  String parentId;
  CategoryModel(
      {required this.id,
      required this.name,
      required this.arabicName,
      required this.image,
      required this.isFeature,
      this.parentId = ''});

  static CategoryModel empty() => CategoryModel(
      id: '', name: '', arabicName: '', image: '', isFeature: false);

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'ArabicName': arabicName,
      'Image': image,
      'ParentId': parentId,
      'IsFeature': isFeature
    };
  }

  factory CategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (kDebugMode) {
      print('🔄 Parsing document: ${document.id}');
      print('📊 Raw document data: ${document.data()}');
    }
    
    if (document.data() != null) {
      final data = document.data()!;
      
      if (kDebugMode) {
        print('📋 Extracting fields from data:');
        print('   - Name: ${data['Name']} (type: ${data['Name']?.runtimeType})');
        print('   - ArabicName: ${data['ArabicName']} (type: ${data['ArabicName']?.runtimeType})');
        print('   - Image: ${data['Image']} (type: ${data['Image']?.runtimeType})');
        print('   - ParentId: ${data['ParentId']} (type: ${data['ParentId']?.runtimeType})');
        print('   - IsFeature: ${data['IsFeature']} (type: ${data['IsFeature']?.runtimeType})');
      }

      final category = CategoryModel(
        id: document.id,
        name: data['Name'] ?? '',
        arabicName: data['ArabicName'] ?? '',
        parentId: data['ParentId'] ?? '',
        image: data['Image'] ?? '',
        isFeature: data['IsFeature'] ?? false,
      );
      
      if (kDebugMode) {
        print('✅ Parsed category:');
        print('   - ID: ${category.id}');
        print('   - Name: ${category.name}');
        print('   - Arabic Name: ${category.arabicName}');
        print('   - Image: ${category.image}');
        print('   - Image is empty: ${category.image.isEmpty}');
        print('   - Image starts with http: ${category.image.startsWith('http')}');
        print('   - Is Feature: ${category.isFeature}');
        print('   - Parent ID: ${category.parentId}');
        print('   ---');
      }
      
      return category;
    }
    
    if (kDebugMode) {
      print('⚠️ Document data is null, returning empty category');
    }
    
    return CategoryModel.empty();
  }
}
