// import 'package:brothers_creative/common/widgets/loaders/animation_loading.dart';
// import 'package:brothers_creative/features/blog/controller/blog_controller.dart';
// import 'package:brothers_creative/utils/constants/image_strings.dart';
// import 'package:brothers_creative/utils/helpers/cloud_helper_function.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:brothers_creative/l10n/app_localizations.dart';

// import 'blog_item.dart';
// import 'single_blog.dart';

// class BlogItems extends StatelessWidget {
//   const BlogItems({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = BlogController.instance;

//     return FutureBuilder(
//         future: controller.fetchUserblogs(),
//         builder: (_, snapshot) {
//           final emptyWidget = TAnimationLoaderWidget(
//             text: AppLocalizations.of(context)!.noNewsuntilNow,
//             animation: TImages.cartEmptyLottie,
//             showAction: false,
//             onActionPressed: () {},
//           );
//           final response = TCloudHelperFunctions.checkMuiltiRecordState(
//               snapshot: snapshot, nothingFound: emptyWidget);
//           if (response != null) return response;
//           final blogs = snapshot.data!;
//           return ListView.separated(
//               shrinkWrap: true,
//               itemCount: blogs.length,
//               separatorBuilder: (_, __) => const SizedBox(
//                     height: 0,
//                   ),
//               itemBuilder: (_, index) => TBlogItem(
//                     blog: blogs[index],
//                     onTap: () => Get.to(() => TSingleBlog(blog: blogs[index])),
//                   ));
//         });
//   }
// }
