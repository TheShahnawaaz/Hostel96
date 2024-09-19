


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:second/models/user_model.dart";
import "package:second/repositories/authentication_repository.dart";
import "package:second/repositories/user_repository.dart";
import "package:second/screens/authentication/verify_email.dart";
import "package:second/utils/connectivity/connectivity.dart";
import "package:second/widgets/full_screen_loader.dart";
import "package:second/widgets/widgets.dart";

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final privacyPolicy = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNo = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    try {


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

      if (privacyPolicy.value == false) {
        TLoaders.warningSnackbar(
            title: "Accept privacy policy and terms of use!",
            message:
                "In order to proceed, you must agree to the privacy policy and terms of use.");
        return;
      }


      TFullScreenLoader.openLoadingDialog(
          "We are creating your account!",
          "assets/lottie/splash_animation.json");

      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());

      final newUser = UserModel(
        id: userCredential.user!.uid,
        email: email.text.trim(),
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        phone: phoneNo.text.trim(),
      );

      final userRepository = Get.put(UserRepository());

      await userRepository.saveUserRecord(newUser);

      TFullScreenLoader.closeLoadingDialog();

      TLoaders.successSnackbar(
          title: "Congratulations!",
          message:
              "Please verify your email address to continue using the app.");

      Get.to(() => VerifyEmailScreen(email: email.text.trim()));



    } catch (e) {
      print("Error: $e");
      TLoaders.errorSnackbar(title: "Oops!", message: e.toString());
      TFullScreenLoader.closeLoadingDialog();
    }
  }
}

