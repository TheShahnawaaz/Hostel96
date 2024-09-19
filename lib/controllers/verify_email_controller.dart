import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:second/repositories/authentication_repository.dart';
import 'package:second/screens/authentication/login.dart';
import 'package:second/screens/authentication/success_screen.dart';
import 'package:second/utils/constants/image_strings.dart';
import 'package:second/utils/constants/text_strings.dart';
import 'package:second/widgets/widgets.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRediect();
    super.onInit();
  }

  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      TLoaders.successSnackbar(
          title: "Email Verification",
          message: "Email verification link has been sent to your email");
    } catch (e) {
      TLoaders.errorSnackbar(title: "Oops!", message: e.toString());
    }
  }

  setTimerForAutoRediect() async {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();
        print("Reloading");
        final user = FirebaseAuth.instance.currentUser; 
        if (user?.emailVerified == true ?? false) {
          timer.cancel();
          Get.offAll(() =>  SuccessScreen(
            image: TImages.staticSuccessIllustration,
            title: TTexts.yourAccountCreatedTitle,
            subTitle: TTexts.yourAccountCreatedSubTitle,
            onPressed: () => AuthenticationRepository.instance.screenRedirect(),
          ));
        }

      },

    );
  }


  checkEmailVerification() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      Get.offAll(() =>  SuccessScreen(
        image: TImages.staticSuccessIllustration,
        title: TTexts.yourAccountCreatedTitle,
        subTitle: TTexts.yourAccountCreatedSubTitle,
        onPressed: () => AuthenticationRepository.instance.screenRedirect(),
      ));
    }
    else {
      TLoaders.warningSnackbar(
          title: "Email not verified",
          message: "Please verify your email to continue");

    }
  }



}
