// import 'package:brothers_creative/common/widgets/images/custom_cache_image.dart';
// import 'package:brothers_creative/common/widgets/shimmers/home_album_shimmer.dart';
// import 'package:brothers_creative/common/widgets/shimmers/shimmer.dart';
// import 'package:brothers_creative/features/gallery/controller/album_controller.dart';
// import 'package:brothers_creative/features/gallery/models/album_model.dart';
// import 'package:brothers_creative/features/shop/screens/home/widgets/album_photos.dart';
// import 'package:brothers_creative/l10n/app_localizations.dart';
// import 'package:brothers_creative/utils/constants/sizes.dart';
// import 'package:brothers_creative/utils/helpers/helper_functions.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class TAlbumList extends StatelessWidget {
//   const TAlbumList({super.key});

//   @override
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(AlbumController());
//     final isEg = Get.locale?.languageCode == 'en';
//     final List<AlbumModel> albums = [];
//     return Padding(
//       padding: const EdgeInsets.only(
//         left: TSizes.defaultSpace,
//         right: TSizes.defaultSpace,
//       ),
//       child: Obx(() {
//         albums.assignAll(controller.allalbums);

      

//         if (controller.isLoading.value) return const THomeAlbumShimmer();
//         if (albums.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.photo_album_outlined, size: 64, color: Colors.grey),
//                 const SizedBox(height: TSizes.spaceBtWItems),
//                 Text(
//                   AppLocalizations.of(context)!.noData,
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 const SizedBox(height: TSizes.spaceBtWItems),
//                 if (kDebugMode)
//                   Text(
//                     'Debug: ${controller.allalbums.length} albums loaded',
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodySmall?.copyWith(color: Colors.grey),
//                   ),
//               ],
//             ),
//           );
//         }

//         return SizedBox(
//           width: THelperFunctions.screenwidth() - 32,
//           child: ListView.builder(
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: albums.length,
//             itemBuilder: (_, index) {
//               return GestureDetector(
//                 onTap:
//                     () => Get.to(TSingleAlbumPhotoView(album: albums[index])),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     bottom: TSizes.spaceBtWsections,
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       //TRoundedImage(imageUrl: albums[index].image!),
//                       GestureDetector(
//                         onTap:
//                             () => Get.to(
//                               TSingleAlbumPhotoView(album: albums[index]),
//                             ),
//                         child: CustomCaChedNetworkImage(
//                           fit: BoxFit.fill,
//                           raduis: BorderRadius.circular(20),
//                           width:
//                               THelperFunctions.screenwidth() -
//                               TSizes.defaultSpace * 2,
//                           height: THelperFunctions.screenwidth() / 1.7,
//                           // color: TColors.darkGrey.withValues(alpha:0.1),
//                           url: albums[index].image!,
//                         ),
//                       ),

                     
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             isEg
//                                 ? albums[index].name
//                                 : albums[index].arabicName,
//                             textAlign: TextAlign.right,
//                             style: Theme.of(context).textTheme.labelLarge,
//                           ),
//                           TextButton(
//                             onPressed:
//                                 () => Get.to(
//                                   TSingleAlbumPhotoView(album: albums[index]),
//                                 ),
//                             child: Text(
//                               AppLocalizations.of(context)!.viewAll,
//                               style: Theme.of(context).textTheme.bodySmall,
//                             ),
//                           ),
//                           // IconButton(
//                           //     onPressed: () => Get.to(TSingleAlbumPhotoView(
//                           //         album: albums[index])),
//                           //     icon: Icon(
//                           //         isEg
//                           //             ? Iconsax.arrow_right
//                           //             : Iconsax.arrow_left_3,
//                           //         size: 30,
//                           //         color: Colors.black)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
// }
