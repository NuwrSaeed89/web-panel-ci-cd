import 'package:brother_admin_panel/utils/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:brother_admin_panel/utils/helpers/responsive_helper.dart';

class BrandLoadingState extends StatelessWidget {
  final BuildContext context;
  final bool isDark;

  const BrandLoadingState({
    super.key,
    required this.context,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: isDark ? TColors.primary : Colors.blue.shade700,
            ),
            const SizedBox(height: 16),
            Text(
              'جاري تحميل الماركات...',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BrandEmptyState extends StatelessWidget {
  final BuildContext context;
  final bool isDark;

  const BrandEmptyState({
    super.key,
    required this.context,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.branding_watermark_outlined,
              size: ResponsiveHelper.isMobile(context) ? 48 : 64,
              color: isDark ? Colors.white24 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد ماركات',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: ResponsiveHelper.isMobile(context) ? 16 : 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ابدأ بإضافة أول ماركة',
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade500,
                fontSize: ResponsiveHelper.isMobile(context) ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
