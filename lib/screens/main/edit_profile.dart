// ignore_for_file: use_key_in_widget_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:second/controllers/edit_profile_controller.dart';
import 'package:second/controllers/user_controller.dart';
import 'package:second/screens/main/account.dart';
import 'package:second/utils/validators/validation.dart';
import 'package:second/widgets/appbar.dart';
import 'package:second/screens/main/home.dart';
import 'package:second/utils/constants/colors.dart';
import 'package:second/utils/constants/image_strings.dart';
import 'package:second/utils/constants/sizes.dart';
import 'package:second/utils/constants/text_strings.dart';
import 'package:second/utils/helpers/helper_functions.dart';

import '../../widgets/widgets.dart';

class EditProfileScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    final controller = Get.put(EditProfileController());

    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            CurveEdgesWidget(
              child: Column(
                children: [
                  TAppBar(
                    title: Text('Edit Profile',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .apply(color: TColors.white)),
                    showBackArrow: true,
                  ),
                  Obx(
                    () =>  UserProfileTile(
                      imageUrl: TImages.user,
                      name: userController.user.value.fullName,
                      email: userController.user.value.email,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            Padding(
              //
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace, vertical: TSizes.sm),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    SectionHeading(
                      title: 'Personal Information',
                      showAction: false,
                      color: dark ? TColors.white : TColors.dark,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    ProfileTextField(
                      controller: controller.firstName,
                      validator: (value) => TValidator.validateEmptyText("First Name", value),
                      label: 'First Name',
                      icon: Iconsax.user,
                    ),
                    ProfileTextField(
                      controller: controller.lastName,
                      validator: (value) => TValidator.validateEmptyText("Last Name", value),
                      label: 'Last Name',
                      icon: Iconsax.user,
                    ),
                    ProfileTextField(
                      controller: controller.email,
                      label: 'Email',
                      icon: Iconsax.direct_right,
                      readOnly: true,
                    ),
                    ProfileTextField(
                      controller: controller.phoneNo,
                      label: 'Phone Number',
                      icon: Iconsax.call,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.updateProfile(),
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;
  final String? Function(String?)? validator;

  const ProfileTextField({
    Key? key,

    required this.controller,
    this.validator,
    required this.label,
    required this.icon,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
      child: TextFormField(
        controller: controller,
        validator: validator,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: TColors.primary),
          fillColor: dark ? Colors.transparent : TColors.lightGrey,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: dark ? TColors.white : TColors.dark),
      ),
    );
  }
}

                      // builder: (context) => BottomSheet(
                      //   onClosing: () {},
                      //   builder: (context) => Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       ListTile(
                      //         leading: Icon(Icons.camera),
                      //         title: Text('Camera'),
                      //         onTap: () => _pickImage(ImageSource.camera),
                      //       ),
                      //       ListTile(
                      //         leading: Icon(Icons.image),
                      //         title: Text('Gallery'),
                      //         onTap: () => _pickImage(ImageSource.gallery),
                      //       ),
                      //     ],
                      //   ),
                      // ),