// import 'package:brothers_creative/common/widgets/appbar/appbar.dart';
// import 'package:brothers_creative/common/widgets/layout/grid_layout.dart';
// import 'package:brothers_creative/common/widgets/shimmers/brand_shimmer.dart';
// import 'package:brothers_creative/features/shop/controllers/brand_controller.dart';
// import 'package:brothers_creative/features/shop/screens/store/brand/brand_card.dart';
// import 'package:brothers_creative/features/shop/screens/store/brand/brand_product.dart';

// import 'package:brothers_creative/utils/constants/sizes.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:brothers_creative/l10n/app_localizations.dart';

// class AllBrandScreen extends StatelessWidget {
//   const AllBrandScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = BrandController.instance;
//     return Directionality(
//       textDirection: Get.locale?.languageCode == 'en'
//           ? TextDirection.ltr
//           : TextDirection.rtl,
//       child: Scaffold(
//         appBar: TAppBar(
//           title: Text(
//             AppLocalizations.of(context)!.brands,
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//           showBackArrow: true,
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(TSizes.defaultSpace),
//               child: Column(
//                 children: [
//                   // TSectionHeading(
//                   //     title: AppLocalizations.of(context)!.brand,
//                   //     showActionButton: false),
//                   const SizedBox(
//                     height: TSizes.spaceBtWItems,
//                   ),
//                   Obx(() {
//                     if (controller.isLoading.value) {
//                       return TBrandShummer(
//                         itemCount: controller.allBrands.length,
//                       );
//                     }
//                     if (controller.allBrands.isEmpty) {
//                       return Center(
//                         child: Text(
//                           AppLocalizations.of(context)!.noData,
//                           style: Theme.of(context).textTheme.bodyMedium,
//                         ),
//                       );
//                     }
//                     return TGridLayout(
//                         itemCount: controller.allBrands.length,
//                         maxAxisExtent: 80,
//                         itemBuilder: (_, index) {
//                           return TBrandCard(
//                             showBorder: false,
//                             brand: controller.allBrands[index],
//                             onTap: () => Get.to(() => BrandProducts(
//                                   brand: controller.allBrands[index],
//                                 )),
//                           );
//                         });
//                   })
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
