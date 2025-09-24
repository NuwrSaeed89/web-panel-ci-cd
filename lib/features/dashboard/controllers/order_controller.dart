import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/data/models/order_model.dart';
import 'package:brother_admin_panel/data/repositories/order/order_repository.dart';
import 'package:brother_admin_panel/utils/constants/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final OrderRepository _orderRepository = OrderRepository.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  final RxList<OrderModel> _orders = <OrderModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;
  final Rx<OrderStatus?> _selectedStatus = Rx<OrderStatus?>(null);
  final RxString _errorMessage = ''.obs;

  // Cache for customer names
  final Map<String, String> _customerNamesCache = {};

  // Getters
  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  OrderStatus? get selectedStatus => _selectedStatus.value;
  String get errorMessage => _errorMessage.value;

  // Filtered orders based on search and status
  List<OrderModel> get filteredOrders {
    List<OrderModel> filtered = _orders;

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((order) {
        final query = _searchQuery.value.toLowerCase();
        return order.id.toLowerCase().contains(query) ||
            order.userId.toLowerCase().contains(query) ||
            order.paymentMethod.toLowerCase().contains(query) ||
            order.totalAmount.toString().contains(query);
      }).toList();
    }

    // Filter by status
    if (_selectedStatus.value != null) {
      filtered = filtered
          .where((order) => order.status == _selectedStatus.value)
          .toList();
    }

    return filtered;
  }

  // Order statistics
  int get totalOrders => _orders.length;
  int get processingOrders =>
      _orders.where((order) => order.status == OrderStatus.processing).length;
  int get pendingOrders =>
      _orders.where((order) => order.status == OrderStatus.pending).length;
  int get shippingOrders =>
      _orders.where((order) => order.status == OrderStatus.shipping).length;
  int get deliveredOrders =>
      _orders.where((order) => order.status == OrderStatus.delivered).length;
  double get totalRevenue =>
      _orders.fold(0.0, (total, order) => total + order.totalAmount);

  @override
  void onInit() {
    super.onInit();
    fetchAllOrders();
  }

  // Fetch all orders from all users
  Future<void> fetchAllOrders() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      if (kDebugMode) {
        print('🛒 Fetching all orders...');
      }

      // Fetch all orders using repository
      final allOrders = await _orderRepository.fetchAllOrders();

      // Sort orders by date (newest first)
      allOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

      _orders.assignAll(allOrders);

      if (kDebugMode) {
        print('✅ Successfully fetched ${allOrders.length} orders');
      }
    } catch (e) {
      _errorMessage.value = 'فشل في جلب الطلبات: $e';
      if (kDebugMode) {
        print('❌ Error fetching orders: $e');
      }
    } finally {
      _isLoading.value = false;
    }
  }

  // Update order status
  Future<void> updateOrderStatus(
      String orderId, String userId, OrderStatus newStatus) async {
    try {
      _isLoading.value = true;

      if (kDebugMode) {
        print('📝 Updating order $orderId status to $newStatus');
      }

      await _orderRepository.updateOrderStatus(
          orderId, userId, newStatus.toString());

      // Update local data
      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        final updatedOrder = OrderModel(
          id: _orders[orderIndex].id,
          userId: _orders[orderIndex].userId,
          status: newStatus,
          items: _orders[orderIndex].items,
          totalAmount: _orders[orderIndex].totalAmount,
          orderDate: _orders[orderIndex].orderDate,
          paymentMethod: _orders[orderIndex].paymentMethod,
          address: _orders[orderIndex].address,
          deliveryDate: _orders[orderIndex].deliveryDate,
        );
        _orders[orderIndex] = updatedOrder;
      }

      Get.snackbar(
        'نجح',
        'تم تحديث حالة الطلب بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      if (kDebugMode) {
        print('✅ Order status updated successfully');
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحديث حالة الطلب: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      if (kDebugMode) {
        print('❌ Error updating order status: $e');
      }
    } finally {
      _isLoading.value = false;
    }
  }

  // Search orders
  void searchOrders(String query) {
    _searchQuery.value = query;
  }

  // Filter by status
  void filterByStatus(OrderStatus? status) {
    _selectedStatus.value = status;
  }

  // Clear filters
  void clearFilters() {
    _searchQuery.value = '';
    _selectedStatus.value = null;
  }

  // Refresh orders
  Future<void> refreshOrders() async {
    await fetchAllOrders();
  }

  // Get customer name by user ID with caching
  Future<String> getCustomerName(String userId) async {
    // Return cached name if available
    if (_customerNamesCache.containsKey(userId)) {
      return _customerNamesCache[userId]!;
    }

    try {
      final doc = await _firestore.collection("Users").doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final firstName = data['FirstName'] ?? '';
        final lastName = data['LastName'] ?? '';
        final fullName = '$firstName $lastName'.trim();

        // Cache the name
        _customerNamesCache[userId] =
            fullName.isNotEmpty ? fullName : 'مستخدم غير معروف';
        return _customerNamesCache[userId]!;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching customer name for user $userId: $e');
      }
    }

    // Return default name and cache it
    _customerNamesCache[userId] = 'مستخدم غير معروف';
    return _customerNamesCache[userId]!;
  }

  // Get Arabic status text
  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'قيد المعالجة';
      case OrderStatus.pending:
        return 'في الانتظار';
      case OrderStatus.shipping:
        return 'قيد الشحن';
      case OrderStatus.delivered:
        return 'تم التوصيل';
    }
  }

  // Get status color
  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.pending:
        return Colors.blue;
      case OrderStatus.shipping:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
    }
  }
}
