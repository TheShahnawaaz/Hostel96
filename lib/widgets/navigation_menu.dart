import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:second/screens/main/account.dart';
import 'package:second/screens/main/city_list.dart';
import 'package:second/screens/main/home.dart';
import 'package:second/screens/main/my_booking.dart';
import 'package:second/utils/constants/colors.dart';
import 'package:second/utils/constants/text_strings.dart';
import 'package:second/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatefulWidget {
  // Changed to StatefulWidget
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final controller = Get.put(NavigationContainer());
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: controller.selectedIndex.value,
          height: 75.0, // Adjust height as necessary

          items: [
            CurvedNavigationBarItem(
              child: Icon(Iconsax.home, size: 30, color: TColors.white),
              label: 'Home',
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: TColors.white,
              ),
            ),
            CurvedNavigationBarItem(
              child: Icon(Iconsax.map, size: 30, color: TColors.white),
              label: 'Cities',
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: TColors.white,
              ),
            ),
            CurvedNavigationBarItem(
              child: Icon(Iconsax.ticket, size: 30, color: TColors.white),
              label: 'My Bookings',
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: TColors.white,
              ),
            ),
            CurvedNavigationBarItem(
              child: Icon(Iconsax.user_square, size: 30, color: TColors.white),
              label: 'Account',
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: TColors.white,
              ),
            ),
            // Icon(Iconsax.home, size: 30, color: TColors.white),
            // Icon(Iconsax.people, size: 30, color: TColors.white),
            // Icon(Iconsax.ticket, size: 30, color: TColors.white),
            // Icon(Iconsax.user_square, size: 30, color: TColors.white),
          ],
          color: dark ? TColors.primary : TColors.primary,
          buttonBackgroundColor: TColors.primary,
          backgroundColor: dark ? TColors.black : TColors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          onTap: (index) {
            setState(() {
              controller.selectedIndex.value = index; // Update GetX index
            });
          },
          letIndexChange: (index) => true,
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationContainer extends GetxController {
  static NavigationContainer get instance => Get.find();
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    SearchCityListScreen(),
    MyBookingScreen(),
    // const HomeScreen(),
    AccountScreen(),
  ];
}
