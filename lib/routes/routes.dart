import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:second/app.dart';
import 'package:second/screens/authentication/forget_password.dart';
import 'package:second/screens/authentication/login.dart';
import 'package:second/screens/authentication/signup.dart';
import 'package:second/screens/authentication/verify_email.dart';
import 'package:second/screens/main/account.dart';
import 'package:second/screens/main/city_list.dart';
import 'package:second/screens/main/city_listing_screen.dart';
import 'package:second/screens/main/edit_profile.dart';
import 'package:second/screens/main/hostel_details_screen.dart';
import 'package:second/splash_screen.dart';
import 'package:second/widgets/navigation_menu.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: '/', page: () => const MyApp()),
    GetPage(name: '/splash', page: () => const SplashScreen()),
    GetPage(name: '/login', page: () => const LoginScreen()),
    GetPage(name: '/signup', page: () => const SignUpScreen()),
    GetPage(name: '/verify-email', page: () => const VerifyEmailScreen()),
    GetPage(name: '/forget-password', page: () => const ForgetPasswordScreen()),
    GetPage(name: '/home', page: () => const NavigationMenu()),
    GetPage(name: '/account', page: () => AccountScreen()),
    GetPage(name: '/profile', page: () => EditProfileScreen()),
    GetPage(name: '/edit-profile', page: () => EditProfileScreen()),
    // GetPage(name: '/terms', page: () => const TermsScreen()),
    // GetPage(name: '/privacy', page: () => const PrivacyScreen()),
    GetPage(name: '/city-list', page: () => const SearchCityListScreen()),
    GetPage(name: '/hostel-list/:city/:state', page: () => CityDetailsScreen(cityName: Get.parameters['city'], stateName: Get.parameters['state'])),
    // GetPage(name: '/hostel-details/:hostelId', page: () => HostelDetailsScreen()),
    // GetPage(name: '/bookings', page: () => const BookingsScreen()),


  ];
}
