import 'package:brother_admin_panel/common/widgets/layout/templates/login_template.dart';
import 'package:brother_admin_panel/features/authentication/screens/reset_password/widgets/header_and_form_reset.dart';
import 'package:flutter/material.dart';

class ResetPasswordDesktopTabletScreen extends StatelessWidget {
  const ResetPasswordDesktopTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate(child: ResetPasswordWidget());
  }
}
