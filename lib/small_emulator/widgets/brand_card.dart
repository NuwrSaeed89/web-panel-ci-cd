// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:brothers_creative/features/shop/models/brand_model.dart';
// import 'package:flutter/material.dart';

// import 'package:brothers_creative/common/widgets/custom_shapes/containers/rounded_container.dart';
// import 'package:brothers_creative/common/widgets/images/circular_image.dart';
// import 'package:brothers_creative/utils/constants/color.dart';
// import 'package:brothers_creative/utils/constants/image_strings.dart';
// import 'package:brothers_creative/utils/constants/sizes.dart';
// import 'package:brothers_creative/utils/helpers/helper_functions.dart';

// class TBrandCard extends StatelessWidget {
//   const TBrandCard({
//     Key? key,
//     required this.showBorder,
//     required this.brand,
//     this.onTap,
//   }) : super(key: key);
//   final BrandModel brand;
//   final bool showBorder;

//   final void Function()? onTap;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: TRoundedContainer(
//         showBorder: showBorder,
//         radius: BorderRadius.circular(15),
//         padding: const EdgeInsets.all(TSizes.sm),
//         backgroundColor:
//             THelperFunctions.isDarkMode(context)
//                 ? TColors.darkContainer
//                 : TColors.lightContainer,
//         child: Row(
//           children: [
//             Flexible(
//               child: TCircularImage(
//                 image: brand.image == '' ? TImages.bBlack : brand.image,
//                 isNetworkImage: brand.image == '' ? false : true,
//                 backgroundColor: Colors.transparent,
//               ),
//             ),
//             const SizedBox(height: TSizes.spaceBtWItems / 2),
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(brand.name),
//                   Text(
//                     ' ${brand.productCount ?? 0} Product ',
//                     style: Theme.of(context).textTheme.labelMedium,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
