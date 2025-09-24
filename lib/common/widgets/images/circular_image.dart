// // ignore_for_file: public_member_api_docs, sort_constructors_first

// import 'package:brother_admin_panel/common/widgets/shimmers/shimmer.dart';
// import 'package:brother_admin_panel/utils/constants/color.dart';
// import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
// //import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class TCircularImage extends StatelessWidget {
//   const TCircularImage({
//     Key? key,
//     this.width = 56,
//     this.height = 56,
//     this.fit = BoxFit.cover,
//     required this.image,
//     this.isNetworkImage = false,
//     this.padding = 1,
//     this.overLayColor,
//     this.backgroundColor,
//   }) : super(key: key);

//   final BoxFit? fit;
//   final String image;
//   final bool isNetworkImage;
//   final double width, height, padding;
//   final Color? overLayColor;
//   final Color? backgroundColor;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: width,
//         height: height,
//         padding: EdgeInsets.all(padding),
//         decoration: BoxDecoration(
//             color: backgroundColor ??
//                 (THelperFunctions.isDarkMode(context)
//                     ? TColors.black
//                     : TColors.white),
//             borderRadius: BorderRadius.circular(100)),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(100),
//           child: Center(
//             child: isNetworkImage
//                 ? CachedNetworkImage(
//                     fit: fit,
//                     color: overLayColor,
//                     imageUrl: image,
//                     progressIndicatorBuilder:
//                         (context, url, downloadProgress) => ClipRRect(
//                             borderRadius: BorderRadius.circular(100),
//                             child:
//                                 const TShimmerEffect(width: 80, height: 800)),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.error))
//                 : Image(
//                     color: overLayColor,
//                     fit: fit,
//                     image: AssetImage(image),
//                   ),
//           ),
//         ));
//   }
// }
