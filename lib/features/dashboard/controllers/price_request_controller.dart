import 'package:brother_admin_panel/data/models/ask_request_model.dart';
import 'package:brother_admin_panel/data/repositories/project/ask_request_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceRequestController extends GetxController {
  static PriceRequestController get instance => Get.find();

  final _askRequestRepository = AskRequestRepository.instance;

  final priceRequests = <AskRequestModel>[].obs;
  final filteredRequests = <AskRequestModel>[].obs;
  final isLoading = false.obs;
  final selectedRequest = Rx<AskRequestModel?>(null);

  // متغيرات التصفية والبحث
  final searchController = TextEditingController();
  final selectedStatus = Rx<String>('all');
  final availableStatuses = <String>[
    'all',
    'pending',
    'accepted',
    'rejected',
    'approved'
  ];

  // Controllers for editing
  final acceptanceStatusController = TextEditingController();
  final proposedPriceController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllPriceRequests();
    // إضافة مستمع للبحث
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.dispose();
    acceptanceStatusController.dispose();
    proposedPriceController.dispose();
    super.onClose();
  }

  // جلب جميع طلبات التسعير
  Future<void> fetchAllPriceRequests() async {
    try {
      isLoading.value = true;
      final requestList = await _askRequestRepository.fetchAllPriceRequests();
      // جلب معلومات المستخدمين لكل طلب
      final List<AskRequestModel> requestsWithUserInfo = [];
      for (final request in requestList) {
        try {
          if (request.uId != null && request.uId!.isNotEmpty) {
            final userInfo =
                await _askRequestRepository.fetchUserDetailsById(request.uId!);
            final updatedRequest = AskRequestModel(
              id: request.id,
              uId: request.uId,
              title: request.title,
              state: request.state,
              description: request.description,
              quantity: request.quantity,
              address: request.address,
              projectCategory: request.projectCategory,
              dateTime: request.dateTime,
              estimatedDate: request.estimatedDate,
              location: request.location,
              files: request.files,
              confirmation: request.confirmation,
              description1: request.description1,
              assembly1: request.assembly1,
              assembly2: request.assembly2,
              company: request.company,
              phoneNumber: request.phoneNumber,
              productionBlueprints: request.productionBlueprints,
              proposedPrice: request.proposedPrice,
              userFullName: userInfo['fullName'] ?? 'مستخدم غير معروف',
              userEmail: userInfo['email'] ?? '',
              userFirstName: userInfo['firstName'] ?? '',
              userLastName: userInfo['lastName'] ?? '',
            );
            requestsWithUserInfo.add(updatedRequest);
          } else {
            requestsWithUserInfo.add(request);
          }
        } catch (e) {
          requestsWithUserInfo.add(request);
        }
      }

      priceRequests.value = requestsWithUserInfo;
      await _filterRequests();
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في جلب طلبات التسعير: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // مستمع تغيير البحث
  void _onSearchChanged() {
    // استدعاء الفلترة مباشرة بدون await
    _filterRequests().catchError((error) {
      if (kDebugMode) {
        print('خطأ في الفلترة: $error');
      }
    });
  }

  // Public method for external calls
  void onSearchChanged() {
    _onSearchChanged();
  }

  // تصفية الطلبات حسب البحث والحالة
  Future<void> _filterRequests() async {
    final searchQuery = searchController.text.toLowerCase().trim();
    final statusFilter = selectedStatus.value;

    if (searchQuery.isEmpty) {
      final filtered = priceRequests.where((request) {
        final matchesStatus =
            statusFilter == 'all' || request.state == statusFilter;

        return matchesStatus;
      }).toList();

      filteredRequests.value = filtered;
      // تحديث الـ UI
      update();
      return;
    }

    // البحث في البيانات المحلية
    final List<AskRequestModel> searchResults = [];

    for (final request in priceRequests) {
      // تصفية حسب الحالة أولاً
      if (statusFilter != 'all' && request.state != statusFilter) {
        continue;
      }

      bool matchesSearch = false;

      // البحث في عنوان الطلب
      if (request.title.toLowerCase().contains(searchQuery)) {
        matchesSearch = true;
      }

      // البحث في وصف الطلب
      if (request.description != null &&
          request.description!.toLowerCase().contains(searchQuery)) {
        matchesSearch = true;
      }

      // البحث في اسم الشركة
      if (request.company != null &&
          request.company!.toLowerCase().contains(searchQuery)) {
        matchesSearch = true;
      }

      if (matchesSearch) {
        searchResults.add(request);
      }
    }

    filteredRequests.value = searchResults;
    // تحديث الـ UI
    update();
  }

  // تغيير حالة التصفية
  Future<void> changeStatusFilter(String status) async {
    selectedStatus.value = status;
    await _filterRequests();
  }

  // مسح البحث
  Future<void> clearSearch() async {
    searchController.clear();
    await _filterRequests();
  }

  // تحديد طلب للعرض
  void selectRequest(AskRequestModel request) {
    selectedRequest.value = request;
    // ملء الحقول للتحرير
    acceptanceStatusController.text = request.state ?? 'pending';
    proposedPriceController.text = request.proposedPrice?.toString() ?? '0';
  }

  // تحديث طلب التسعير
  Future<void> updatePriceRequest() async {
    try {
      if (selectedRequest.value == null) return;

      final request = selectedRequest.value!;

      // تحديث الحقول القابلة للتعديل فقط
      request.state = acceptanceStatusController.text.trim();
      request.proposedPrice =
          double.tryParse(proposedPriceController.text) ?? 0.0;

      await _askRequestRepository.updatePriceRequest(request);

      // تحديث القائمة
      final index = priceRequests.indexWhere((r) => r.id == request.id);
      if (index != -1) {
        priceRequests[index] = request;
        priceRequests.refresh();
        await _filterRequests(); // إعادة تطبيق التصفية
      }

      Get.snackbar(
        'نجح',
        'تم تحديث طلب التسعير بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // إعادة تعيين الطلب المحدد
      selectedRequest.value = null;
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحديث طلب التسعير: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // إعادة تعيين النموذج
  void resetForm() {
    acceptanceStatusController.clear();
    proposedPriceController.clear();
    selectedRequest.value = null;
  }
}
