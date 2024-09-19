import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:second/controllers/login_controller.dart";
import "package:second/screens/authentication/forget_password.dart";
import "package:second/utils/validators/validation.dart";
import "package:second/widgets/navigation_menu.dart";
import "package:second/screens/authentication/signup.dart";
import "package:second/utils/constants/image_strings.dart";
import "package:second/utils/constants/sizes.dart";
import "package:second/utils/constants/text_strings.dart";
import "package:second/utils/helpers/helper_functions.dart";
import "package:flutter/material.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(LoginController());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: TSizes.appBarHeight,
                left: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
                right: TSizes.defaultSpace),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          height: 80,
                          image: AssetImage(dark
                              ? TImages.lightAppLogo
                              : TImages.darkAppLogo),
                        ),
                        Expanded(
                          child: Text(
                            TTexts.appName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontSize: 45,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwSections * 1.5,
                    ),
                    Text(TTexts.loginTitle,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(
                      height: TSizes.sm,
                    ),
                    Text(TTexts.loginSubTitle,
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                Form(
                  key: controller.formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: TSizes.spaceBtwItems),
                    child: Column(children: [
                      TextFormField(
                        controller: controller.email,
                        validator: (value) => TValidator.validateEmail(value),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: TTexts.email,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: TSizes.defaultSpace,
                      ),
                      Obx(
                        () => TextFormField(
                          controller: controller.password,
                          validator: (value) =>
                              TValidator.validateEmptyText("Password", value),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.password_check),
                            labelText: TTexts.password,
                            suffixIcon: IconButton(
                              icon: Icon(controller.hidePassword.value
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye),
                              onPressed: () {
                                controller.hidePassword.value =
                                    !controller.hidePassword.value;
                              },
                            ),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: controller.hidePassword.value,
                        ),
                      ),
                      // const SizedBox(
                      //   height: TSizes.defaultSpace,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(
                                () => Checkbox(
                                    value: controller.rememberMe.value,
                                    onChanged: (value) {
                                      controller.rememberMe.value = value!;
                                    }),
                              ),
                              const Text(TTexts.rememberMe),
                            ],
                          ),
                          // const SizedBox(
                          //   height: TSizes.spaceBtwSections,
                          // ),
                          TextButton(
                            onPressed: () =>
                                Get.to(() => const ForgetPasswordScreen()),
                            child: const Text(TTexts.forgetPassword),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.emailAndPasswordLogin(),
                          child: const Text(TTexts.signIn),
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Get.to(() => const SignUpScreen()),
                          child: const Text(TTexts.createAccount),
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
