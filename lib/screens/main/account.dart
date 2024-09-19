import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:second/controllers/user_controller.dart';
import 'package:second/repositories/authentication_repository.dart';
import 'package:second/screens/main/cancellation_policy.dart';
import 'package:second/screens/main/privacy_policy.dart';
import 'package:second/screens/main/terms_and_condition.dart';
import 'package:second/widgets/appbar.dart';
import 'package:second/screens/main/edit_profile.dart';
import 'package:second/screens/main/home.dart';
import 'package:second/widgets/navigation_menu.dart';
import 'package:second/utils/constants/colors.dart';
import 'package:second/utils/constants/image_strings.dart';
import 'package:second/utils/constants/sizes.dart';
import 'package:second/utils/helpers/helper_functions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../widgets/widgets.dart';

class AccountScreen extends StatelessWidget {
  Future<void> shareApp() async {
    final String message =
        "Hey, I found this amazing app called Hostel96. You can find the best hostels and PGs here. Download the app now from the Play Store and App Store.\n\nPlay Store: https://play.google.com/store/apps/details?id=com.hostel96.hostel96";

    // Load images from assets
    final ByteData bytes1 = await rootBundle.load(TImages.lightAppLogo);

    // Create temporary files
    final tempDir = await getTemporaryDirectory();
    final file1 = await File('${tempDir.path}/share_banner.png')
        .writeAsBytes(bytes1.buffer.asUint8List());

    // Create XFile objects
    final XFile xFile1 = XFile(file1.path);

    // Share text and images
    await Share.shareXFiles([xFile1], text: message);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationContainer());
    final dark = THelperFunctions.isDarkMode(context);
    final userController = UserController.instance;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurveEdgesWidget(
              child: Column(
                children: [
                  TAppBar(
                    title: Text('Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .apply(color: TColors.white)),
                  ),
                  Obx(
                    () => UserProfileTile(
                      imageUrl: TImages.user,
                      name: userController.user.value.fullName,
                      email: userController.user.value.email,
                      trailing: IconButton(
                        icon: const Icon(
                          Iconsax.edit,
                          color: TColors.white,
                        ),
                        onPressed: () {
                          Get.to(() => EditProfileScreen());
                        },
                      ),
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
              child: Column(
                children: [
                  SectionHeading(
                    title: 'Account Settings',
                    showAction: false,
                    color: dark ? TColors.white : TColors.dark,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SettingMenuTile(
                    icon: Iconsax.user,
                    title: 'Personal Information',
                    subtitle: 'Update your personal information',
                    onTap: () {
                      Get.to(() => EditProfileScreen());
                    },
                    trailing: const Icon(
                      Iconsax.edit,
                      color: TColors.primary,
                    ),
                  ),
                  SettingMenuTile(
                    icon: Iconsax.ticket,
                    title: 'My Bookings',
                    subtitle: 'Browse your bookings',
                    onTap: () {
                      controller.selectedIndex.value = 2;
                    },
                    trailing: const Icon(
                      Iconsax.arrow_right_3,
                      color: TColors.primary,
                    ),
                  ),
                  SettingMenuTile(
                    icon: Iconsax.people,
                    title: 'Communities',
                    subtitle: 'Join our communities',
                    onTap: () {
                      // https://t.me/+Yd2gVx_V68M1ZmM1
                      THelperFunctions.openLink(context,
                          'https://t.me/+Yd2gVx_V68M1ZmM1'); // Open Telegram
                    },
                    trailing: const Icon(
                      Iconsax.arrow_right_3,
                      color: TColors.primary,
                    ),
                  ),
                  SettingMenuTile(
                    icon: Iconsax.call,
                    title: 'Customer Support',
                    subtitle: 'Get help from customer support',
                    onTap: (() async {
                      // THelperFunctions.openLink(context, 'tel:+917209109480');
                      _showConfirmationDialog(context,
                          userController.user.value.phone, "7209109480");
                    }),
                    trailing: const Icon(
                      Iconsax.arrow_right_3,
                      color: TColors.primary,
                    ),
                  ),
                  SettingMenuTile(
                    icon: Iconsax.message,
                    title: 'Chat with us',
                    subtitle: 'Chat with us on WhatsApp',
                    onTap: (() async {
                      THelperFunctions.openLink(context,
                          'https://wa.me/+917209109480?text=Hi, I need help with my account in Hostel96');
                    }),
                    trailing: const Icon(
                      Iconsax.arrow_right_3,
                      color: TColors.primary,
                    ),
                  ),
                  SettingMenuTile(
                    icon: Iconsax.share,
                    title: 'Share This App',
                    subtitle: 'Share this app with friends',
                    onTap: () {
                      print("Share");
                      shareApp();
                    },
                    trailing: const Icon(
                      Iconsax.arrow_right_3,
                      color: TColors.primary,
                    ),
                  ),

                  SettingMenuTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'View our privacy policy',
                    onTap: () {
                      Get.to(() => const PrivacyPolicyScreen());
                    },
                    trailing: const Icon(
                      Iconsax.arrow_right_3,
                      color: TColors.primary,
                    ),
                  ),
                  // Share This App
                  SettingMenuTile(
                    icon: CupertinoIcons.doc_text,
                    title: 'Terms and Conditions',
                    subtitle: 'View our terms and conditions',
                    onTap: () {
                      Get.to(() => const TermsAndConditionsScreen());
                    },
                    trailing: const Icon(
                      Iconsax.arrow_right_3,
                      color: TColors.primary,
                    ),
                  ),
                  // Cancelletion Policy
                  SettingMenuTile(
                    icon: Iconsax.box_remove,
                    title: 'Cancellation Policy',
                    subtitle: 'View our cancellation policy',
                    onTap: () {
                      Get.to(() => const CancellationPolicyScreen());
                    },
                    trailing: const Icon(
                      Iconsax.arrow_right_3,
                      color: TColors.primary,
                    ),
                  ),

                  SettingMenuTile(
                    icon: Iconsax.logout,
                    title: 'Logout',
                    subtitle: 'Logout from the app',
                    onTap: () {
                      AuthenticationRepository.instance.logout();

                      // Get.offAll(() => const LoginScreen());
                    },
                    trailing: const Icon(
                      Iconsax.arrow_right_3,
                      color: TColors.primary,
                    ),
                  ),

                  // SizedBox(height: TSizes.spaceBtwSections),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Divider(
                              color: dark ? TColors.darkGrey : TColors.grey,
                              thickness: 1,
                              indent: 30,
                              endIndent: 5)),
                      const Text("Follow us on"),
                      Flexible(
                          child: Divider(
                              color: dark ? TColors.darkGrey : TColors.grey,
                              thickness: 1,
                              indent: 5,
                              endIndent: 30)),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TRoundedImage(
                          // contact@hostel96.com

                          onPressed: () {
                            THelperFunctions.openLink(
                              context,
                              'mailto:contact@hostel96.com',
                            );
                          },
                          imageUrl: TImages.google,
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(0),
                          borderRadius: 25,
                          margin: EdgeInsets.only(right: 10)),
                      TRoundedImage(
                          onPressed: () {
                            THelperFunctions.openLink(context,
                                'https://www.facebook.com/profile.php?id=100088421786404');
                          },
                          imageUrl: TImages.facebook,
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(0),
                          margin: EdgeInsets.only(right: 10),
                          borderRadius: 25),
                      TRoundedImage(
                          onPressed: () {
                            THelperFunctions.openLink(context,
                                'https://www.instagram.com/hostel96_0fficial?igsh=cm5vM2hrd3MyanY=');
                          },
                          imageUrl: TImages.instagram,
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(0),
                          borderRadius: 25),
                      TRoundedImage(
                          onPressed: () {
                            THelperFunctions.openLink(context,
                                'https://x.com/Hostel96com?t=yHSJsxciem-YIFBlppuJEQ&s=09');
                          },
                          imageUrl: TImages.twitter,
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(0),
                          borderRadius: 25),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String phoneNumber, String careNo) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Call Request'),
          content: Text(
              'Request call for $phoneNumber?\nIf this is not your phone number, please update your phone number in your profile.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // https://prpmobility.com/Api/ClickCallReq.aspx?uname=20240139&pass=20240139&reqid=121&aparty=9472859728&bparty=7209390860
                final response = await http.get(Uri.parse(
                    'https://prpmobility.com/Api/ClickCallReq.aspx?uname=20240139&pass=20240139&reqid=121&aparty=${careNo}&bparty=$phoneNumber'));
                if (response.statusCode == 200) {
                  // Successfully called the endpoint
                  TLoaders.successSnackbar(
                      title: "Call Request Sent",
                      message:
                          "You will get a call from the Hostel96 in few minutes.");
                } else {
                  // Error calling the endpoint
                  TLoaders.errorSnackbar(
                      title: "Call Request Failed",
                      message: "Please try again later.");
                }
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

_launchWhatsApp(String phoneNumber) async {
  String url = 'https://wa.me/$phoneNumber';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch WhatsApp';
  }
}

class SettingMenuTile extends StatelessWidget {
  const SettingMenuTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      this.onTap,
      this.trailing});

  final IconData icon;
  final String title, subtitle;
  final Function()? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    THelperFunctions.isDarkMode(context);

    return ListTile(
      leading: Icon(
        icon,
        color: TColors.primary,
        size: 28,
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.email,
    this.trailing,
  });

  final String imageUrl;
  final String name;
  final String email;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: TRoundedImage(
          imageUrl: imageUrl,
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(0),
          borderRadius: 25),
      title: Text(
        name,
        style: Theme.of(context).textTheme.headlineSmall!.apply(
              color: TColors.white,
            ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        email,
        style: Theme.of(context).textTheme.bodyMedium!.apply(
              color: TColors.white,
            ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: trailing,
    );
  }
}




//  The  AccountScreen  is a simple  StatelessWidget  that displays a  Scaffold  with an  AppBar  and a  Center  widget that displays a text widget.
//  Now, let’s create a new file called  settings.dart  in the  lib/features/authentication/screens  directory and add the following code:
