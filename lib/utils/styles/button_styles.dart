import 'package:flutter/material.dart';

class ButtonStyles {
  // نمط موحد لزر الإضافة في جميع الصفحات
  static ButtonStyle get addButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0055ff),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      );

  // نمط لزر الإضافة مع أيقونة
  static Widget addButton({
    required VoidCallback onPressed,
    required String label,
    IconData icon = Icons.add,
    ButtonStyle? style,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: style ?? addButtonStyle,
    );
  }

  // نمط لزر الإضافة بدون أيقونة
  static Widget addButtonText({
    required VoidCallback onPressed,
    required String label,
    ButtonStyle? style,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style ?? addButtonStyle,
      child: Text(label),
    );
  }
}
