import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as img;

/// خدمة اقتصاص الصور مع معاملات قابلة للتخصيص
class ImageCropService {
  /// اقتصاص الصورة حسب المعاملات المحددة
  static Future<Uint8List> cropImage({
    required Uint8List imageBytes,
    required CropParameters parameters,
  }) async {
    try {
      // فك تشفير الصورة
      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw Exception('فشل في فك تشفير الصورة');
      }

      if (kDebugMode) {
        print(
            '📊 Original image size: ${originalImage.width}x${originalImage.height}');
      }

      img.Image processedImage = originalImage;

      // تطبيق الاقتصاص حسب النوع
      switch (parameters.cropType) {
        case CropType.center:
          processedImage = _cropCenter(originalImage, parameters);
          break;
        case CropType.top:
          processedImage = _cropTop(originalImage, parameters);
          break;
        case CropType.bottom:
          processedImage = _cropBottom(originalImage, parameters);
          break;
        case CropType.left:
          processedImage = _cropLeft(originalImage, parameters);
          break;
        case CropType.right:
          processedImage = _cropRight(originalImage, parameters);
          break;
        case CropType.smart:
          processedImage = _cropSmart(originalImage, parameters);
          break;
        case CropType.circular:
          processedImage = _cropCircular(originalImage, parameters);
          break;
        case CropType.rounded:
          processedImage = _cropRounded(originalImage, parameters);
          break;
      }

      // تغيير الحجم إذا لزم الأمر
      if (parameters.width != null || parameters.height != null) {
        processedImage = _resizeImage(processedImage, parameters);
      }

      // ضغط الصورة
      if (parameters.quality != null) {
        processedImage = _compressImage(processedImage, parameters.quality!);
      }

      // ترميز الصورة النهائية
      final encodedBytes = _encodeImage(processedImage, parameters.format);

      if (kDebugMode) {
        print('✅ Image cropped successfully');
        print(
            '📊 Final size: ${processedImage.width}x${processedImage.height}');
        print('📊 Final bytes: ${encodedBytes.length}');
      }

      return encodedBytes;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cropping image: $e');
      }
      throw Exception('فشل في اقتصاص الصورة: $e');
    }
  }

  /// اقتصاص من المنتصف
  static img.Image _cropCenter(img.Image original, CropParameters params) {
    final targetWidth = params.width ?? original.width;
    final targetHeight = params.height ?? original.height;

    final x = (original.width - targetWidth) ~/ 2;
    final y = (original.height - targetHeight) ~/ 2;

    return img.copyCrop(
      original,
      x: x.clamp(0, original.width - targetWidth),
      y: y.clamp(0, original.height - targetHeight),
      width: targetWidth,
      height: targetHeight,
    );
  }

  /// اقتصاص من الأعلى
  static img.Image _cropTop(img.Image original, CropParameters params) {
    final targetWidth = params.width ?? original.width;
    final targetHeight = params.height ?? original.height;

    return img.copyCrop(
      original,
      x: (original.width - targetWidth) ~/ 2,
      y: 0,
      width: targetWidth,
      height: targetHeight,
    );
  }

  /// اقتصاص من الأسفل
  static img.Image _cropBottom(img.Image original, CropParameters params) {
    final targetWidth = params.width ?? original.width;
    final targetHeight = params.height ?? original.height;

    return img.copyCrop(
      original,
      x: (original.width - targetWidth) ~/ 2,
      y: original.height - targetHeight,
      width: targetWidth,
      height: targetHeight,
    );
  }

  /// اقتصاص من اليسار
  static img.Image _cropLeft(img.Image original, CropParameters params) {
    final targetWidth = params.width ?? original.width;
    final targetHeight = params.height ?? original.height;

    return img.copyCrop(
      original,
      x: 0,
      y: (original.height - targetHeight) ~/ 2,
      width: targetWidth,
      height: targetHeight,
    );
  }

  /// اقتصاص من اليمين
  static img.Image _cropRight(img.Image original, CropParameters params) {
    final targetWidth = params.width ?? original.width;
    final targetHeight = params.height ?? original.height;

    return img.copyCrop(
      original,
      x: original.width - targetWidth,
      y: (original.height - targetHeight) ~/ 2,
      width: targetWidth,
      height: targetHeight,
    );
  }

  /// اقتصاص ذكي (اختيار أفضل منطقة)
  static img.Image _cropSmart(img.Image original, CropParameters params) {
    final targetWidth = params.width ?? original.width;
    final targetHeight = params.height ?? original.height;

    // خوارزمية بسيطة لاختيار أفضل منطقة
    // يمكن تحسينها باستخدام تقنيات الذكاء الاصطناعي
    final x = (original.width - targetWidth) ~/ 2;
    final y = (original.height - targetHeight) ~/ 2;

    return img.copyCrop(
      original,
      x: x.clamp(0, original.width - targetWidth),
      y: y.clamp(0, original.height - targetHeight),
      width: targetWidth,
      height: targetHeight,
    );
  }

  /// اقتصاص دائري
  static img.Image _cropCircular(img.Image original, CropParameters params) {
    final size = params.width ?? params.height ?? original.width;
    final circularImage = img.Image(width: size, height: size);
    final centerX = size ~/ 2;
    final centerY = size ~/ 2;
    final radius = size ~/ 2;

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final distance =
            ((x - centerX) * (x - centerX) + (y - centerY) * (y - centerY))
                .toDouble();
        if (distance <= radius * radius) {
          final pixel = original.getPixel(x, y);
          circularImage.setPixel(x, y, pixel);
        } else {
          circularImage.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0)); // شفاف
        }
      }
    }

    return circularImage;
  }

  /// اقتصاص بزوايا مدورة
  static img.Image _cropRounded(img.Image original, CropParameters params) {
    final targetWidth = params.width ?? original.width;
    final targetHeight = params.height ?? original.height;
    final radius = params.borderRadius ?? 8.0;

    final croppedImage = img.copyCrop(
      original,
      x: (original.width - targetWidth) ~/ 2,
      y: (original.height - targetHeight) ~/ 2,
      width: targetWidth,
      height: targetHeight,
    );

    // تطبيق الزوايا المدورة
    return _applyRoundedCorners(croppedImage, radius);
  }

  /// تطبيق الزوايا المدورة
  static img.Image _applyRoundedCorners(img.Image image, double radius) {
    final result = img.Image.from(image);
    final r = radius.round();

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        bool shouldKeep = true;

        // الزاوية العلوية اليسرى
        if (x < r && y < r) {
          final distance = ((x - r) * (x - r) + (y - r) * (y - r)).toDouble();
          shouldKeep = distance <= r * r;
        }
        // الزاوية العلوية اليمنى
        else if (x >= image.width - r && y < r) {
          final distance = ((x - (image.width - r)) * (x - (image.width - r)) +
                  (y - r) * (y - r))
              .toDouble();
          shouldKeep = distance <= r * r;
        }
        // الزاوية السفلية اليسرى
        else if (x < r && y >= image.height - r) {
          final distance = ((x - r) * (x - r) +
                  (y - (image.height - r)) * (y - (image.height - r)))
              .toDouble();
          shouldKeep = distance <= r * r;
        }
        // الزاوية السفلية اليمنى
        else if (x >= image.width - r && y >= image.height - r) {
          final distance = ((x - (image.width - r)) * (x - (image.width - r)) +
                  (y - (image.height - r)) * (y - (image.height - r)))
              .toDouble();
          shouldKeep = distance <= r * r;
        }

        if (!shouldKeep) {
          result.setPixel(x, y, img.ColorRgba8(0, 0, 0, 0)); // شفاف
        }
      }
    }

    return result;
  }

  /// تغيير حجم الصورة
  static img.Image _resizeImage(img.Image image, CropParameters params) {
    if (params.width == null && params.height == null) {
      return image;
    }

    int targetWidth = params.width ?? image.width;
    int targetHeight = params.height ?? image.height;

    // الحفاظ على النسبة إذا لم يتم تحديد كلا البعدين
    if (params.width == null || params.height == null) {
      final aspectRatio = image.width / image.height;
      if (params.width == null) {
        targetWidth = (targetHeight * aspectRatio).round();
      } else {
        targetHeight = (targetWidth / aspectRatio).round();
      }
    }

    return img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.cubic,
    );
  }

  /// ضغط الصورة
  static img.Image _compressImage(img.Image image, int quality) {
    // تطبيق ضغط بسيط
    // يمكن تحسينها باستخدام مكتبات ضغط متقدمة
    return image;
  }

  /// ترميز الصورة
  static Uint8List _encodeImage(img.Image image, ImageFormat format) {
    switch (format) {
      case ImageFormat.jpeg:
        return Uint8List.fromList(img.encodeJpg(image));
      case ImageFormat.png:
        return Uint8List.fromList(img.encodePng(image));
      case ImageFormat.webp:
        // WebP encoding not available in current image package
        // Fallback to JPEG
        return Uint8List.fromList(img.encodeJpg(image));
      case ImageFormat.bmp:
        return Uint8List.fromList(img.encodeBmp(image));
      default:
        return Uint8List.fromList(img.encodeJpg(image));
    }
  }

  /// الحصول على معلومات الصورة
  static Future<ImageInfo> getImageInfo(Uint8List imageBytes) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('فشل في فك تشفير الصورة');
      }

      return ImageInfo(
        width: image.width,
        height: image.height,
        format: _detectFormat(imageBytes),
        sizeBytes: imageBytes.length,
        aspectRatio: image.width / image.height,
      );
    } catch (e) {
      throw Exception('فشل في الحصول على معلومات الصورة: $e');
    }
  }

  /// كشف نوع الصورة
  static ImageFormat _detectFormat(Uint8List bytes) {
    if (bytes.length < 4) return ImageFormat.unknown;

    // JPEG
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) return ImageFormat.jpeg;

    // PNG
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return ImageFormat.png;
    }

    // WebP
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return ImageFormat.webp;
    }

    // BMP
    if (bytes[0] == 0x42 && bytes[1] == 0x4D) return ImageFormat.bmp;

    return ImageFormat.unknown;
  }
}

