import 'package:brother_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.width,
    required this.height,
    required this.url,
    this.enableShadow = true,
    this.enableBorder = false,
    this.fit = BoxFit.cover,
    required this.radius,
    this.placeholder,
    this.errorWidget,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  final double width;
  final double height;
  final bool enableShadow;
  final bool enableBorder;
  final BorderRadius radius;
  final String url;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    // التحقق من صحة URL
    if (url.isEmpty) {
      return _buildPlaceholderImage();
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      httpHeaders: const {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, HEAD',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
      placeholder: (context, url) => placeholder ?? _buildShimmerPlaceholder(),
      errorWidget: (context, url, error) {
        return errorWidget ?? _buildErrorWidget();
      },
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          boxShadow: enableShadow ? TColors.tboxShadow : null,
          borderRadius: radius,
          border:
              enableBorder ? Border.all(color: TColors.borderPrimary) : null,
          color: TColors.light,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return TShimmerEffect(
      width: width,
      height: height,
      raduis: radius,
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: radius,
        border: enableBorder ? Border.all(color: TColors.borderPrimary) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: width * 0.3,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 8),
          Text(
            'فشل في تحميل الصورة',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: radius,
        border: enableBorder ? Border.all(color: TColors.borderPrimary) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: width * 0.3,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            'لا توجد صورة',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
