import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';

class IconGenerator {
  static Future<void> generateAppIcon() async {
    // إنشاء Canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(1024, 1024);

    // رسم الخلفية
    final paint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFF2196F3),
          Color(0xFF1976D2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );

    // رسم الحرف B
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'B',
        style: TextStyle(
          color: Colors.white,
          fontSize: 400,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    // رسم أيقونة لوحة التحكم
    _drawDashboardIcon(canvas, size);

    // إنهاء الرسم
    final picture = recorder.endRecording();
    final image = await picture.toImage(1024, 1024);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final bytes = byteData.buffer.asUint8List();
      final file = File('assets/icons/app_icon.png');
      await file.writeAsBytes(bytes);
    }
  }

  static void _drawDashboardIcon(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    // رسم المربعات
    const rectSize = 100.0;
    final startX = (size.width - rectSize * 2 - 20) / 2;
    final startY = (size.height - rectSize * 2 - 20) / 2;

    // الصف الأول
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(startX, startY, rectSize, rectSize),
        const Radius.circular(15),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(startX + rectSize + 20, startY, rectSize, rectSize),
        const Radius.circular(15),
      ),
      paint,
    );

    // الصف الثاني
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(startX, startY + rectSize + 20, rectSize, rectSize),
        const Radius.circular(15),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            startX + rectSize + 20, startY + rectSize + 20, rectSize, rectSize),
        const Radius.circular(15),
      ),
      paint,
    );

    // رسم النقاط
    final dotPaint = Paint()..color = const Color(0xFF2196F3);
    const dotRadius = 8.0;

    // النقاط في الصف الأول
    canvas.drawCircle(
      Offset(startX + rectSize / 2, startY + rectSize / 2),
      dotRadius,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(startX + rectSize + 20 + rectSize / 2, startY + rectSize / 2),
      dotRadius,
      dotPaint,
    );

    // النقاط في الصف الثاني
    canvas.drawCircle(
      Offset(startX + rectSize / 2, startY + rectSize + 20 + rectSize / 2),
      dotRadius,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(startX + rectSize + 20 + rectSize / 2,
          startY + rectSize + 20 + rectSize / 2),
      dotRadius,
      dotPaint,
    );
  }
}
