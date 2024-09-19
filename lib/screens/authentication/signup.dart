import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:second/controllers/signup_controller.dart";
import 'package:flutter/gestures.dart';
import "package:second/screens/main/privacy_policy.dart";
import "package:second/screens/main/terms_and_condition.dart";

import "package:second/utils/constants/colors.dart";
import "package:second/utils/constants/sizes.dart";
import "package:second/utils/constants/text_strings.dart";
import "package:second/utils/helpers/helper_functions.dart";
import "package:second/utils/validators/validation.dart";

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(SignUpController());

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstName,
                            validator: (value) => TValidator.validateEmptyText(
                                TTexts.firstName, value),
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: TTexts.firstName,
                              prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastName,
                            validator: (value) => TValidator.validateEmptyText(
                                TTexts.lastName, value),
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: TTexts.lastName,
                              prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    TextFormField(
                      controller: controller.email,
                      validator: (value) => TValidator.validateEmail(value),
                      decoration: const InputDecoration(
                        labelText: TTexts.email,
                        prefixIcon: Icon(Iconsax.direct),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    //   Phone Number
                    TextFormField(
                      controller: controller.phoneNo,
                      validator: (value) => TValidator.validatePhoneNo(value),
                      decoration: const InputDecoration(
                        labelText: TTexts.phoneNo,
                        prefixIcon: Icon(Iconsax.call),
                      ),
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    Obx(
                      () => TextFormField(
                        controller: controller.password,
                        validator: (value) =>
                            TValidator.validatePassword(value),
                        obscureText: controller.hidePassword.value,
                        decoration: InputDecoration(
                          labelText: TTexts.password,
                          prefixIcon: Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            icon: Icon(controller.hidePassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye),
                            onPressed: () {
                              controller.hidePassword.value =
                                  !controller.hidePassword.value;
                            },
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    Obx(
                      () => TextFormField(
                        obscureText: controller.hideConfirmPassword.value,
                        controller: controller.confirmPassword,
                        validator: (value) =>
                            TValidator.validatePassword(value),
                        decoration: InputDecoration(
                          labelText: TTexts.confirmPassword,
                          prefixIcon: Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            icon: Icon(controller.hideConfirmPassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye),
                            onPressed: () {
                              controller.hideConfirmPassword.value =
                                  !controller.hideConfirmPassword.value;
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections),

                    Row(
                      children: [
                        SizedBox(
                            width: 24,
                            height: 24,
                            child: Obx(() => Checkbox(
                                value: controller.privacyPolicy.value,
                                onChanged: (value) =>
                                    controller.privacyPolicy.value = value!))),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Text.rich(TextSpan(
                          children: [
                            TextSpan(
                                text: '${TTexts.iAgreeTo} ',
                                style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(
                              onEnter: (e) => print('Privacy Policy Clicked'),
                              text: '${TTexts.privacyPolicy}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.apply(
                                    decoration: TextDecoration.underline,
                                    color:
                                        dark ? TColors.white : TColors.primary,
                                    decorationColor:
                                        dark ? TColors.white : TColors.primary,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => const PrivacyPolicyScreen());
                                },
                            ),
                            TextSpan(
                                text: ' ${TTexts.and} ',
                                style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(
                              text: TTexts.termsOfUse,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.apply(
                                    decoration: TextDecoration.underline,
                                    color:
                                        dark ? TColors.white : TColors.primary,
                                    decorationColor:
                                        dark ? TColors.white : TColors.primary,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(
                                      () => const TermsAndConditionsScreen());
                                },
                            ),
                          ],
                        )),
                      ],
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.signUp(),
                        child: const Text(TTexts.createAccount),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
