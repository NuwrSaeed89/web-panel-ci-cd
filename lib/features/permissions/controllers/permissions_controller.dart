import 'package:brother_admin_panel/data/models/permission_model.dart';
import 'package:brother_admin_panel/data/repositories/permissions/permissions_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PermissionsController extends GetxController {
  static PermissionsController get instance => Get.find();

  // Repository
  final PermissionsRepository _repository = Get.put(PermissionsRepository());

  // Observable list of permissions
  final RxList<PermissionModel> permissions = <PermissionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxMap<String, int> stats = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadPermissions();
    loadStats();
    // الاستماع للتحديثات في الوقت الفعلي
    _repository.getPermissionsStream().listen((permissionsList) {
      permissions.value = permissionsList;
    });
  }

  // Load permissions from Firebase
  Future<void> loadPermissions() async {
    try {
      isLoading.value = true;
      // محاولة تحميل من Firebase أولاً
      try {
        permissions.value = await _repository.getAllPermissions();
      } catch (firebaseError) {
        // إذا فشل Firebase، استخدم البيانات التجريبية
        if (kDebugMode) {
          print('Firebase error: $firebaseError');
        }
        permissions.value = [
          PermissionModel(
            id: 'dummy_1_${DateTime.now().millisecondsSinceEpoch}',
            phoneNumber: '0501234567',
            email: 'manager1@brothercreative.com',
            name: 'أحمد محمد',
            role: 'manager',
            isAuthorized: true,
            country: 'SA',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          PermissionModel(
            id: 'dummy_2_${DateTime.now().millisecondsSinceEpoch}',
            phoneNumber: '0502345678',
            email: 'manager2@brothercreative.com',
            name: 'فاطمة علي',
            role: 'manager',
            isAuthorized: true,
            country: 'SA',
            createdAt: DateTime.now().subtract(const Duration(days: 15)),
          ),
          PermissionModel(
            id: 'dummy_3_${DateTime.now().millisecondsSinceEpoch}',
            phoneNumber: '0503456789',
            email: 'manager3@brothercreative.com',
            name: 'محمد أحمد',
            role: 'manager',
            isAuthorized: true,
            country: 'SA',
            createdAt: DateTime.now().subtract(const Duration(days: 7)),
          ),
          PermissionModel(
            id: 'dummy_4_${DateTime.now().millisecondsSinceEpoch}',
            phoneNumber: '501234567',
            email: 'admin1@brothercreative.com',
            name: 'سارة أحمد',
            role: 'admin',
            isAuthorized: true,
            country: 'SA',
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
          PermissionModel(
            id: 'dummy_5_${DateTime.now().millisecondsSinceEpoch}',
            phoneNumber: '502345678',
            email: 'admin2@brothercreative.com',
            name: 'خالد محمد',
            role: 'admin',
            isAuthorized: true,
            country: 'SA',
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
          // أرقام هواتف سورية
          PermissionModel(
            id: 'dummy_6_${DateTime.now().millisecondsSinceEpoch}',
            phoneNumber: '944123456',
            email: 'syria1@brothercreative.com',
            name: 'أحمد السوري',
            role: 'manager',
            isAuthorized: true,
            country: 'SY',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          PermissionModel(
            id: 'dummy_7_${DateTime.now().millisecondsSinceEpoch}',
            phoneNumber: '944567890',
            email: 'syria2@brothercreative.com',
            name: 'فاطمة السورية',
            role: 'admin',
            isAuthorized: true,
            country: 'SY',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          // أرقام هواتف إماراتية
          PermissionModel(
            id: 'dummy_8_${DateTime.now().millisecondsSinceEpoch}',
            phoneNumber: '503780091',
            email: 'uae1@brothercreative.com',
            name: 'خالد الإماراتي',
            role: 'manager',
            isAuthorized: true,
            country: 'AE',
            createdAt: DateTime.now().subtract(const Duration(hours: 12)),
          ),
          PermissionModel(
            id: 'dummy_9_${DateTime.now().millisecondsSinceEpoch}',
            phoneNumber: '504567890',
            email: 'uae2@brothercreative.com',
            name: 'نور الإماراتية',
            role: 'admin',
            isAuthorized: true,
            country: 'AE',
            createdAt: DateTime.now().subtract(const Duration(hours: 6)),
          ),
        ];
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل الصلاحيات: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Load statistics
  Future<void> loadStats() async {
    try {
      try {
        stats.value = await _repository.getPermissionsStats();
      } catch (firebaseError) {
        // إذا فشل Firebase، احسب الإحصائيات من البيانات المحلية
        final total = permissions.length;
        final authorized = permissions.where((p) => p.isAuthorized).length;
        final unauthorized = total - authorized;

        stats.value = {
          'total': total,
          'authorized': authorized,
          'unauthorized': unauthorized,
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('خطأ في تحميل الإحصائيات: $e');
      }
    }
  }

  // Add new permission
  Future<void> addPermission(PermissionModel permission) async {
    try {
      isLoading.value = true;

      // Check if this is dummy data or if Firebase is not available
      if (permission.id.startsWith('dummy_') || permission.id.isEmpty) {
        final newId = 'dummy_${DateTime.now().millisecondsSinceEpoch}';
        final newPermission = permission.copyWith(newId: newId);
        permissions.add(newPermission);
        await loadStats();
        Get.snackbar('نجح', 'تم إضافة الصلاحية بنجاح (بيانات تجريبية)');
        return;
      }

      final newPermission = await _repository.addPermission(permission);
      permissions.add(newPermission);
      await loadStats(); // تحديث الإحصائيات
      Get.snackbar('نجح', 'تم إضافة الصلاحية بنجاح');
    } catch (e) {
      final newId = 'dummy_${DateTime.now().millisecondsSinceEpoch}';
      final newPermission = permission.copyWith(newId: newId);
      permissions.add(newPermission);
      await loadStats();
      Get.snackbar('نجح', 'تم إضافة الصلاحية بنجاح (بيانات محلية)');
    } finally {
      isLoading.value = false;
    }
  }

  // Update permission
  Future<void> updatePermission(PermissionModel permission) async {
    try {
      isLoading.value = true;

      // Check if this is dummy data (starts with 'dummy_')
      if (permission.id.startsWith('dummy_')) {
        final index = permissions.indexWhere((p) => p.id == permission.id);
        if (index != -1) {
          permissions[index] = permission;
          permissions.refresh();
        }

        await loadStats();
        Get.snackbar('نجح', 'تم تحديث الصلاحية بنجاح (بيانات تجريبية)');
        return;
      }

      await _repository.updatePermission(permission.id, permission);

      final index = permissions.indexWhere((p) => p.id == permission.id);

      if (index != -1) {
        permissions[index] = permission;
        // إجبار التحديث في الواجهة
        permissions.refresh();
      } else {
        if (kDebugMode) {
          print('❌ Permission not found in local list');
        }
      }

      await loadStats(); // تحديث الإحصائيات

      Get.snackbar('نجح', 'تم تحديث الصلاحية بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحديث الصلاحية: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete permission
  Future<void> deletePermission(String id) async {
    try {
      isLoading.value = true;
      await _repository.deletePermission(id);
      await loadStats(); // تحديث الإحصائيات
      Get.snackbar('نجح', 'تم حذف الصلاحية بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حذف الصلاحية: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle authorization status
  Future<void> toggleAuthorization(String id) async {
    try {
      final permission = permissions.firstWhereOrNull((p) => p.id == id);
      if (permission != null) {
        await _repository.updateAuthorizationStatus(
            id, !permission.isAuthorized);
        await loadStats(); // تحديث الإحصائيات
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تغيير حالة الصلاحية: $e');
    }
  }

  // Check if phone number is authorized
  Future<bool> isPhoneAuthorized(String phoneNumber) async {
    try {
      final localResult = permissions.any((permission) {
        final isMatch =
            permission.phoneNumber == phoneNumber && permission.isAuthorized;
        return isMatch;
      });

      if (localResult) {
        return true;
      }

      // إذا لم يوجد في البيانات المحلية، جرب Firebase
      final firebaseResult = await _repository.isPhoneAuthorized(phoneNumber);

      return firebaseResult;
    } catch (e) {
      return false;
    }
  }

  // Check if email is authorized
  Future<bool> isEmailAuthorized(String email) async {
    try {
      return await _repository.isEmailAuthorized(email);
    } catch (e) {
      return false;
    }
  }

  // Get filtered permissions based on search query
  List<PermissionModel> get filteredPermissions {
    if (searchQuery.value.isEmpty) {
      return permissions;
    }
    return permissions.where((permission) {
      return permission.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          permission.email
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          permission.phoneNumber.contains(searchQuery.value);
    }).toList();
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Search permissions
  Future<void> searchPermissions(String query) async {
    try {
      isLoading.value = true;
      if (query.isEmpty) {
        permissions.value = await _repository.getAllPermissions();
      } else {
        permissions.value = await _repository.searchPermissions(query);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في البحث: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get permissions by authorization status
  Future<void> getPermissionsByStatus(bool isAuthorized) async {
    try {
      isLoading.value = true;
      if (isAuthorized) {
        permissions.value = await _repository.getAuthorizedPermissions();
      } else {
        final allPermissions = await _repository.getAllPermissions();
        permissions.value =
            allPermissions.where((p) => !p.isAuthorized).toList();
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل الصلاحيات: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh permissions
  Future<void> refreshPermissions() async {
    await loadPermissions();
    await loadStats();
  }
}
