import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/category_controller.dart';
import 'package:brother_admin_panel/common/widgets/texts/section_heading.dart';
import 'package:brother_admin_panel/common/widgets/image_text_widets/vertical_image_text.dart';
import 'package:brother_admin_panel/common/widgets/shimmers/catrgory_shimmer.dart';
import 'package:brother_admin_panel/utils/constants/image_strings.dart';

class MobileCategoriesWidget extends StatelessWidget {
  const MobileCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        final themeController = Get.find<ThemeController>();
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان القسم
              TSectionHeading(
                textColor: themeController.isDarkMode ? Colors.white : Colors.black,
                title: 'Popular Category',
                showActionButton: false,
              ),
              const SizedBox(height: 16),
              
              // قائمة الفئات
              Obx(() {
                if (categoryController.isLoading) {
                  return const TCategoryShummer();
                }
                
                if (categoryController.categories.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد فئات',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans Arabic',
                        fontSize: 16,
                        color: themeController.isDarkMode ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  );
                }
                
                // تصفية الفئات المميزة فقط
                final featureCategories = categoryController.categories
                    .where((category) => category.isFeature)
                    .toList();
                
                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: featureCategories.length,
                    itemBuilder: (_, index) {
                      final category = featureCategories[index];
                      return TVerticalImageText(
                        textColor: themeController.isDarkMode ? Colors.white : Colors.black,
                        backgroundColor: themeController.isDarkMode 
                            ? const Color(0xFF2a2a3e) 
                            : Colors.white,
                        borderColor: themeController.isDarkMode 
                            ? Colors.white24 
                            : Colors.grey.shade200,
                        image: category.image.isEmpty ? TImages.bBlack : category.image,
                        isNetworkImage: category.image.isNotEmpty,
                        title: Get.locale?.languageCode == 'en'
                            ? category.name
                            : category.arabicName,
                        onTap: () {
                          // يمكن إضافة تفاعل هنا
                        },
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
