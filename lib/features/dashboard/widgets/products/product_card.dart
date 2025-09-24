import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:brother_admin_panel/data/models/product_model.dart';
import 'package:brother_admin_panel/features/dashboard/controllers/product_controller.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isDark;
  final ProductController controller;

  const ProductCard({
    super.key,
    required this.product,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      margin: EdgeInsets.only(
        bottom: isMobile ? 8 : 12,
        left: ResponsiveHelper.isMobile(context) ? 0 : 8,
        right: ResponsiveHelper.isMobile(context) ? 0 : 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1a2e) : Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        border:
            Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        boxShadow: isDark
            ? [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ]
            : [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
      ),
      child: LayoutBuilder(
        // استخدام LayoutBuilder لحساب المساحة المتاحة
        builder: (context, constraints) {
          // حساب ارتفاع الصورة بناءً على العرض المتاح
          final imageHeight = (constraints.maxWidth * 8) / 6; // نسبة 6:8

          return Column(
            mainAxisSize: MainAxisSize.min, // منع التمدد الزائد
            children: [
              // Product Image - نسبة 6:8
              SizedBox(
                height: imageHeight, // ارتفاع محسوب بدقة
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(isMobile ? 12 : 16)),
                    color: isDark ? Colors.black12 : Colors.grey.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(isMobile ? 12 : 16)),
                    child: product.thumbnail.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.thumbnail,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black26
                                    : Colors.grey.shade200,
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDark
                                        ? Colors.white54
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.black26
                                        : Colors.grey.shade200),
                                child: Icon(Icons.error,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.grey.shade600,
                                    size: isMobile ? 24 : 32),
                              );
                            },
                          )
                        : Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black26
                                    : Colors.grey.shade200),
                            child: Icon(Icons.image,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey.shade600,
                                size: isMobile ? 24 : 32),
                          ),
                  ),
                ),
              ),

              // Product Info - استخدام المساحة المتبقية
              Container(
                // استخدام Container مع padding ثابت
                padding: EdgeInsets.all(isMobile ? 6 : 8), // تقليل المسافات
                child: Column(
                  mainAxisSize: MainAxisSize.min, // منع التمدد الزائد
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      product.title,
                      style: (isMobile
                              ? TTextStyles.bodySmall
                              : TTextStyles.bodyMedium)
                          .copyWith(
                        // استخدام bodySmall بدلاً من bodyMedium
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isMobile ? 3 : 4), // تقليل المسافات

                    // Brand Name
                    if (product.brand != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.branding_watermark,
                            size: isMobile ? 8 : 10, // تقليل حجم الأيقونة
                            color:
                                isDark ? Colors.white70 : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 3), // تقليل المسافات
                          Expanded(
                            child: Text(
                              product.brand!.name,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey.shade600,
                                fontSize: isMobile ? 8 : 10, // تقليل حجم الخط
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 3 : 4), // تقليل المسافات
                    ],

                    // Price and Stock
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product.price.toStringAsFixed(2)} ر.س',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.green
                                      : Colors.green.shade700,
                                  fontSize: isMobile ? 9 : 11, // تقليل حجم الخط
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'المخزون: ${product.stock}',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                                  fontSize:
                                      isMobile ? 7 : 9, // تقليل حجم الخط أكثر
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Feature indicator
                        if (product.isFeature == true)
                          Icon(Icons.star,
                              color: Colors.amber,
                              size: isMobile
                                  ? 10
                                  : 12), // تقليل حجم الأيقونة أكثر
                      ],
                    ),

                    SizedBox(height: isMobile ? 6 : 8), // مسافة مناسبة

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            onPressed: () => controller.showEditForm(product),
                            icon: Icon(Icons.edit,
                                color: isDark
                                    ? TColors.primary
                                    : Colors.blue.shade700,
                                size: isMobile
                                    ? 12
                                    : 14), // تقليل حجم الأيقونة أكثر
                            tooltip: 'تعديل',
                            padding: EdgeInsets.all(isMobile
                                ? 1
                                : 2), // تقليل المساحة الداخلية أكثر
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () =>
                                controller.toggleFeatureStatus(product.id),
                            icon: Icon(
                                product.isFeature == true
                                    ? Icons.star
                                    : Icons.star_border,
                                color: product.isFeature == true
                                    ? Colors.amber
                                    : (isDark
                                        ? Colors.white70
                                        : Colors.grey.shade600),
                                size: isMobile
                                    ? 12
                                    : 14), // تقليل حجم الأيقونة أكثر
                            tooltip: product.isFeature == true
                                ? 'إلغاء التمييز'
                                : 'تمييز',
                            padding: EdgeInsets.all(isMobile
                                ? 1
                                : 2), // تقليل المساحة الداخلية أكثر
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () => _showDeleteConfirmation(
                                context, isDark, product, controller),
                            icon: Icon(Icons.delete,
                                color:
                                    isDark ? Colors.red : Colors.red.shade700,
                                size: isMobile
                                    ? 12
                                    : 14), // تقليل حجم الأيقونة أكثر
                            tooltip: 'حذف',
                            padding: EdgeInsets.all(isMobile
                                ? 1
                                : 2), // تقليل المساحة الداخلية أكثر
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, bool isDark,
      ProductModel product, ProductController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1a1a2e) : Colors.white,
          title: Text(
            'تأكيد الحذف',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: ResponsiveHelper.isMobile(context) ? 18 : 20,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف المنتج "${product.title}"؟',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteProduct(product.id);
              },
              child: Text(
                'حذف',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
