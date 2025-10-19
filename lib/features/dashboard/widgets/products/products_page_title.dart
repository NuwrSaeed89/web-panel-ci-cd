import 'package:flutter/material.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';
import 'package:get/get.dart';

class ProductsPageTitle extends StatelessWidget {
  final bool isDark;

  const ProductsPageTitle({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Text(
        'productsTitle'.tr,
        style: TTextStyles.heading2.copyWith(
          color: isDark ? Colors.white : Color(0xFF111111),
        ),
        textAlign: ResponsiveHelper.isMobile(context)
            ? TextAlign.center
            : TextAlign.right,
      ),
    );
  }
}
