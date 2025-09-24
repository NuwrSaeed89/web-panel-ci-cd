import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brother_admin_panel/data/models/permission_model.dart';
import 'package:get/get.dart';

class PermissionsRepository extends GetxController {
  static PermissionsRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'permissions';

  /// إضافة صلاحية جديدة
  Future<PermissionModel> addPermission(PermissionModel permission) async {
    try {
      final docRef = await _db.collection(_collection).add(permission.toMap());
      return permission.copyWith(newId: docRef.id);
    } catch (e) {
      throw Exception('فشل في إضافة الصلاحية: $e');
    }
  }

  /// الحصول على جميع الصلاحيات
  Future<List<PermissionModel>> getAllPermissions() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs
          .map((doc) => PermissionModel.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('فشل في تحميل الصلاحيات: $e');
    }
  }

  /// الحصول على صلاحية محددة
  Future<PermissionModel?> getPermissionById(String id) async {
    try {
      final doc = await _db.collection(_collection).doc(id).get();
      if (doc.exists) {
        return PermissionModel.fromMap({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {
      throw Exception('فشل في تحميل الصلاحية: $e');
    }
  }

  /// تحديث صلاحية
  Future<void> updatePermission(String id, PermissionModel permission) async {
    try {
      if (id.isEmpty) {
        throw Exception('معرف الصلاحية فارغ');
      }
      await _db.collection(_collection).doc(id).update(permission.toMap());
    } catch (e) {
      throw Exception('فشل في تحديث الصلاحية: $e');
    }
  }

  /// حذف صلاحية
  Future<void> deletePermission(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('فشل في حذف الصلاحية: $e');
    }
  }

  /// البحث في الصلاحيات
  Future<List<PermissionModel>> searchPermissions(String query) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get();

      return querySnapshot.docs
          .map((doc) => PermissionModel.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('فشل في البحث: $e');
    }
  }

  /// الحصول على الصلاحيات المصرح بها فقط
  Future<List<PermissionModel>> getAuthorizedPermissions() async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('isAuthorized', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PermissionModel.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('فشل في تحميل الصلاحيات المصرح بها: $e');
    }
  }

  /// التحقق من صلاحية البريد الإلكتروني
  Future<bool> isEmailAuthorized(String email) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('email', isEqualTo: email)
          .where('isAuthorized', isEqualTo: true)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('فشل في التحقق من صلاحية البريد الإلكتروني: $e');
    }
  }

  /// التحقق من صلاحية رقم الهاتف
  Future<bool> isPhoneAuthorized(String phoneNumber) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .where('isAuthorized', isEqualTo: true)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('فشل في التحقق من صلاحية رقم الهاتف: $e');
    }
  }

  /// الاستماع للتغييرات في الصلاحيات (Real-time updates)
  Stream<List<PermissionModel>> getPermissionsStream() {
    return _db.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => PermissionModel.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    });
  }

  /// الاستماع للصلاحيات المصرح بها فقط
  Stream<List<PermissionModel>> getAuthorizedPermissionsStream() {
    return _db
        .collection(_collection)
        .where('isAuthorized', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PermissionModel.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    });
  }

  /// تحديث حالة الصلاحية فقط
  Future<void> updateAuthorizationStatus(String id, bool isAuthorized) async {
    try {
      await _db.collection(_collection).doc(id).update({
        'isAuthorized': isAuthorized,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('فشل في تحديث حالة الصلاحية: $e');
    }
  }

  /// إحصائيات الصلاحيات
  Future<Map<String, int>> getPermissionsStats() async {
    try {
      final allPermissions = await getAllPermissions();
      final authorizedCount =
          allPermissions.where((p) => p.isAuthorized).length;
      final unauthorizedCount = allPermissions.length - authorizedCount;

      return {
        'total': allPermissions.length,
        'authorized': authorizedCount,
        'unauthorized': unauthorizedCount,
      };
    } catch (e) {
      throw Exception('فشل في تحميل الإحصائيات: $e');
    }
  }
}
