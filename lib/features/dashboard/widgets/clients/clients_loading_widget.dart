import 'package:flutter/material.dart';
import 'package:brother_admin_panel/utils/styles/text_styles.dart';

class ClientsLoadingWidget extends StatelessWidget {
  final bool isDark;

  const ClientsLoadingWidget({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'جاري التحميل...',
            style: TTextStyles.bodyMedium.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
