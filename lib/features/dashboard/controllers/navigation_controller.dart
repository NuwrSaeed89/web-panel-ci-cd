import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();

  // Tab indices mapping
  static const Map<String, int> tabIndices = {
    'dashboard': 0,
    'projects': 1,
    'priceRequests': 2,
    'orders': 3,
    'categories': 4,
    'brands': 5,
    'products': 6,
    'blog': 7,
    'gallery': 8,
    'banners': 9,
    'clients': 10,
    'settings': 11,
  };

  // Navigation state
  final RxInt _currentTabIndex = 0.obs;
  final RxList<int> _navigationHistory = <int>[].obs;
  final RxBool _isNavigating = false.obs;

  // Getters
  int get currentTabIndex => _currentTabIndex.value;
  List<int> get navigationHistory => _navigationHistory.toList();
  bool get isNavigating => _isNavigating.value;

  @override
  void onInit() {
    super.onInit();
    _initializeNavigation();
  }

  /// Initialize navigation system
  void _initializeNavigation() {
    try {
      // Try to find the TabController
      final tabController = Get.find<TabController>(tag: 'main_tab_controller');

      // Add listener to track current tab
      tabController.addListener(() {
        if (!_isNavigating.value) {
          _currentTabIndex.value = tabController.index;
          _addToHistory(tabController.index);
        }
      });

      if (kDebugMode) {
        print('✅ NavigationController: Initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ NavigationController: Failed to initialize - $e');
      }
    }
  }

  /// Navigate to specific tab
  void navigateToTab(String tabName) {
    try {
      final tabIndex = tabIndices[tabName];
      if (tabIndex == null) {
        throw Exception('Tab not found: $tabName');
      }

      if (_isNavigating.value) {
        if (kDebugMode) {
          print(
              '⚠️ NavigationController: Already navigating, skipping request');
        }
        return;
      }

      _performNavigation(tabIndex, tabName);
    } catch (e) {
      if (kDebugMode) {
        print('❌ NavigationController: Error navigating to $tabName - $e');
      }
      _showErrorSnackbar(
          'خطأ في التنقل', 'حدث خطأ أثناء الانتقال إلى $tabName');
    }
  }

  /// Perform the actual navigation
  void _performNavigation(int tabIndex, String tabName) {
    _isNavigating.value = true;

    try {
      final tabController = Get.find<TabController>(tag: 'main_tab_controller');

      // Check if already on the target tab
      if (tabController.index == tabIndex) {
        if (kDebugMode) {
          print('ℹ️ NavigationController: Already on tab $tabName');
        }
        _showInfoSnackbar('تنبيه', 'أنت بالفعل في صفحة $tabName');
        return;
      }

      // Perform navigation
      tabController.animateTo(tabIndex);
      _currentTabIndex.value = tabIndex;
      _addToHistory(tabIndex);

      if (kDebugMode) {
        print(
            '✅ NavigationController: Successfully navigated to $tabName (index: $tabIndex)');
      }

      _showSuccessSnackbar('تم التنقل', 'تم الانتقال إلى $tabName');
    } catch (e) {
      if (kDebugMode) {
        print('❌ NavigationController: Failed to navigate to $tabName - $e');
      }
      _showErrorSnackbar('خطأ في التنقل', 'فشل في الانتقال إلى $tabName');
    } finally {
      _isNavigating.value = false;
    }
  }

  /// Add tab to navigation history
  void _addToHistory(int tabIndex) {
    // Remove if already exists to avoid duplicates
    _navigationHistory.remove(tabIndex);
    // Add to the end
    _navigationHistory.add(tabIndex);

    // Keep only last 10 entries
    if (_navigationHistory.length > 10) {
      _navigationHistory.removeAt(0);
    }
  }

  /// Navigate back to previous tab
  void navigateBack() {
    if (_navigationHistory.length > 1) {
      final previousIndex = _navigationHistory[_navigationHistory.length - 2];
      final tabName = _getTabNameByIndex(previousIndex);
      if (tabName != null) {
        navigateToTab(tabName);
      }
    } else {
      _showInfoSnackbar('تنبيه', 'لا توجد صفحة سابقة');
    }
  }

  /// Get tab name by index
  String? _getTabNameByIndex(int index) {
    for (final entry in tabIndices.entries) {
      if (entry.value == index) {
        return entry.key;
      }
    }
    return null;
  }

  /// Navigate to tab by index
  void navigateToTabByIndex(int tabIndex) {
    final tabName = _getTabNameByIndex(tabIndex);
    if (tabName != null) {
      navigateToTab(tabName);
    } else {
      _showErrorSnackbar('خطأ', 'فهرس التاب غير صحيح: $tabIndex');
    }
  }

  /// Show success snackbar
  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  /// Show error snackbar
  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  /// Show info snackbar
  void _showInfoSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  // Navigate to dashboard
  void navigateToDashboard() => navigateToTab('dashboard');

  // Navigate to projects
  void navigateToProjects() => navigateToTab('projects');

  // Navigate to price requests
  void navigateToPriceRequests() => navigateToTab('priceRequests');

  // Navigate to orders
  void navigateToOrders() => navigateToTab('orders');

  // Navigate to categories
  void navigateToCategories() => navigateToTab('categories');

  // Navigate to brands
  void navigateToBrands() => navigateToTab('brands');

  // Navigate to products
  void navigateToProducts() => navigateToTab('products');

  // Navigate to blog
  void navigateToBlog() => navigateToTab('blog');

  // Navigate to gallery
  void navigateToGallery() => navigateToTab('gallery');

  // Navigate to banners
  void navigateToBanners() => navigateToTab('banners');

  // Navigate to clients
  void navigateToClients() => navigateToTab('clients');

  // Navigate to settings
  void navigateToSettings() => navigateToTab('settings');

  /// Get current tab name
  String? get currentTabName => _getTabNameByIndex(_currentTabIndex.value);

  /// Check if can navigate back
  bool get canNavigateBack => _navigationHistory.length > 1;

  /// Clear navigation history
  void clearHistory() {
    _navigationHistory.clear();
    _navigationHistory.add(_currentTabIndex.value);
    if (kDebugMode) {
      print('🗑️ NavigationController: History cleared');
    }
  }

  /// Get navigation statistics
  Map<String, dynamic> getNavigationStats() {
    return {
      'currentTab': currentTabName,
      'currentIndex': _currentTabIndex.value,
      'historyLength': _navigationHistory.length,
      'canGoBack': canNavigateBack,
      'isNavigating': _isNavigating.value,
      'history': _navigationHistory.map(_getTabNameByIndex).toList(),
    };
  }

  /// Navigate to next tab
  void navigateToNext() {
    final nextIndex = (_currentTabIndex.value + 1) % tabIndices.length;
    navigateToTabByIndex(nextIndex);
  }

  /// Navigate to previous tab
  void navigateToPrevious() {
    final prevIndex =
        (_currentTabIndex.value - 1 + tabIndices.length) % tabIndices.length;
    navigateToTabByIndex(prevIndex);
  }

  /// Navigate to first tab
  void navigateToFirst() => navigateToTab('dashboard');

  /// Navigate to last tab
  void navigateToLast() => navigateToTab('settings');

  /// Refresh current tab (useful for updating data)
  void refreshCurrentTab() {
    final currentName = currentTabName;
    if (currentName != null) {
      if (kDebugMode) {
        print('🔄 NavigationController: Refreshing current tab: $currentName');
      }
      _showInfoSnackbar('تحديث', 'جاري تحديث $currentName');
    }
  }

  /// Get all available tabs
  List<String> get availableTabs => tabIndices.keys.toList();

  /// Check if tab exists
  bool hasTab(String tabName) => tabIndices.containsKey(tabName);

  /// Get tab index by name
  int? getTabIndex(String tabName) => tabIndices[tabName];

  /// Handle keyboard shortcuts
  void handleKeyboardShortcut(String shortcut) {
    switch (shortcut.toLowerCase()) {
      case 'ctrl+1':
      case 'alt+1':
        navigateToDashboard();
        break;
      case 'ctrl+2':
      case 'alt+2':
        navigateToProjects();
        break;
      case 'ctrl+3':
      case 'alt+3':
        navigateToPriceRequests();
        break;
      case 'ctrl+4':
      case 'alt+4':
        navigateToOrders();
        break;
      case 'ctrl+5':
      case 'alt+5':
        navigateToCategories();
        break;
      case 'ctrl+6':
      case 'alt+6':
        navigateToBrands();
        break;
      case 'ctrl+7':
      case 'alt+7':
        navigateToProducts();
        break;
      case 'ctrl+8':
      case 'alt+8':
        navigateToBlog();
        break;
      case 'ctrl+9':
      case 'alt+9':
        navigateToGallery();
        break;
      case 'ctrl+0':
      case 'alt+0':
        navigateToSettings();
        break;
      case 'ctrl+left':
      case 'alt+left':
        navigateToPrevious();
        break;
      case 'ctrl+right':
      case 'alt+right':
        navigateToNext();
        break;
      case 'ctrl+home':
      case 'alt+home':
        navigateToFirst();
        break;
      case 'ctrl+end':
      case 'alt+end':
        navigateToLast();
        break;
      case 'ctrl+backspace':
      case 'alt+backspace':
        navigateBack();
        break;
      case 'ctrl+r':
      case 'f5':
        refreshCurrentTab();
        break;
      default:
        if (kDebugMode) {
          print(
              '⚠️ NavigationController: Unknown keyboard shortcut: $shortcut');
        }
    }
  }

  /// Get available keyboard shortcuts
  Map<String, String> getKeyboardShortcuts() {
    return {
      'Ctrl+1 / Alt+1': 'Dashboard',
      'Ctrl+2 / Alt+2': 'Projects',
      'Ctrl+3 / Alt+3': 'Price Requests',
      'Ctrl+4 / Alt+4': 'Orders',
      'Ctrl+5 / Alt+5': 'Categories',
      'Ctrl+6 / Alt+6': 'Brands',
      'Ctrl+7 / Alt+7': 'Products',
      'Ctrl+8 / Alt+8': 'Blog',
      'Ctrl+9 / Alt+9': 'Gallery',
      'Ctrl+0 / Alt+0': 'Settings',
      'Ctrl+← / Alt+←': 'Previous Tab',
      'Ctrl+→ / Alt+→': 'Next Tab',
      'Ctrl+Home / Alt+Home': 'First Tab',
      'Ctrl+End / Alt+End': 'Last Tab',
      'Ctrl+Backspace / Alt+Backspace': 'Go Back',
      'Ctrl+R / F5': 'Refresh Current Tab',
    };
  }

  /// Show keyboard shortcuts help
  void showKeyboardShortcuts() {
    final shortcuts = getKeyboardShortcuts();
    final message = shortcuts.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');

    Get.dialog(
      AlertDialog(
        title: const Text('اختصارات لوحة المفاتيح'),
        content: SingleChildScrollView(
          child: Text(
            message,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
