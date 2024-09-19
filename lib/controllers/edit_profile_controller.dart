


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:second/controllers/user_controller.dart';
import 'package:second/models/user_model.dart';
import 'package:second/utils/connectivity/connectivity.dart';
import 'package:second/widgets/full_screen_loader.dart';
import 'package:second/widgets/widgets.dart';

class EditProfileController extends GetxController {
  static EditProfileController get instance => Get.find();

  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNo = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final userController = UserController.instance;


  @override
  void onInit() {
    email.text = userController.user.value.email;
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
    phoneNo.text = userController.user.value.phone;
    super.onInit();
  }



  Future<void> updateProfile() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackbar(
            title: "No internet connection!",
            message:
                "Please check your internet connection and try again.");
        return;
      }

      if (!formKey.currentState!.validate()) {
        return;
      }

      TFullScreenLoader.openLoadingDialog(
          "We are updating your profile!",
          "assets/lottie/splash_animation.json");

      final user = UserModel(
        id: UserController.instance.user.value.id,
        email: email.text.trim(),
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        phone: phoneNo.text.trim(),
      );

      await UserController.instance.updateUserDetails(user);


      await UserController.instance.fetchUserDetails();

      TFullScreenLoader.closeLoadingDialog();
      TLoaders.successSnackbar(
          title: "Profile updated successfully!",
          message: "Your profile has been updated successfully.");
    } catch (e) {
      TFullScreenLoader.closeLoadingDialog();
      TLoaders.errorSnackbar(
          title: "Profile update failed!",
          message: "Something went wrong, Please try again.");
    }
  }
}