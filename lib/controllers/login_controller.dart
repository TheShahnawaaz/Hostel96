

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:second/repositories/authentication_repository.dart';
import 'package:second/utils/connectivity/connectivity.dart';
import 'package:second/widgets/full_screen_loader.dart';
import 'package:second/widgets/widgets.dart';

class LoginController extends GetxController {

  final rememberMe = true.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();



  @override
  void onInit() {
    email.text = localStorage.read("REMEMBER_ME_EMAIL") ?? "";
    password.text = localStorage.read("REMEMBER_ME_PASSWORD") ?? "";
    super.onInit();
  }




  Future<void> emailAndPasswordLogin() async {
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



      if (rememberMe.value) {
        localStorage.write("REMEMBER_ME_EMAIL", email.text.trim());
        localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim());
      }



      TFullScreenLoader.openLoadingDialog(
          "We are logging you in!", "assets/lottie/splash_animation.json");


      final userCredential = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());


      TFullScreenLoader.closeLoadingDialog();


      AuthenticationRepository.instance.screenRedirect();


    } catch (e) {

      TFullScreenLoader.closeLoadingDialog();
      TLoaders.errorSnackbar(
          title: "Login failed!", message: e.toString());

    }
  }


}

