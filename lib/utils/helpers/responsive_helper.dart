import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // Responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(20);
    } else {
      return const EdgeInsets.all(24);
    }
  }

  // Responsive margin
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 20);
    } else {
      return const EdgeInsets.symmetric(horizontal: 24);
    }
  }

  // Responsive spacing
  static double getResponsiveSpacing(BuildContext context) {
    if (isMobile(context)) {
      return 16;
    } else if (isTablet(context)) {
      return 20;
    } else {
      return 24;
    }
  }

  // Grid cross axis count
  static int getGridCrossAxisCount(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 600) return 2; // Mobile
    if (width < 900) return 3; // Small Tablet
    if (width < 1200) return 4; // Large Tablet
    return 4; // Desktop
  }

  // Grid child aspect ratio
  static double getGridChildAspectRatio(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 600) return 1.0; // Mobile - Square
    if (width < 900) return 1.1; // Small Tablet
    if (width < 1200) return 1.2; // Large Tablet
    return 1.2; // Desktop
  }

  // Responsive font size
  static double getResponsiveFontSize(
    BuildContext context, {
    double mobile = 14,
    double tablet = 16,
    double desktop = 17,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Responsive icon size
  static double getResponsiveIconSize(
    BuildContext context, {
    double mobile = 20,
    double tablet = 24,
    double desktop = 28,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Responsive button height
  static double getResponsiveButtonHeight(BuildContext context) {
    if (isMobile(context)) return 48;
    if (isTablet(context)) return 52;
    return 56;
  }

  // Responsive card height
  static double getResponsiveCardHeight(BuildContext context) {
    if (isMobile(context)) return 120;
    if (isTablet(context)) return 140;
    return 160;
  }

  // Check if screen is in landscape mode
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  // Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) =>
      MediaQuery.of(context).padding;

  // Responsive breakpoints
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1200;
  static const double desktopBreakpoint = 1200;

  // Responsive layout builder
  static Widget responsiveBuilder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  // Responsive column/row layout
  static Widget responsiveLayout({
    required BuildContext context,
    required List<Widget> children,
    bool useColumn = false,
  }) {
    if (isMobile(context) || useColumn) {
      return Column(
        children: children
            .map((child) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: child,
                ))
            .toList(),
      );
    } else {
      return Row(
        children: children.map((child) => Expanded(child: child)).toList(),
      );
    }
  }
}
