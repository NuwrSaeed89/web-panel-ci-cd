import 'dart:io';

import 'dart:typed_data';

import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:brother_admin_panel/utils/constants/enums.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    Key? key,
    this.width = 56,
    this.height = 56,
    this.file,
    this.image,
    this.memoryImage,
    required this.imageType,
    this.applyImageRaduis = true,
    this.border,
    this.backgroundColor = TColors.light,
    this.overLayColor,
    this.fit = BoxFit.contain,
    this.padding = TSizes.sm,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRaduis = TSizes.md,
  }) : super(key: key);
  final double width, height, padding;
  final File? file;
  final String? image;
  final Uint8List? memoryImage;
  final bool applyImageRaduis;
  final BoxBorder? border;
  final Color backgroundColor;
  final Color? overLayColor;
  final BoxFit? fit;
  final ImageType imageType;

  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRaduis;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
              border: border,
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRaduis)),
          child: _buildEmageWidget()),
    );
  }

  Widget _buildEmageWidget() {
    Widget imageWidget;

    switch (imageType) {
      case ImageType.network:
        imageWidget = _buildMemoryImage();
        break;
      case ImageType.memory:
        imageWidget = _buildMemoryImage();
        break;
      case ImageType.file:
        imageWidget = _buildFileImage();
        break;
      case ImageType.asset:
        imageWidget = _buildAssetImage();
        break;
    }

    return ClipRRect(
        borderRadius: applyImageRaduis
            ? BorderRadius.circular(borderRaduis)
            : BorderRadius.zero,
        child: imageWidget);
  }

  Widget _buildMemoryImage() {
    if (memoryImage != null) {
      return Image(
        fit: fit,
        image: MemoryImage(memoryImage!),
        color: overLayColor,
      );
    } else {
      return Container();
    }
  }

  // Widget _buildNetworkImage() {
  //   if (image != null) {
  //     return CachedNetworkImage(
  //       fit: fit,
  //       color: overLayColor,
  //       progressIndicatorBuilder: (context, url, progress) => Center(
  //         child: CircularProgressIndicator(
  //           value: progress.progress,
  //         ),
  //       ),
  //       imageUrl: image!,
  //     );

  //     //  CachedNetworkImage(
  //     //   fit: fit,
  //     //   imageUrl: image!,
  //     //   color: overLayColor,
  //     //   errorWidget: (context, url, error) => const Icon(Icons.error),
  //     //   progressIndicatorBuilder: (context, url, downloadProgress) =>
  //     //       TShimmerEffect(width: width, height: height),
  //     // );
  //   } else {
  //     return Container();
  //   }
  // }

  Widget _buildFileImage() {
    if (file != null) {
      return Image(
        fit: fit,
        image: FileImage(file!),
        color: overLayColor,
      );
    } else {
      return Container();
    }
  }

  Widget _buildAssetImage() {
    if (image != null) {
      return Image(
        fit: fit,
        image: AssetImage(image!),
        color: overLayColor,
      );
    } else {
      return Container();
    }
  }
}