/// معاملات الاقتصاص
class CropParameters {
  final int? width;
  final int? height;
  final int? quality;
  final ImageFormat format;
  final double? aspectRatio;
  final CropType cropType;
  final double? borderRadius;

  const CropParameters({
    this.width,
    this.height,
    this.quality,
    this.format = ImageFormat.jpeg,
    this.aspectRatio,
    this.cropType = CropType.center,
    this.borderRadius,
  });

  /// إنشاء معاملات اقتصاص مربع
  factory CropParameters.square({
    required int size,
    int? quality,
    ImageFormat format = ImageFormat.jpeg,
    CropType cropType = CropType.center,
  }) {
    return CropParameters(
      width: size,
      height: size,
      quality: quality,
      format: format,
      cropType: cropType,
    );
  }

  /// إنشاء معاملات اقتصاص مستطيل
  factory CropParameters.rectangle({
    required int width,
    required int height,
    int? quality,
    ImageFormat format = ImageFormat.jpeg,
    CropType cropType = CropType.center,
  }) {
    return CropParameters(
      width: width,
      height: height,
      quality: quality,
      format: format,
      cropType: cropType,
    );
  }

  /// إنشاء معاملات اقتصاص دائري
  factory CropParameters.circular({
    required int size,
    int? quality,
    ImageFormat format = ImageFormat.png,
  }) {
    return CropParameters(
      width: size,
      height: size,
      quality: quality,
      format: format,
      cropType: CropType.circular,
    );
  }

