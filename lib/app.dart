import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second/routes/routes.dart';
import 'package:second/screens/authentication/login.dart';
import 'package:second/splash_screen.dart';
import 'package:second/utils/connectivity/bindings.dart';
import 'package:second/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: GetMaterialApp(
            themeMode: ThemeMode.system,
            theme: TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            initialBinding: GeneralBinding(),
            getPages: AppRoutes.pages,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
