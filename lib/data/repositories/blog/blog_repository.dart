import 'package:brother_admin_panel/data/models/blog_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class BlogRepository extends GetxController {
  static BlogRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  // دالة لمعالجة editTime سواء كان int أو Timestamp
  DateTime? _parseEditTime(dynamic editTime) {
    if (editTime == null) return null;

    if (editTime is int) {
      // إذا كان int (timestamp)
      return DateTime.fromMillisecondsSinceEpoch(editTime);
    } else if (editTime is Timestamp) {
      // إذا كان Timestamp
      return editTime.toDate();
    } else {
      // محاولة تحويل إلى int
      try {
        final intValue = int.parse(editTime.toString());
        return DateTime.fromMillisecondsSinceEpoch(intValue);
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error parsing editTime: $editTime, error: $e');
        }
        return null;
      }
    }
  }

  Future<String> addBolg(BlogModel blog) async {
    try {
      await _db.collection('Blog').add(blog.toJson());

      return 'added succesfully';
    } catch (e) {
      throw 'Some thing wrong while saving Blog';
    }
  }

  Future<List<BlogModel>> fetchBlog() async {
    try {
      final snapshot = await _db.collection("Blog").get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        // إنشاء BlogModel مباشرة من البيانات
        return BlogModel(
          data['id'] ?? doc.id,
          data['title'] ?? '',
          data['arabicTitle'] ?? '',
          data['auther'] ?? '',
          data['arabicAuther'] ?? '',
          data['details'] ?? '',
          data['arabicDetails'] ?? '',
          data['Active'] ?? true,
          data['images'] != null ? List<String>.from(data['images']) : [],
          data['editTime'] != null ? _parseEditTime(data['editTime']) : null,
        );
      }).toList();
    } catch (e) {
      throw 'Something wrong while fetch Blog data: $e';
    }
  }

  Future<void> updateBlog(BlogModel blog) async {
    try {
      await _db.collection('Blog').doc(blog.id).update(blog.toJson());
    } catch (e) {
      throw 'Something wrong while updating Blog';
    }
  }

  Future<void> deleteBlog(String blogId) async {
    try {
      await _db.collection('Blog').doc(blogId).delete();
    } catch (e) {
      throw 'Something wrong while deleting Blog';
    }
  }

  Future<BlogModel?> getBlogById(String blogId) async {
    try {
      final doc = await _db.collection('Blog').doc(blogId).get();
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;

        return BlogModel(
          data['id'] ?? doc.id,
          data['title'] ?? '',
          data['arabicTitle'] ?? '',
          data['auther'] ?? '',
          data['arabicAuther'] ?? '',
          data['details'] ?? '',
          data['arabicDetails'] ?? '',
          data['Active'] ?? true,
          data['images'] != null ? List<String>.from(data['images']) : [],
          data['editTime'] != null ? _parseEditTime(data['editTime']) : null,
        );
      }
      return null;
    } catch (e) {
      throw 'Something wrong while getting Blog by ID: $e';
    }
  }
}
