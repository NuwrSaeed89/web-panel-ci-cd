import 'package:brother_admin_panel/common/widgets/layout/templates/login_template.dart';
import 'package:brother_admin_panel/features/authentication/screens/login/widgets/otp_login_form.dart';
import 'package:brother_admin_panel/features/authentication/screens/login/widgets/otp_login_header.dart';
import 'package:brother_admin_panel/features/authentication/controllers/otp_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpLoginDesktopTablet extends StatelessWidget {
  const OtpLoginDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(OtpLoginController());

    return const TLoginTemplate(
      child: Column(
        children: [TOtpLoginHeader(), TOtpLoginForm()],
      ),
    );
  }
}
