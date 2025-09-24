// // ignore_for_file: public_member_api_docs, sort_constructors_first
// //
// import 'package:brothers_creative/common/widgets/custom_shapes/containers/circuler_container.dart';
// import 'package:brothers_creative/common/widgets/shimmers/shimmer.dart';
// import 'package:brothers_creative/features/general/screens/gallery_widget.dart';
// import 'package:brothers_creative/features/shop/controllers/banner_controller.dart';
// import 'package:brothers_creative/utils/constants/color.dart';
// import 'package:brothers_creative/utils/constants/sizes.dart';
// import 'package:brothers_creative/utils/helpers/helper_functions.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class TPromoSlider extends StatelessWidget {
//   const TPromoSlider({super.key, this.autoPlay = true, required this.images});
//   final List<String> images;
//   final bool autoPlay;
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(BannerController());
//     // List<String> images = controller.banners.map((e) => e.image).toList();
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const TShimmerEffect(width: double.infinity, height: 200);
//       }
//       if (images.isEmpty) {
//         return Center(
//           child: TShimmerEffect(
//             raduis: BorderRadius.circular(0),
//             width: THelperFunctions.screenwidth(),
//             height: 200,
//           ),
//         );
//       }
//       return Column(
//         children: [
//           CarouselSlider(
//             options: CarouselOptions(
//               autoPlay: autoPlay,
//               autoPlayCurve: Curves.linear,
//               viewportFraction: 1,
//               onPageChanged:
//                   (index, _) => controller.updatePageIndicator(index),
//             ),
//             items:
//                 images
//                     .map(
//                       (item) => CachedNetworkImage(
//                         fit: BoxFit.fill,
//                         // width: THelperFunctions.screenwidth() ,
//                         //height: THelperFunctions.screenwidth() / 1.7,
//                         // color: TColors.darkGrey.withValues(alpha:0.1),
//                         imageUrl: item,
//                         imageBuilder:
//                             (context, imageProvider) => GestureDetector(
//                               onTap: () {
//                                 Get.to(
//                                   GalleryWidget(
//                                     urlImage: images,
//                                     index: images.indexOf(item),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 width: THelperFunctions.screenwidth(),
//                                 height: 200,
//                                 decoration: BoxDecoration(
//                                   // borderRadius: BorderRadius.circular(0),
//                                   image: DecorationImage(
//                                     image: imageProvider,
//                                     fit: BoxFit.fitWidth,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         progressIndicatorBuilder:
//                             (context, url, downloadProgress) => ClipRRect(
//                               //  borderRadius: BorderRadius.circular(0),
//                               child: TShimmerEffect(
//                                 raduis: BorderRadius.circular(0),
//                                 width: THelperFunctions.screenwidth(),
//                                 height: 200,
//                               ),
//                             ),
//                         errorWidget:
//                             (context, url, error) =>
//                                 const Icon(Icons.error, size: 50),
//                       ),
//                     )
//                     .toList(),
//           ),
//           const SizedBox(height: TSizes.spaceBtWItems),
//           Obx(
//             () => Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 for (int i = 0; i < images.length; i++)
//                   TCirculerContainer(
//                     width: 20,
//                     height: 5,
//                     margin: const EdgeInsets.only(right: 5, left: 5),
//                     backgroundColor:
//                         controller.carousalCurrentIndex.value == i
//                             ? THelperFunctions.isDarkMode(context)
//                                 ? TColors.white
//                                 : TColors.black
//                             : THelperFunctions.isDarkMode(context)
//                             ? TColors.darkGrey
//                             : TColors.grey,
//                   ),
//               ],
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
