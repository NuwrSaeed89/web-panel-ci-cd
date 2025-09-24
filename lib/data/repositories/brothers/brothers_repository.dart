import 'package:brother_admin_panel/data/models/brother_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class BrotherRepository extends GetxController {
  static BrotherRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<BrotherModel>> getAlldata() async {
    try {
      final snapshot = await _db.collection('BrothersCreative').get();
      final list = snapshot.docs.map(BrotherModel.fromSnapshot).toList();
      if (kDebugMode) {
        print("=======data==============");
        print(list.toString());
      }
      return list;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Save brother data
  Future<void> saveBrotherData(BrotherModel brotherData) async {
    try {
      if (kDebugMode) {
        print("💾 Saving brother data...");
      }

      // Check if document exists
      final snapshot = await _db.collection('BrothersCreative').limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        // Update existing document
        await _db
            .collection('BrothersCreative')
            .doc(snapshot.docs.first.id)
            .update(brotherData.toJson());
        if (kDebugMode) {
          print("✅ Updated existing brother data");
        }
      } else {
        // Create new document
        await _db.collection('BrothersCreative').add(brotherData.toJson());
        if (kDebugMode) {
          print("✅ Created new brother data");
        }
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("❌ Error saving brother data: ${e.code}");
      }
      throw e.code;
    }
  }
}
