import 'package:brother_admin_panel/features/dashboard/widgets/blog/build_image_section.dart';
import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brother_admin_panel/utils/controllers/theme_controller.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/blog_controller.dart';
import 'package:brother_admin_panel/data/models/blog_model.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل المقالات عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final blogController = Get.find<BlogController>();
      blogController.fetchBlogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDark = themeController.isDarkMode;

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 600;
            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(isMobile ? 16 : 20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF16213e) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black26 : Colors.grey.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: isMobile
                        ? Column(
                            children: [
                              Text(
                                'blogManagement'.tr,
                                style: TTextStyles.heading3.copyWith(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Column(
                                children: [
                                  Obx(() {
                                    final controller =
                                        Get.find<BlogController>();
                                    return SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: controller.isFormMode.value
                                            ? controller.hideForm
                                            : controller.showAddForm,
                                        icon: Icon(
                                          controller.isFormMode.value
                                              ? Icons.close
                                              : Icons.add,
                                          size: 18,
                                        ),
                                        label: Text(
                                          controller.isFormMode.value
                                              ? 'cancel'.tr
                                              : 'addArticle'.tr,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              controller.isFormMode.value
                                                  ? Colors.red
                                                  : const Color(0xFF0055ff),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        final controller =
                                            Get.find<BlogController>();
                                        controller.addTestData();
                                      },
                                      icon: const Icon(Icons.data_object,
                                          size: 18),
                                      label: Text(
                                        'addTestData'.tr,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'blogManagement'.tr,
                                style: TTextStyles.heading2.copyWith(
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Row(
                                children: [
                                  Obx(() {
                                    final controller =
                                        Get.find<BlogController>();
                                    return ElevatedButton.icon(
                                      onPressed: controller.isFormMode.value
                                          ? controller.hideForm
                                          : controller.showAddForm,
                                      icon: Icon(controller.isFormMode.value
                                          ? Icons.close
                                          : Icons.add),
                                      label: Text(controller.isFormMode.value
                                          ? 'cancel'.tr
                                          : 'addArticle'.tr),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            controller.isFormMode.value
                                                ? Colors.red
                                                : const Color(0xFF0055ff),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                      ),
                                    );
                                  }),
                                  // const SizedBox(width: 12),
                                  // ElevatedButton.icon(
                                  //   onPressed: () {
                                  //     final controller =
                                  //         Get.find<BlogController>();
                                  //     controller.addTestData();
                                  //   },
                                  //   icon: const Icon(Icons.data_object),
                                  //   label: const Text('إضافة بيانات تجريبية'),
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: Colors.green,
                                  //     foregroundColor: Colors.white,
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 20, vertical: 12),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Form Section
                  Obx(() {
                    final controller = Get.find<BlogController>();
                    if (controller.isFormMode.value) {
                      return _buildBlogForm(controller, isDark);
                    }
                    return const SizedBox.shrink();
                  }),

                  // Content Section
                  Obx(() {
                    final controller = Get.find<BlogController>();
                    if (!controller.isFormMode.value) {
                      return _buildContentSection(controller, isDark);
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBlogForm(BlogController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16213e) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.isEditMode.value
                    ? 'editArticle'.tr
                    : 'addNewArticle'.tr,
                style: TTextStyles.heading3.copyWith(
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              const BuildImageSection(),
              const SizedBox(height: 24),

              // Title Fields
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.titleController,
                      label: 'titleInEnglish'.tr,
                      isDark: isDark,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.arabicTitleController,
                      label: 'titleInArabic'.tr,
                      isDark: isDark,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Author Fields
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.authorController,
                      label: 'authorInEnglish'.tr,
                      hintText: 'Brother Creative (افتراضي)',
                      isDark: isDark,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.arabicAuthorController,
                      label: 'authorInArabic'.tr,
                      hintText: 'defaultAuthorHintAr'.tr,
                      isDark: isDark,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Details Fields
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.detailsController,
                      label: 'contentInEnglish'.tr,
                      isDark: isDark,
                      maxLines: 6,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.arabicDetailsController,
                      label: 'contentInArabic'.tr,
                      isDark: isDark,
                      maxLines: 6,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Active Status
              Row(
                children: [
                  Obx(() {
                    final controller = Get.find<BlogController>();
                    return Switch(
                      value: controller.isActive.value,
                      onChanged: (value) {
                        controller.isActive.value = value;
                      },
                      activeColor: Colors.blue,
                    );
                  }),
                  const SizedBox(width: 8),
                  Text(
                    'active'.tr,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Images Section

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: controller.hideForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text('cancel'.tr),
                  ),
                  const SizedBox(width: 16),
                  Obx(() {
                    final controller = Get.find<BlogController>();
                    return ElevatedButton(
                      onPressed: controller.isUploading.value
                          ? null
                          : (controller.isEditMode.value
                              ? controller.updateBlog
                              : controller.createBlog),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0055ff),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: controller.isUploading.value
                          ? Text('saving'.tr)
                          : Text(controller.isEditMode.value
                              ? 'update'.tr
                              : 'save'.tr),
                    );
                  }),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isDark,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.left,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textAlign: textAlign,
      textDirection:
          textAlign == TextAlign.right ? TextDirection.rtl : TextDirection.ltr,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
        ),
        hintStyle: TextStyle(
          color: isDark ? Colors.white54 : Colors.black38,
          fontSize: 14,
        ),
        filled: true,
        fillColor: isDark ? Colors.white10 : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey.shade400,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 16,
      ),
    );
  }

  Widget _buildContentSection(BlogController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16213e) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 600;
              return TextField(
                onChanged: controller.searchBlogs,
                decoration: InputDecoration(
                  hintText: 'searchInArticles'.tr,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: isMobile ? 14 : 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.white54 : Colors.black54,
                    size: isMobile ? 20 : 24,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 20,
                    vertical: isMobile ? 12 : 16,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: isMobile ? 14 : 16,
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Blog Posts List
          Obx(() {
            final controller = Get.find<BlogController>();
            if (controller.isLoading.value) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark ? Colors.white : Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'loadingArticles'.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (controller.filteredBlogs.isEmpty) {
              return SizedBox(
                height: 250, // زيادة الارتفاع
                child: Center(
                  child: SingleChildScrollView(
                    // إضافة SingleChildScrollView
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 64,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'noArticles'.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'startByAddingArticle'.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black45,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: controller.refreshData,
                          icon: const Icon(Icons.refresh),
                          label: Text('reload'.tr),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final bool isMobile = constraints.maxWidth < 600;
                final bool isTablet = constraints.maxWidth < 1000;

                // تحديد عدد الأعمدة حسب حجم الشاشة
                int crossAxisCount;
                double childAspectRatio;
                double crossAxisSpacing;
                double mainAxisSpacing;

                if (isMobile) {
                  crossAxisCount = 1;
                  childAspectRatio = 1.2;
                  crossAxisSpacing = 0;
                  mainAxisSpacing = 12;
                } else if (isTablet) {
                  crossAxisCount = 2;
                  childAspectRatio = 1.1;
                  crossAxisSpacing = 16;
                  mainAxisSpacing = 16;
                } else {
                  crossAxisCount = 3;
                  childAspectRatio = 1.0;
                  crossAxisSpacing = 20;
                  mainAxisSpacing = 20;
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: mainAxisSpacing,
                  ),
                  itemCount: controller.filteredBlogs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final blog = controller.filteredBlogs[index];
                    return _buildBlogCard(blog, controller, isDark, isMobile);
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBlogCard(
      BlogModel blog, BlogController controller, bool isDark, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? TColors.darkCard : TColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? TColors.darkCard : TColors.lightCard,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section with PageView for multiple images
          Expanded(
            flex: 5, // زيادة المساحة للصور
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: isDark ? TColors.darkCard : TColors.lightCard,
              ),
              child: blog.images != null && blog.images!.isNotEmpty
                  ? _buildImageSection(blog, isDark, isMobile)
                  : _buildNoImagePlaceholder(isDark),
            ),
          ),

          // Content Section
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    blog.arabicTitle.isNotEmpty ? blog.arabicTitle : blog.title,
                    style: TTextStyles.heading4.copyWith(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Content Preview
                  Expanded(
                    child: Text(
                      blog.arabicDetails.isNotEmpty
                          ? blog.arabicDetails
                          : blog.details,
                      style: TTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.grey.shade600,
                        fontSize: isMobile ? 11 : 12,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Status and Author
                  Row(
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: blog.active
                              ? (isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade200)
                              : (isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: blog.active
                                ? (isDark
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade400)
                                : (isDark
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade300),
                          ),
                        ),
                        child: Text(
                          blog.active ? 'active'.tr : 'inactive'.tr,
                          style: TTextStyles.labelSmall.copyWith(
                            color: blog.active
                                ? (isDark ? Colors.white : Colors.black87)
                                : (isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Author
                      Icon(
                        Icons.person,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          blog.arabicAuther.isNotEmpty
                              ? blog.arabicAuther
                              : blog.auther,
                          style: TTextStyles.caption.copyWith(
                            color: isDark
                                ? Colors.grey.shade300
                                : Colors.grey.shade600,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        blog.editTime != null
                            ? '${blog.editTime!.day}/${blog.editTime!.month}/${blog.editTime!.year}'
                            : 'notSpecified'.tr,
                        style: TTextStyles.caption.copyWith(
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Edit Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.showEditForm(blog),
                    icon: const Icon(Icons.edit, size: 16),
                    label: Text(
                      'edit'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                      foregroundColor: isDark ? Colors.white : Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Delete Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showDeleteDialog(blog, controller),
                    icon: const Icon(Icons.delete, size: 16),
                    label: Text(
                      'delete'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      foregroundColor:
                          isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Toggle Status Button
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    onPressed: () => controller.toggleActiveStatus(blog),
                    icon: Icon(
                      blog.active ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: blog.active
                          ? (isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade200)
                          : (isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade100),
                      foregroundColor: isDark ? Colors.white : Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة لبناء قسم الصور مع PageView للصور المتعددة
  Widget _buildImageSection(BlogModel blog, bool isDark, bool isMobile) {
    if (blog.images == null || blog.images!.isEmpty) {
      return _buildNoImagePlaceholder(isDark);
    }

    if (blog.images!.length == 1) {
      // صورة واحدة فقط
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Image.network(
          blog.images!.first,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildImageError(isDark);
          },
        ),
      );
    } else {
      // صور متعددة - PageView مع نقاط
      return _buildImageSlider(blog, isDark);
    }
  }

  // دالة لبناء سلايدر الصور مع PageController
  Widget _buildImageSlider(BlogModel blog, bool isDark) {
    return StatefulBuilder(
      builder: (context, setState) {
        final PageController pageController = PageController();
        int currentPage = 0;

        return Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: blog.images!.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    blog.images![index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImageError(isDark);
                    },
                  ),
                );
              },
            ),
            // نقاط المؤشر
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  blog.images!.length,
                  (index) => GestureDetector(
                    onTap: () {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == currentPage
                            ? (isDark ? Colors.white : Colors.black)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.4)
                                : Colors.black.withValues(alpha: 0.4)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // أزرار التنقل (اختيارية)
            if (blog.images!.length > 1) ...[
              // زر السابق
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (currentPage > 0) {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: isDark ? Colors.white : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              // زر التالي
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (currentPage < blog.images!.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: isDark ? Colors.white : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // دالة لبناء placeholder عند عدم وجود صور
  Widget _buildNoImagePlaceholder(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            size: 64,
          ),
          const SizedBox(height: 12),
          Text(
            'noImage'.tr,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // دالة لبناء رسالة خطأ الصورة
  Widget _buildImageError(bool isDark) {
    return Container(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'imageLoadError'.tr,
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BlogModel blog, BlogController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('confirmDelete'.tr),
        content: Text('confirmDeleteArticle'.tr.replaceAll('{title}',
            blog.arabicTitle.isNotEmpty ? blog.arabicTitle : blog.title)),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteBlog(blog.id);
            },
            child: Text('delete'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
