import 'package:brother_admin_panel/common/widgets/layout/templates/site_layout.dart';
import 'package:brother_admin_panel/features/authentication/screens/login/responsive-screens/otp_login_desktop_tablet.dart';
import 'package:brother_admin_panel/features/authentication/screens/login/responsive-screens/otp_login_mobile.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      desktop: OtpLoginDesktopTablet(),
      mobile: OtpLoginScreenMobile(),
    );
  }
}
