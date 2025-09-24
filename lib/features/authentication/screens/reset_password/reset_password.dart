import 'package:brother_admin_panel/common/widgets/layout/templates/site_layout.dart';
import 'package:brother_admin_panel/features/authentication/screens/reset_password/responsive-screen/reset_password_desktop_tablet.dart';
import 'package:brother_admin_panel/features/authentication/screens/reset_password/responsive-screen/reset_password_mobile.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      desktop: ResetPasswordDesktopTabletScreen(),
      mobile: ResetPasswordMobileScreen(),
    );
  }
}
