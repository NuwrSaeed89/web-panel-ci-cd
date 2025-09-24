import 'package:get/get.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  // Observable variables
  final RxString selectedPeriod = 'MONTH'.obs;
  final RxString selectedDate = 'June 2018'.obs;

  // Dashboard data
  final RxDouble totalCost = 214.0.obs;
  final RxDouble electricityCost = 150.0.obs;
  final RxDouble gasCost = 64.0.obs;

  // Cost change data
  final RxDouble mayCost = 203.0.obs;
  final RxDouble juneCost = 214.0.obs;
  final RxDouble costChangePercentage = 5.42.obs;
  final RxBool isCostIncreasing = true.obs;

  // Usage data
  final RxDouble currentUsage = 164.1.obs;
  final RxDouble predictedUsage = 439.0.obs;

  // Energy intensity
  final RxDouble energyIntensity = 47.0.obs;

  // Carbon footprint
  final RxDouble currentEmission = 36.4.obs;
  final RxDouble predictedEmission = 181.8.obs;
  final RxDouble greenEnergyProgress = 15.0.obs;

  // Active appliances
  final RxList<Map<String, dynamic>> activeAppliances = <Map<String, dynamic>>[
    {'name': 'Heating & AC', 'usage': 1.4, 'percentage': 0.7},
    {'name': 'EV Charge', 'usage': 0.9, 'percentage': 0.45},
    {'name': 'Plug Loads', 'usage': 0.8, 'percentage': 0.4},
    {'name': 'Refrigeration', 'usage': 0.7, 'percentage': 0.35},
    {'name': 'Lighting', 'usage': 0.4, 'percentage': 0.2},
  ].obs;

  // Layout control variables
  final RxBool isMobile = false.obs;
  final RxBool isTablet = false.obs;
  final RxBool isDesktop = false.obs;
  final RxBool isSidebarVisible = true.obs;
  final RxBool isDrawerOpen = false.obs;

  // Navigation control
  final RxString currentScreen = 'Dashboard'.obs;

  @override
  void onInit() {
    super.onInit();

    // تهيئة القيم الأولية
    isMobile.value = false;
    isTablet.value = false;
    isDesktop.value = false;
    isDesktop.value = true; // افتراضيًا نبدأ بـ desktop
    isSidebarVisible.value = true;
    currentScreen.value = 'Dashboard';

    // Initialize dashboard data
    _loadDashboardData();
  }

  // Load dashboard data
  void _loadDashboardData() {
    // This is where you'll implement data loading logic
  }

  // Change selected period (TODAY, MONTH, YEAR)
  void changePeriod(String period) {
    selectedPeriod.value = period;
    _updateDateBasedOnPeriod(period);
    _loadDashboardData(); // Reload data for new period
  }

  // Update date based on selected period
  void _updateDateBasedOnPeriod(String period) {
    switch (period) {
      case 'TODAY':
        selectedDate.value = 'Today';
        break;
      case 'MONTH':
        selectedDate.value = 'June 2018';
        break;
      case 'YEAR':
        selectedDate.value = '2018';
        break;
    }
  }

  // Refresh dashboard data
  void refreshDashboard() {
    _loadDashboardData();
  }

  // Get cost breakdown
  Map<String, double> getCostBreakdown() {
    return {
      'electricity': electricityCost.value,
      'gas': gasCost.value,
      'total': totalCost.value,
    };
  }

  // Get usage statistics
  Map<String, double> getUsageStats() {
    return {
      'current': currentUsage.value,
      'predicted': predictedUsage.value,
      'percentage': (currentUsage.value / predictedUsage.value) * 100,
    };
  }

  // Get energy intensity status
  String getEnergyIntensityStatus() {
    if (energyIntensity.value < 30) {
      return 'Low';
    } else if (energyIntensity.value < 60) {
      return 'Medium';
    } else {
      return 'High';
    }
  }

  // Get carbon footprint status
  String getCarbonFootprintStatus() {
    final progress = (currentEmission.value / predictedEmission.value) * 100;
    if (progress < 25) {
      return 'Excellent';
    } else if (progress < 50) {
      return 'Good';
    } else if (progress < 75) {
      return 'Fair';
    } else {
      return 'Needs Improvement';
    }
  }

  // Update appliance usage
  void updateApplianceUsage(String applianceName, double newUsage) {
    final index =
        activeAppliances.indexWhere((app) => app['name'] == applianceName);
    if (index != -1) {
      activeAppliances[index]['usage'] = newUsage;
      activeAppliances[index]['percentage'] =
          newUsage / 2.0; // Normalize to 0-1
      activeAppliances.refresh();
    }
  }

  // Get dashboard summary
  Map<String, dynamic> getDashboardSummary() {
    return {
      'period': selectedPeriod.value,
      'date': selectedDate.value,
      'totalCost': totalCost.value,
      'costChange': costChangePercentage.value,
      'currentUsage': currentUsage.value,
      'energyIntensity': energyIntensity.value,
      'carbonStatus': getCarbonFootprintStatus(),
    };
  }

  // Layout control methods
  void updateLayout(double screenWidth) {
    bool needsUpdate = false;

    if (screenWidth < 768) {
      // Mobile layout
      if (!isMobile.value) {
        isMobile.value = true;
        isTablet.value = false;
        isDesktop.value = false;
        isSidebarVisible.value = false;
        needsUpdate = true;
      }
    } else if (screenWidth < 1200) {
      // Tablet layout
      if (!isTablet.value) {
        isMobile.value = false;
        isTablet.value = true;
        isDesktop.value = false;
        isSidebarVisible.value = true;
        needsUpdate = true;
      }
    } else {
      // Desktop layout
      if (!isDesktop.value) {
        isMobile.value = false;
        isTablet.value = false;
        isDesktop.value = true;
        isSidebarVisible.value = true;
        needsUpdate = true;
      }
    }

    // Only update if something actually changed
    if (needsUpdate) {
      update();
    }
  }

  // Toggle drawer for mobile
  void toggleDrawer() {
    if (isMobile.value) {
      isDrawerOpen.value = !isDrawerOpen.value;
    }
  }

  // Close drawer
  void closeDrawer() {
    isDrawerOpen.value = false;
  }

  // Get current layout type
  String getCurrentLayoutType() {
    if (isMobile.value) return 'Mobile';
    if (isTablet.value) return 'Tablet';
    if (isDesktop.value) return 'Desktop';
    return 'Unknown';
  }

  // Check if sidebar should be visible
  bool shouldShowSidebar() {
    return isSidebarVisible.value && !isMobile.value;
  }

  // Check if menu button should be visible
  bool shouldShowMenuButton() {
    return isMobile.value;
  }

  // Change current screen
  void changeScreen(String screenName) {
    if (currentScreen.value != screenName) {
      currentScreen.value = screenName;

      // No need to call update() when using Obx with RxString
    }
  }

  // Check if screen is active
  bool isScreenActive(String screenName) {
    return currentScreen.value == screenName;
  }

  // Update displayed content based on selected screen
  void updateDisplayedContent(String screenName) {
    currentScreen.value = screenName;
    update(); // Notify GetBuilder widgets to rebuild
  }
}
