import 'package:brother_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:brother_admin_panel/features/authentication/screens/reset_password/reset_password.dart';
import 'package:brother_admin_panel/utils/constants/image_strings.dart';
import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:brother_admin_panel/utils/loaders/loaders.dart';
import 'package:brother_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {
    try {
      TFullScreenLoader.openloadingDialog(
        'Processing',
        TImages.proccessLottie,
        color: THelperFunctions.isDarkMode(Get.context!)
            ? Colors.white
            : Colors.black,
      );

      // check the internet connectivity

      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(
        email.text.trim(),
      );

      TFullScreenLoader.stopLoading();
      TLoader.successSnackBar(
        title: 'Email Send',
        message: 'Email Link Sent to Reset your Password',
      );
      Get.to(const ResetPasswordScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoader.erroreSnackBar(title: 'oh Snap', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      TFullScreenLoader.openloadingDialog(
        'processing',
        TImages.proccessLottie,
        color: THelperFunctions.isDarkMode(Get.context!)
            ? Colors.white
            : Colors.black,
      );

      // check the internet connectivity

      // final isConnected = await NetworkManager.instance.isConnected();
      // if (!isConnected) {
      //   TFullScreenLoader.stopLoading();
      //   return;
      // }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      TFullScreenLoader.stopLoading();

      TLoader.successSnackBar(
        title: 'Email Send',
        message: 'Email Link Sent to Reset your Password',
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoader.erroreSnackBar(title: 'oh Snap', message: e.toString());
    }
  }
}