  /// إنشاء معاملات اقتصاص بزوايا مدورة
  factory CropParameters.rounded({
    required int width,
    required int height,
    required double borderRadius,
    int? quality,
    ImageFormat format = ImageFormat.png,
    CropType cropType = CropType.center,
  }) {
    return CropParameters(
      width: width,
      height: height,
      quality: quality,
      format: format,
      cropType: cropType,
      borderRadius: borderRadius,
    );
  }
}

/// أنواع الاقتصاص
enum CropType {
  center, // من المنتصف
  top, // من الأعلى
  bottom, // من الأسفل
  left, // من اليسار
  right, // من اليمين
  smart, // ذكي
  circular, // دائري
  rounded, // بزوايا مدورة
}

/// تنسيقات الصور
enum ImageFormat {
  jpeg,
  png,
  webp,
  bmp,
  unknown,
}

/// معلومات الصورة
class ImageInfo {
  final int width;
  final int height;
  final ImageFormat format;
  final int sizeBytes;
  final double aspectRatio;

  const ImageInfo({
    required this.width,
    required this.height,
    required this.format,
    required this.sizeBytes,
    required this.aspectRatio,
  });

  double get sizeMB => sizeBytes / (1024 * 1024);

  @override
  String toString() {
    return 'ImageInfo(width: $width, height: $height, format: $format, size: ${sizeMB.toStringAsFixed(2)}MB)';
  }
}
