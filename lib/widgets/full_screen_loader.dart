import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:second/utils/helpers/helper_functions.dart';
import 'package:second/widgets/widgets.dart';

class TFullScreenLoader {
  /// This method opens a full-screen loading dialog.
  /// It doesn't return anything.
  ///
  /// Parameters:
  /// - text: The text to be displayed in the loading dialog.
  /// - animation: The Lottie animation to be shown.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible:
          false, // The dialog can't be dismissed by tapping outside it
      barrierColor: Colors.black
          .withOpacity(0.5), // Semi-transparent barrier for a dimmed effect
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // Disable popping with the back button
          child: Container(
            color: THelperFunctions.isDarkMode(context)
                ? Colors.black
                : Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: 250,

                // ),
                // TAnimationLoaderWidget(text: text, animation: animation),
                TAnimationLogoWidget(),
                SizedBox(height: 20),
                Text(
                  text,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: THelperFunctions.isDarkMode(context)
                            ? Colors.white
                            : Colors.black,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// This method closes the full-screen loading dialog.
  static void closeLoadingDialog() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
