import 'package:flutter/material.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';

class ClientsEmptyWidget extends StatelessWidget {
  final bool isDark;

  const ClientsEmptyWidget({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: isDark ? Colors.white54 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد زبائن',
            style: TTextStyles.heading3.copyWith(
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإضافة زبون جديد',
            style: TTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
