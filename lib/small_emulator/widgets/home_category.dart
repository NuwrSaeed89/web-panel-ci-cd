// import 'package:brother_admin_panel/common/widgets/shimmers/catrgory_shimmer.dart';
// import 'package:brother_admin_panel/features/dashboard/controllers/category_controller.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class THomeCategories extends StatelessWidget {
//   const THomeCategories({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final categoryController = Get.put(CategoryController());
//     return Obx(() {
//       if (categoryController.isLoading) return const TCategoryShummer();
//       if (categoryController.allCategories.isEmpty) {
//         return const Center(child: Text('no data'));
//       }
//       return SizedBox(
//         height: 150,
//         child: Padding(
//           padding: const EdgeInsets.only(top: 4.0, bottom: 4),
//           child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: categoryController.featureCategories.length,
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (_, index) {
//               final category = categoryController.featureCategories[index];
//               return TVerticalImageText(
//                 textColor:
//                     THelperFunctions.isDarkMode(context)
//                         ? Colors.white
//                         : Colors.black,
//                 image: category.image == "" ? TImages.bBlack : category.image,
//                 isNetworkImage: category.image == "" ? false : true,
//                 title:
//                     Get.locale?.languageCode == 'en'
//                         ? category.name
//                         : category.arabicName,
//                 onTap:
//                     () {},
//               );
//             },
//           ),
//         ),
//       );
//     });
//   }
// }
