import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:second/screens/authentication/login.dart";
import "package:second/screens/authentication/signup.dart";
import "package:second/utils/constants/image_strings.dart";
import "package:second/utils/constants/sizes.dart";
import "package:second/utils/constants/text_strings.dart";
import "package:second/utils/helpers/helper_functions.dart";



class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subTitle,  required this.onPressed});

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: TSizes.appBarHeight*4,
              left: TSizes.defaultSpace,
              bottom: TSizes.defaultSpace,
              right: TSizes.defaultSpace),
          child: Column(
            children: [
              Image(image: AssetImage(image)),
              const SizedBox(height: TSizes.spaceBtwItems),

              Text(title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),

              Text(subTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),

              SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: () => Get.to(() => const LoginScreen()),
                  child:  const Text(TTexts.tContinue),
              ),),

              const SizedBox(height: TSizes.spaceBtwItems),

            ],
          ),
        ),
      ),
    );
  }
}



