// import 'dart:async';

// import 'package:brothers_creative/common/widgets/shimmers/client_shimmer.dart';
// import 'package:brothers_creative/common/widgets/shimmers/shimmer.dart';
// import 'package:brothers_creative/features/shop/controllers/clients_controller.dart';
// import 'package:brothers_creative/features/shop/models/clients_model.dart';
// import 'package:brothers_creative/features/shop/screens/home/clients_slider.dart';
// import 'package:brothers_creative/utils/constants/color.dart';
// import 'package:brothers_creative/utils/constants/sizes.dart';
// import 'package:brothers_creative/utils/helpers/helper_functions.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:brothers_creative/l10n/app_localizations.dart';

// class THomeClient extends StatelessWidget {
//   const THomeClient({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ClientController());

//     final List<ClientModel> featureClients = [];
//     return Padding(
//         padding: const EdgeInsets.only(
//             left: TSizes.defaultSpace, right: TSizes.defaultSpace),
//         child: Obx(() {
//           featureClients.assignAll(
//               controller.allClients.where((p0) => p0.isFeature).take(8));
//           if (controller.isLoading.value) return const TClientShimmer();
//           if (featureClients.isEmpty) {
//             return Center(
//               child: Text(
//                 AppLocalizations.of(context)!.noData,
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//             );
//           }

//           // featureCategories.assignAll(allCategories
//           //     .where((cat) => cat.isFeature && cat.parentId.isEmpty)
//           //     .take(8)
//           //     .toList());
//           return SizedBox(
//               height: 130,
//               child: ListView.builder(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: featureClients.length,
//                   itemBuilder: (_, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         Timer(const Duration(milliseconds: 3), () async {
//                           await Get.to(() => TClientSlider(
//                                 items: featureClients,
//                                 currentClient: index,
//                               ));

//                           //  Navigator.of(context).push(MaterialPageRoute(
//                           //     builder: (BuildContext context) =>
//                           //         ClientScreen(client: featureClients[index]))
//                         });

//                         // Navigator.push(
//                         //     context,
//                         //     PageRouteBuilder(
//                         //         transitionDuration:
//                         //             Duration(milliseconds: 30),
//                         //         pageBuilder: (_, __, ___) => ClientScreen(
//                         //             client: featureClients[index])));
//                       },

//                       //ClientScreen(client: featureClients[index])),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: TColors.light,
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                                 color: THelperFunctions.isDarkMode(context)
//                                     ? TColors.darkerGray
//                                     : TColors.grey),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(10),
//                             child: ClipRect(
//                               child: CachedNetworkImage(
//                                   // fit: BoxFit.contain,
//                                   width: THelperFunctions.screenwidth() / 3,
//                                   imageUrl: featureClients[index].thumbnail,
//                                   imageBuilder: (context, imageProvider) =>
//                                       Container(
//                                         // width: 400,
//                                         //height: THelperFunctions.screenwidth() / 1.7,
//                                         decoration: BoxDecoration(
//                                           image: DecorationImage(
//                                               image: imageProvider,
//                                               fit: BoxFit.contain),
//                                         ),
//                                       ),
//                                   progressIndicatorBuilder:
//                                       (context, url, downloadProgress) =>
//                                           ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(40),
//                                               child: TShimmerEffect(
//                                                   width: THelperFunctions
//                                                           .screenwidth() /
//                                                       3,
//                                                   height: 130)),
//                                   errorWidget: (context, url, error) =>
//                                       const Icon(
//                                         Icons.error,
//                                         size: 50,
//                                       )),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }));
//         }));
//   }
// }
