import 'package:brother_admin_panel/common/widgets/layout/templates/login_template.dart';
import 'package:brother_admin_panel/features/authentication/screens/login/widgets/login_form.dart';
import 'package:brother_admin_panel/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

class LoginDesktopTablet extends StatelessWidget {
  const LoginDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate(
        child: Column(
      children: [TLoginHeader(), TLoginForm()],
    ));
  }
}
