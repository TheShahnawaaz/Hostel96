


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:second/repositories/authentication_repository.dart';
import 'package:second/screens/authentication/reset_password.dart';
import 'package:second/utils/connectivity/connectivity.dart';
import 'package:second/widgets/full_screen_loader.dart';
import 'package:second/widgets/widgets.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  sendPasswordResetEmail() async {
    try {
      print("Inside sendPasswordResetEmail");
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // TFullScreenLoader.closeLoadingDialog();
        TLoaders.warningSnackbar(
            title: "No internet connection!",
            message:
            "Please check your internet connection and try again.");
        return;
      }

      if (!formKey.currentState!.validate()) {
        // TFullScreenLoader.closeLoadingDialog();
        return;
      }

      TFullScreenLoader.openLoadingDialog(
          "Sending password reset email", "assets/lottie/splash_animation.json");


      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      TFullScreenLoader.closeLoadingDialog();
      TLoaders.successSnackbar(
          title: "Password reset email sent",
          message: "Please check your email to reset your password");

      Get.to(() => const ResetPasswordScreen());



    } catch (error) {
      TFullScreenLoader.closeLoadingDialog();
      TLoaders.errorSnackbar(
          title: "Error sending password reset email",
          message: error.toString());
    }
  }
}