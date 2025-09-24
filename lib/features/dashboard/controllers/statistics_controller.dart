import 'package:brother_admin_panel/features/dashboard/controllers/blog_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/category_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/product_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/order_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/project_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/price_request_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/clients_controller.dart';

class StatisticsController extends GetxController {
  static StatisticsController get instance => Get.find();

  // Observable variables for statistics
  final RxInt _totalBlogs = 0.obs;
  final RxInt _totalCategories = 0.obs;
  final RxInt _totalProducts = 0.obs;
  final RxInt _totalOrders = 0.obs;
  final RxInt _totalProjects = 0.obs;
  final RxInt _totalPriceRequests = 0.obs;
  final RxInt _totalClients = 0.obs;
  final RxBool _isLoading = false.obs;

  // Getters
  int get totalBlogs => _totalBlogs.value;
  int get totalCategories => _totalCategories.value;
  int get totalProducts => _totalProducts.value;
  int get totalOrders => _totalOrders.value;
  int get totalProjects => _totalProjects.value;
  int get totalPriceRequests => _totalPriceRequests.value;
  int get totalClients => _totalClients.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadStatistics();

    // Listen to changes in other controllers
    _setupListeners();
  }

  // Setup listeners for automatic updates
  void _setupListeners() {
    try {
      // Listen to blog changes
      final blogController = Get.find<BlogController>();
      ever(blogController.blogs.obs, (_) => _loadBlogStatistics());

      // Listen to category changes
      final categoryController = Get.find<CategoryController>();
      ever(categoryController.categories.obs, (_) => _loadCategoryStatistics());

      // Listen to product changes
      final productController = Get.find<ProductController>();
      ever(productController.products.obs, (_) => _loadProductStatistics());

      // Listen to order changes
      final orderController = Get.find<OrderController>();
      ever(orderController.orders.obs, (_) => _loadOrderStatistics());

      // Listen to project changes
      final projectController = Get.find<ProjectController>();
      ever(projectController.projects.obs, (_) => _loadProjectStatistics());

      // Listen to price request changes
      final priceRequestController = Get.find<PriceRequestController>();
      ever(priceRequestController.priceRequests.obs,
          (_) => _loadPriceRequestStatistics());

      // Listen to client changes
      final clientsController = Get.find<ClientsController>();
      ever(clientsController.clients.obs, (_) => _loadClientStatistics());
    } catch (e) {
      if (kDebugMode) {
        print('Error setting up statistics listeners: $e');
      }
    }
  }

  // Load all statistics
  Future<void> loadStatistics() async {
    try {
      _isLoading.value = true;

      // Load statistics from all controllers
      await _loadBlogStatistics();
      await _loadCategoryStatistics();
      await _loadProductStatistics();
      await _loadOrderStatistics();
      await _loadProjectStatistics();
      await _loadPriceRequestStatistics();
      await _loadClientStatistics();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading statistics: $e');
      }
    } finally {
      _isLoading.value = false;
    }
  }

  // Load blog statistics
  Future<void> _loadBlogStatistics() async {
    try {
      final blogController = Get.find<BlogController>();
      if (blogController.blogs.isNotEmpty) {
        _totalBlogs.value = blogController.blogs.length;
      } else {
        // If controller doesn't have data, load it first
        await blogController.fetchBlogs();
        _totalBlogs.value = blogController.blogs.length;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading blog statistics: $e');
      }
      _totalBlogs.value = 0;
    }
  }

  // Load category statistics
  Future<void> _loadCategoryStatistics() async {
    try {
      final categoryController = Get.find<CategoryController>();
      if (categoryController.categories.isNotEmpty) {
        _totalCategories.value = categoryController.categories.length;
      } else {
        // If controller doesn't have data, load it first
        await categoryController.loadCategories();
        _totalCategories.value = categoryController.categories.length;
      }
    } catch (e) {
      _totalCategories.value = 0;
    }
  }

  // Load product statistics
  Future<void> _loadProductStatistics() async {
    try {
      final productController = Get.find<ProductController>();
      _totalProducts.value = productController.products.length;
    } catch (e) {
      _totalProducts.value = 0;
    }
  }

  // Load order statistics
  Future<void> _loadOrderStatistics() async {
    try {
      final orderController = Get.find<OrderController>();
      _totalOrders.value = orderController.orders.length;
    } catch (e) {
      _totalOrders.value = 0;
    }
  }

  // Load project statistics
  Future<void> _loadProjectStatistics() async {
    try {
      final projectController = Get.find<ProjectController>();
      _totalProjects.value = projectController.projects.length;
    } catch (e) {
      _totalProjects.value = 0;
    }
  }

  // Load price request statistics
  Future<void> _loadPriceRequestStatistics() async {
    try {
      final priceRequestController = Get.find<PriceRequestController>();
      _totalPriceRequests.value = priceRequestController.priceRequests.length;
    } catch (e) {
      _totalPriceRequests.value = 0;
    }
  }

  // Load client statistics
  Future<void> _loadClientStatistics() async {
    try {
      final clientsController = Get.find<ClientsController>();
      _totalClients.value = clientsController.clients.length;
    } catch (e) {
      _totalClients.value = 0;
    }
  }

  // Refresh all statistics
  Future<void> refreshStatistics() async {
    await loadStatistics();
  }

  // Update statistics when dashboard tab is opened
  void onDashboardTabOpened() {
    refreshStatistics();
  }

  // Force update specific statistics
  void updateBlogStatistics() => _loadBlogStatistics();
  void updateCategoryStatistics() => _loadCategoryStatistics();
  void updateProductStatistics() => _loadProductStatistics();
  void updateOrderStatistics() => _loadOrderStatistics();
  void updateProjectStatistics() => _loadProjectStatistics();
  void updatePriceRequestStatistics() => _loadPriceRequestStatistics();
  void updateClientStatistics() => _loadClientStatistics();

  // Get statistics map
  Map<String, int> getStatisticsMap() {
    return {
      'blogs': _totalBlogs.value,
      'categories': _totalCategories.value,
      'products': _totalProducts.value,
      'orders': _totalOrders.value,
      'projects': _totalProjects.value,
      'priceRequests': _totalPriceRequests.value,
      'clients': _totalClients.value,
    };
  }
}
