import 'package:brother_admin_panel/common/styles/spacing_style.dart';
import 'package:brother_admin_panel/utils/constants/sizes.dart';
import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TLoginTemplate extends StatelessWidget {
  const TLoginTemplate({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black
                .withValues(alpha: 0.3), // طبقة شفافة داكنة لتحسين وضوح النص
          ),
          child: Center(
            child: SizedBox(
              width: 550,
              child: SingleChildScrollView(
                child: Container(
                  padding: TSpacingStyle.paddingWithAppbarHeight,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.8),

                    /// خلفية بيضاء شفافة
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
