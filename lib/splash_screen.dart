import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:second/utils/helpers/helper_functions.dart';
import 'package:second/widgets/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:second/app.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: THelperFunctions.isDarkMode(context) ? Colors.black : Colors.white,
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
          SizedBox(
            height: 20,
          ),
          Text(
            "Hostel96",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: THelperFunctions.isDarkMode(context)
                      ? Colors.white
                      : Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
