import 'package:flutter/material.dart';

class ThemeHelper {
  // Background Colors
  static Color getBackgroundColor(bool isDark) {
    return isDark ? const Color(0xFF1a1a2e) : const Color(0xFFf5f5f5);
  }

  static Color getCardBackgroundColor(bool isDark) {
    return isDark ? Colors.white10 : Colors.white;
  }

  static Color getSecondaryBackgroundColor(bool isDark) {
    return isDark ? const Color(0xFF16213e) : Colors.grey.shade50;
  }

  // Text Colors
  static Color getPrimaryTextColor(bool isDark) {
    return isDark ? Colors.white : Color(0xFF111111);
  }

  static Color getSecondaryTextColor(bool isDark) {
    return isDark ? Colors.white70 : Colors.black54;
  }

  static Color getHintTextColor(bool isDark) {
    return isDark ? Colors.white54 : Colors.black54;
  }

  // Border Colors
  static Color getBorderColor(bool isDark) {
    return isDark ? Colors.white12 : Colors.grey.shade200;
  }

  static Color getLightBorderColor(bool isDark) {
    return isDark ? Colors.white10 : Colors.grey.shade100;
  }

  // Input Colors
  static Color getInputFillColor(bool isDark) {
    return isDark ? Colors.white10 : Colors.grey.shade100;
  }

  static Color getInputBorderColor(bool isDark) {
    return isDark ? Colors.white24 : Colors.grey.shade300;
  }

  // Icon Colors
  static Color getIconColor(bool isDark) {
    return isDark ? Colors.white70 : Colors.black54;
  }

  static Color getPrimaryIconColor(bool isDark) {
    return isDark ? Colors.white : Color(0xFF111111);
  }

  // Button Colors
  static Color getPrimaryButtonColor(bool isDark) {
    return const Color(0xFF0055ff);
  }

  static Color getSecondaryButtonColor(bool isDark) {
    return isDark ? Colors.white10 : Colors.grey.shade200;
  }

  // Status Colors
  static Color getSuccessColor(bool isDark) {
    return Colors.green;
  }

  static Color getWarningColor(bool isDark) {
    return Colors.orange;
  }

  static Color getErrorColor(bool isDark) {
    return isDark ? Colors.red.shade400 : Colors.red.shade600;
  }

  static Color getInfoColor(bool isDark) {
    return Colors.blue;
  }

  // Shadow
  static List<BoxShadow> getCardShadow(bool isDark) {
    if (isDark) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: .3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];
    } else {
      return [
        BoxShadow(
          color: Colors.grey.withValues(alpha: .1),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];
    }
  }
}
