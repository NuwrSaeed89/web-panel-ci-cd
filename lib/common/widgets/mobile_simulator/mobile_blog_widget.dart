import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/blog_controller.dart';
import 'package:brother_admin_panel/data/models/blog_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MobileBlogWidget extends StatelessWidget {
  const MobileBlogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BlogController>(
      builder: (blogController) {
        final themeController = Get.find<ThemeController>();
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'blog'.tr,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              
              // قائمة مقالات المدونة
              Obx(() {
                if (blogController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (blogController.blogs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined, 
                          size: 64, 
                          color: themeController.isDarkMode ? Colors.white54 : Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'noBlogPosts'.tr,
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 16,
                            color: themeController.isDarkMode ? Colors.white70 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: blogController.blogs.length,
                  itemBuilder: (_, index) {
                    final blog = blogController.blogs[index];
                    return _buildBlogCard(blog, themeController);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBlogCard(BlogModel blog, ThemeController themeController) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: themeController.isDarkMode 
            ? const Color(0xFF2a2a3e) 
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeController.isDarkMode 
              ? Colors.white24 
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المقال
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: CachedNetworkImage(
              imageUrl: (blog.images != null && blog.images!.isNotEmpty) 
                  ? blog.images!.first 
                  : 'https://via.placeholder.com/400x200',
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 180,
                color: themeController.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 180,
                color: themeController.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                child: Icon(
                  Icons.image_not_supported,
                  color: themeController.isDarkMode ? Colors.white54 : Colors.grey,
                ),
              ),
            ),
          ),
          
          // محتوى المقال
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان المقال
                Text(
                  Get.locale?.languageCode == 'en' 
                      ? blog.title
                      : blog.arabicTitle,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // تفاصيل المقال
                Text(
                  Get.locale?.languageCode == 'en' 
                      ? blog.details
                      : blog.arabicDetails,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans Arabic',
                    fontSize: 14,
                    color: themeController.isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // معلومات إضافية
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // المؤلف
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: themeController.isDarkMode ? Colors.white60 : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Get.locale?.languageCode == 'en' 
                              ? blog.auther
                              : blog.arabicAuther,
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 12,
                            color: themeController.isDarkMode ? Colors.white60 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    
                    // تاريخ النشر
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: themeController.isDarkMode ? Colors.white60 : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          blog.editTime != null 
                              ? _formatDate(blog.editTime!)
                              : 'Unknown Date',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Arabic',
                            fontSize: 12,
                            color: themeController.isDarkMode ? Colors.white60 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${'daysAgo'.tr}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${'hoursAgo'.tr}';
    } else {
      return 'justNow'.tr;
    }
  }
}
