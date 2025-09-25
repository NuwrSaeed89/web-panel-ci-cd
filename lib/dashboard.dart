import 'package:brother_admin_panel/common/widgets/mobile_preview_widget.dart';
import 'package:brother_admin_panel/common/widgets/mobile_screen_simulator.dart';
import 'package:brother_admin_panel/features/authentication/controllers/login_controller.dart';
import 'package:brother_admin_panel/features/dashboard/screens/index.dart';
import 'package:brother_admin_panel/localization/language_controller.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/controllers/mobile_preview_controller.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/widgets/build_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showTabs = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 12, vsync: this);

    // Register TabController in GetX for NavigationController to use
    Get.put(_tabController, tag: 'main_tab_controller');

    // تهيئة controller شاشة الموبايل العائمة (فقط في المتصفح)
    if (kIsWeb) {
      Get.put(MobilePreviewController());

      // إضافة listener لتحديث شاشة المحاكي عند تغيير التاب
      _tabController.addListener(() {
        if (Get.isRegistered<MobilePreviewController>()) {
          Get.find<MobilePreviewController>().update();
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Scaffold(
          backgroundColor: themeController.isDarkMode
              ? const Color(0xFF1a1a2e) // Dark theme
              : const Color(0xFFf5f5f5), // Light theme
          body: Stack(
            children: [
              Column(
                children: [
                  // Top Tabs Bar
                  Container(
                    color: themeController.isDarkMode
                        ? const Color(0xFF16213e) // Dark theme
                        : const Color(0xFFffffff), // Light theme
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Check if screen is mobile (width < 600)
                              final bool isMobile = constraints.maxWidth < 600;

                              if (isMobile) {
                                // Mobile layout - Stack elements vertically or use smaller icons
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // First row: Title and version
                                    Padding(
                                      padding: const EdgeInsets.only(top: 28.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'appTitle'.tr,
                                              style:
                                                  TTextStyles.heading4.copyWith(
                                                color:
                                                    themeController.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          // Container(
                                          //   padding: const EdgeInsets.symmetric(
                                          //       horizontal: 6, vertical: 2),
                                          //   decoration: BoxDecoration(
                                          //     color: Colors.red,
                                          //     borderRadius:
                                          //         BorderRadius.circular(12),
                                          //   ),
                                          //   child: Text(
                                          //     'version'.tr,
                                          //     style:
                                          //         TTextStyles.overline.copyWith(
                                          //       color: Colors.white,
                                          //       fontSize: 10,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Second row: Action buttons
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.dialog(
                                              AlertDialog(
                                                backgroundColor:
                                                    Theme.of(context).cardColor,
                                                title: Text(
                                                  'confirmLogout'.tr,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'IBM Plex Sans Arabic',
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.color,
                                                  ),
                                                ),
                                                content: Text(
                                                  'logoutConfirmationMessage'
                                                      .tr,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'IBM Plex Sans Arabic',
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: Get.back,
                                                    child: Text(
                                                      'cancel'.tr,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'IBM Plex Sans Arabic',
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      try {
                                                        final loginController =
                                                            Get.find<
                                                                LoginController>();
                                                        await loginController
                                                            .signOut();
                                                      } catch (e) {
                                                        // إذا لم تكن وحدة التحكم موجودة، استخدم Firebase مباشرة
                                                        await FirebaseAuth
                                                            .instance
                                                            .signOut();
                                                        Get.offAllNamed(
                                                            '/login');
                                                      }
                                                    },
                                                    child: Text(
                                                      'logout'.tr,
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'IBM Plex Sans Arabic',
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'logout'.tr,
                                            style: TextStyle(
                                              fontFamily:
                                                  'IBM Plex Sans Arabic',
                                              color: TColors.primary,
                                              fontSize: isMobile ? 12 : 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        // Language Toggle Button
                                        GetBuilder<LanguageController>(
                                          builder: (languageController) {
                                            return IconButton(
                                              onPressed: () {
                                                if (languageController
                                                    .isArabic) {
                                                  languageController
                                                      .changeToEnglish();
                                                } else {
                                                  languageController
                                                      .changeToArabic();
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.language,
                                                color: TColors.primary,
                                                size: 24,
                                              ),
                                              tooltip:
                                                  languageController.isArabic
                                                      ? 'Change to English'
                                                      : 'تغيير إلى العربية',
                                            );
                                          },
                                        ),
                                        // Theme Toggle Button
                                        GetBuilder<ThemeController>(
                                          builder: (themeController) {
                                            return IconButton(
                                              onPressed: () {
                                                themeController.toggleTheme();
                                              },
                                              icon: Icon(
                                                themeController.isDarkMode
                                                    ? Icons.light_mode
                                                    : Icons.dark_mode,
                                                color:
                                                    themeController.isDarkMode
                                                        ? Colors.yellow
                                                        : TColors.primary,
                                                size: 24,
                                              ),
                                              tooltip:
                                                  themeController.isDarkMode
                                                      ? 'toggleToLightMode'.tr
                                                      : 'toggleToDarkMode'.tr,
                                            );
                                          },
                                        ),
                                        // User Info and Logout

                                        // Mobile Preview Button (only on web)
                                        if (kIsWeb)
                                          GetBuilder<MobilePreviewController>(
                                            builder: (mobilePreviewController) {
                                              return IconButton(
                                                onPressed: () {
                                                  mobilePreviewController
                                                      .toggleMobilePreview();
                                                },
                                                icon: Icon(
                                                  Icons.phone_android,
                                                  color: mobilePreviewController
                                                          .isVisible.value
                                                      ? TColors.primary
                                                      : (themeController
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : Colors.black87),
                                                  size: 24,
                                                ),
                                                tooltip: mobilePreviewController
                                                        .isVisible.value
                                                    ? 'hideMobilePreview'.tr
                                                    : 'showMobilePreview'.tr,
                                              );
                                            },
                                          ),

                                        // Toggle Tabs Button
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _showTabs = !_showTabs;
                                            });
                                          },
                                          icon: Icon(
                                            _showTabs
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            color: themeController.isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                            size: 24,
                                          ),
                                          tooltip: _showTabs
                                              ? 'hideTabs'.tr
                                              : 'showTabs'.tr,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                // Desktop layout - Original horizontal layout
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'appTitle'.tr,
                                        style: TTextStyles.heading4.copyWith(
                                          color: themeController.isDarkMode
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Container(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 8, vertical: 2),
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.red,
                                    //     borderRadius: BorderRadius.circular(12),
                                    //   ),
                                    //   child: Text(
                                    //     'version'.tr,
                                    //     style: TTextStyles.overline.copyWith(
                                    //       color: Colors.white,
                                    //     ),
                                    //   ),
                                    // ),
                                    // const Spacer(),
                                    // Language Toggle Button
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.dialog(
                                              AlertDialog(
                                                backgroundColor:
                                                    Theme.of(context).cardColor,
                                                title: Text(
                                                  'confirmLogout'.tr,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'IBM Plex Sans Arabic',
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.color,
                                                  ),
                                                ),
                                                content: Text(
                                                  'logoutConfirmationMessage'
                                                      .tr,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'IBM Plex Sans Arabic',
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: Get.back,
                                                    child: Text(
                                                      'cancel'.tr,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'IBM Plex Sans Arabic',
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Get.back();
                                                      try {
                                                        final loginController =
                                                            Get.find<
                                                                LoginController>();
                                                        await loginController
                                                            .signOut();
                                                      } catch (e) {
                                                        // إذا لم تكن وحدة التحكم موجودة، استخدم Firebase مباشرة
                                                        await FirebaseAuth
                                                            .instance
                                                            .signOut();
                                                        Get.offAllNamed(
                                                            '/login');
                                                      }
                                                    },
                                                    child: Text(
                                                      'logout'.tr,
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'IBM Plex Sans Arabic',
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'logout'.tr,
                                            style: TextStyle(
                                              fontFamily:
                                                  'IBM Plex Sans Arabic',
                                              color: TColors.primary,
                                              fontSize: isMobile ? 12 : 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GetBuilder<LanguageController>(
                                          builder: (languageController) {
                                            return IconButton(
                                              onPressed: () {
                                                if (languageController
                                                    .isArabic) {
                                                  languageController
                                                      .changeToEnglish();
                                                } else {
                                                  languageController
                                                      .changeToArabic();
                                                }
                                              },
                                              icon: Icon(
                                                Icons.language,
                                                color:
                                                    themeController.isDarkMode
                                                        ? Colors.white
                                                        : TColors.primary,
                                                size: 28,
                                              ),
                                              tooltip:
                                                  languageController.isArabic
                                                      ? 'Change to English'
                                                      : 'تغيير إلى العربية',
                                            );
                                          },
                                        ),

                                        const SizedBox(width: 8),
                                        // Theme Toggle Button
                                        GetBuilder<ThemeController>(
                                          builder: (themeController) {
                                            return IconButton(
                                              onPressed: () {
                                                themeController.toggleTheme();
                                              },
                                              icon: Icon(
                                                themeController.isDarkMode
                                                    ? Icons.light_mode
                                                    : Icons.dark_mode,
                                                color:
                                                    themeController.isDarkMode
                                                        ? Colors.yellow
                                                        : TColors.primary,
                                                size: 28,
                                              ),
                                              tooltip:
                                                  themeController.isDarkMode
                                                      ? 'toggleToLightMode'.tr
                                                      : 'toggleToDarkMode'.tr,
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        // Mobile Preview Button (only on web)
                                        if (!kIsWeb) const BuildUserInfo(),

                                        // Mobile Preview Button (only on web)
                                        if (kIsWeb)
                                          GetBuilder<MobilePreviewController>(
                                            builder: (mobilePreviewController) {
                                              return IconButton(
                                                onPressed: () {
                                                  mobilePreviewController
                                                      .toggleMobilePreview();
                                                },
                                                icon: Icon(
                                                  Icons.phone_android,
                                                  color: mobilePreviewController
                                                          .isVisible.value
                                                      ? TColors.primary
                                                      : (themeController
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : Colors.black87),
                                                  size: 28,
                                                ),
                                                tooltip: mobilePreviewController
                                                        .isVisible.value
                                                    ? 'hideMobilePreview'.tr
                                                    : 'showMobilePreview'.tr,
                                              );
                                            },
                                          ),

                                        if (kIsWeb) const SizedBox(width: 8),

                                        // Toggle Tabs Button
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _showTabs = !_showTabs;
                                            });
                                          },
                                          icon: Icon(
                                            _showTabs
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            color: themeController.isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                            size: 28,
                                          ),
                                          tooltip: _showTabs
                                              ? 'hideTabs'.tr
                                              : 'showTabs'.tr,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),

                        // Tabs (Conditional)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: _showTabs ? 60 : 0,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _showTabs ? 1.0 : 0.0,
                            child: _showTabs
                                ? LayoutBuilder(
                                    builder: (context, constraints) {
                                      final bool isMobile =
                                          constraints.maxWidth < 600;
                                      return SizedBox(
                                        height: isMobile ? 50 : 60,
                                        child: TabBar(
                                          controller: _tabController,
                                          isScrollable: true,
                                          indicatorColor:
                                              const Color(0xFF0055ff),
                                          indicatorWeight: 4,
                                          labelColor: themeController.isDarkMode
                                              ? Colors.white
                                              : Colors.black87,
                                          unselectedLabelColor:
                                              themeController.isDarkMode
                                                  ? Colors.white70
                                                  : Colors.black54,
                                          labelStyle: TextStyle(
                                            fontSize: isMobile ? 10 : 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          unselectedLabelStyle: TextStyle(
                                            fontSize: isMobile ? 10 : 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          tabs: [
                                            Tab(
                                              icon: Icon(Icons.dashboard,
                                                  size: isMobile ? 14 : 20),
                                              text: 'dashboard'.tr,
                                            ),
                                            Tab(
                                              icon: Icon(Icons.track_changes,
                                                  size: isMobile ? 14 : 20),
                                              text: 'projectsTracker'.tr,
                                            ),
                                            Tab(
                                              icon: Icon(Icons.price_check,
                                                  size: isMobile ? 14 : 20),
                                              text: 'pricesRequest'.tr,
                                            ),
                                            // Tab(
                                            //   icon: const Icon(Icons.person, size: 20),
                                            //   text: 'interviews'.tr,
                                            // ),
                                            Tab(
                                              icon: Icon(Icons.shopping_cart,
                                                  size: isMobile ? 14 : 20),
                                              text: 'shoppingOrders'.tr,
                                            ),
                                            Tab(
                                              icon: Icon(Icons.category,
                                                  size: isMobile ? 14 : 20),
                                              text: 'categories'.tr,
                                            ),
                                            Tab(
                                              icon: Icon(
                                                  Icons.branding_watermark,
                                                  size: isMobile ? 14 : 20),
                                              text: 'brands'.tr,
                                            ),
                                            Tab(
                                              icon: Icon(Icons.inventory,
                                                  size: isMobile ? 14 : 20),
                                              text: 'products'.tr,
                                            ),
                                            Tab(
                                              icon: Icon(Icons.article,
                                                  size: isMobile ? 14 : 20),
                                              text: 'blog'.tr,
                                            ),
                                            Tab(
                                              icon: Icon(Icons.photo_sharp,
                                                  size: isMobile ? 14 : 20),
                                              text: 'gallery'.tr,
                                            ),
                                            Tab(
                                              icon: Icon(Icons.campaign,
                                                  size: isMobile ? 14 : 20),
                                              text: 'banners'.tr,
                                            ),
                                            Tab(
                                              icon: Icon(Icons.people,
                                                  size: isMobile ? 14 : 20),
                                              text: 'clients'.tr,
                                            ),
                                            Tab(
                                              icon: Icon(Icons.settings,
                                                  size: isMobile ? 14 : 20),
                                              text: 'settings'.tr,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : SizedBox(
                                    height: 20,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.keyboard_arrow_up,
                                            color: themeController.isDarkMode
                                                ? Colors.white54
                                                : Colors.black54,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'pressArrowToShowTabs'.tr,
                                            style: TTextStyles.caption.copyWith(
                                              color: themeController.isDarkMode
                                                  ? Colors.white54
                                                  : Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content Area
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        // Dashboard Tab
                        DashboardMainScreen(),

                        // Projects Tracker Tab
                        ProjectsTrackerScreen(),

                        // Prices Request Tab
                        PricesRequestScreen(),

                        // Interviews Requests Tab
                        // InterviewsRequestsScreen(),

                        // Shopping Orders Tab
                        ShoppingOrdersScreen(),

                        // Categories Tab
                        CategoriesScreen(),
                        BrandScreen(),
                        // Products Tab
                        ProductsScreen(),

                        // Blog Tab
                        BlogScreen(),

                        // Studio Tab
                        StudioScreen(),

                        // Banners Tab
                        BannersScreen(),

                        // Clients Tab
                        ClientsScreen(),

                        // Settings Tab
                        SettingsScreen(),
                      ],
                    ),
                  ),
                ],
              ),

              // Mobile Preview Widget (only on web) - فوق جميع التابات
              if (kIsWeb)
                GetBuilder<MobilePreviewController>(
                  builder: (mobilePreviewController) {
                    return MobilePreviewWidget(
                      key: ValueKey(_tabController.index), // مفتاح فريد للتحديث
                      currentTabIndex: _tabController.index,
                      child: MobileScreenSimulator(
                        currentTabIndex: _tabController.index,
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
