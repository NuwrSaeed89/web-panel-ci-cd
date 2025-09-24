// import 'package:brothers_creative/common/widgets/custom_shapes/containers/rounded_container.dart';
// import 'package:brothers_creative/common/widgets/texts/product_title_text.dart';
// import 'package:brothers_creative/features/blog/model/blog_model.dart';
// import 'package:brothers_creative/utils/constants/color.dart';
// import 'package:brothers_creative/utils/constants/sizes.dart';
// import 'package:brothers_creative/utils/helpers/helper_functions.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class TBlogItem extends StatelessWidget {
//   const TBlogItem({Key? key, required this.blog, required this.onTap})
//       : super(key: key);

//   final VoidCallback onTap;
//   final BlogModel blog;
//   @override
//   Widget build(BuildContext context) {
//     final isEg = Get.locale?.languageCode == 'en';
//     final image = blog.images![1];
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.only(
//             left: TSizes.defaultSpace, right: TSizes.defaultSpace),
//         child: TRoundedContainer(
//           radius: BorderRadius.circular(20),
//           padding: const EdgeInsets.all(TSizes.md),
//           width: double.infinity,
//           enableShadow: true,
//           backgroundColor: Colors.transparent,
//           borderColor: THelperFunctions.isDarkMode(context)
//               ? TColors.darkerGray
//               : TColors.grey,
//           margin: const EdgeInsets.only(bottom: TSizes.spaceBtWItems),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Expanded(child: Image(image: AssetImage(TImages.appleIcon))),

//               CachedNetworkImage(
//                 imageBuilder: (context, imageProvider) => Container(
//                   width: double.infinity,
//                   height: 200,

//                   //height: 110,
//                   decoration: BoxDecoration(
//                     // border:
//                     //     Border.all(color: TColors.grey.withValues(alpha:0.4)),
//                     borderRadius: BorderRadius.circular(10),
//                     image: DecorationImage(
//                         image: imageProvider, fit: BoxFit.contain),
//                   ),
//                 ),
//                 imageUrl: image,
//                 placeholder: (context, url) => Container(
//                     alignment: Alignment.center,
//                     child: const CircularProgressIndicator()),
//               ),
//               const SizedBox(
//                 height: TSizes.sm * 2,
//               ),
//               Text(
//                 isEg ? blog.title : blog.arabicTitle,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//               const SizedBox(
//                 height: TSizes.sm / 2,
//               ),
//               TProductTitleText(
//                 title: isEg ? blog.auther : blog.arabicAuther,
//                 smalSize: true,
//                 maxLines: 2,
//               ),
//               const SizedBox(
//                 height: TSizes.sm / 2,
//               ),
//               Text(
//                 isEg ? blog.details : blog.arabicDetails,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 softWrap: true,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
