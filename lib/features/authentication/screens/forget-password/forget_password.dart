import 'package:brother_admin_panel/common/widgets/layout/templates/site_layout.dart';
import 'package:brother_admin_panel/features/authentication/screens/forget-password/responsive-screen/forget_password_desktop_tablet.dart';
import 'package:brother_admin_panel/features/authentication/screens/forget-password/responsive-screen/forget_password_mobile.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      desktop: ForgetPasswordDesktopTabletScreen(),
      mobile: ForgetPasswordScreenMobile(),
    );
  }
}
