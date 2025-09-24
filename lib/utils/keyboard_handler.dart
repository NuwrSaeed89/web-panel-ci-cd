import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// معالج أحداث لوحة المفاتيح لتجنب أخطاء assertion
/// Keyboard event handler to prevent assertion errors
class KeyboardHandler {
  static bool _isInitialized = false;
  static final List<KeyEvent> _pendingEvents = [];

  /// تهيئة معالج لوحة المفاتيح
  /// Initialize keyboard handler
  static void initialize() {
    if (_isInitialized) return;

    try {
      // إضافة معالج الأحداث
      // Add event handler
      HardwareKeyboard.instance.addHandler(_handleKeyEvent);

      // تنظيف الأحداث المعلقة بشكل دوري
      // Clean up pending events periodically
      _cleanupPendingEvents();

      _isInitialized = true;

      if (kDebugMode) {
        print('✅ Keyboard handler initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize keyboard handler: $e');
      }
    }
  }

  /// إلغاء تهيئة معالج لوحة المفاتيح
  /// Dispose keyboard handler
  static void dispose() {
    if (!_isInitialized) return;

    try {
      HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
      _pendingEvents.clear();
      _isInitialized = false;

      if (kDebugMode) {
        print('✅ Keyboard handler disposed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error disposing keyboard handler: $e');
      }
    }
  }

  /// معالج أحداث لوحة المفاتيح الرئيسي
  /// Main keyboard event handler
  static bool _handleKeyEvent(KeyEvent event) {
    try {
      // التحقق من نوع الحدث
      // Check event type
      if (event is KeyDownEvent) {
        return _handleKeyDown(event);
      } else if (event is KeyUpEvent) {
        return _handleKeyUp(event);
      }

      return true; // السماح بالمعالجة العادية للأحداث الأخرى
    } catch (e) {
      if (kDebugMode) {
        print('❌ Keyboard event handler error: $e');
      }
      return false;
    }
  }

  /// معالجة أحداث الضغط على المفاتيح
  /// Handle key down events
  static bool _handleKeyDown(KeyDownEvent event) {
    try {
      // التحقق من حالة المفتاح
      // Check key state
      final isKeyPressed = HardwareKeyboard.instance.physicalKeysPressed
          .contains(event.physicalKey);

      if (isKeyPressed) {
        // إضافة الحدث إلى قائمة الانتظار للتنظيف لاحقاً
        // Add event to pending list for cleanup
        _pendingEvents.add(event);
        return false; // تجاهل الحدث المكرر
      }

      return true; // السماح بالمعالجة العادية
    } catch (e) {
      if (kDebugMode) {
        print('❌ Key down handler error: $e');
      }
      return false;
    }
  }

  /// معالجة أحداث رفع المفاتيح
  /// Handle key up events
  static bool _handleKeyUp(KeyUpEvent event) {
    try {
      return true; // السماح بالمعالجة العادية
    } catch (e) {
      if (kDebugMode) {
        print('❌ Key up handler error: $e');
      }
      return false;
    }
  }

  /// تنظيف الأحداث المعلقة
  /// Clean up pending events
  static void _cleanupPendingEvents() {
    try {
      // إزالة الأحداث القديمة
      // Remove old events
      _pendingEvents.removeWhere((event) {
        final now = DateTime.now();
        final eventTime = DateTime.fromMillisecondsSinceEpoch(
          event.timeStamp.inMilliseconds,
        );
        final difference = now.difference(eventTime);

        // إزالة الأحداث الأقدم من 5 ثوان
        // Remove events older than 5 seconds
        return difference.inSeconds > 5;
      });

      if (kDebugMode &&
          _pendingEvents.isNotEmpty &&
          _pendingEvents.length > 10) {}
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cleaning up pending events: $e');
      }
    }
  }

  /// الحصول على معلومات لوحة المفاتيح
  /// Get keyboard information
  static Map<String, dynamic> getKeyboardInfo() {
    try {
      return {
        'isInitialized': _isInitialized,
        'pressedKeys': HardwareKeyboard.instance.physicalKeysPressed.length,
        'pendingEvents': _pendingEvents.length,
        'isControlPressed': HardwareKeyboard.instance.isControlPressed,
        'isShiftPressed': HardwareKeyboard.instance.isShiftPressed,
        'isAltPressed': HardwareKeyboard.instance.isAltPressed,
        'isMetaPressed': HardwareKeyboard.instance.isMetaPressed,
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting keyboard info: $e');
      }
      return {'error': e.toString()};
    }
  }

  /// إعادة تعيين حالة لوحة المفاتيح
  /// Reset keyboard state
  static void resetKeyboardState() {
    try {
      _pendingEvents.clear();

      if (kDebugMode) {
        print('🔄 Keyboard state reset');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error resetting keyboard state: $e');
      }
    }
  }
}
