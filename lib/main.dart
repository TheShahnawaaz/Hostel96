import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:second/app.dart';
import 'package:second/firebase_options.dart';
import 'package:second/repositories/authentication_repository.dart';
import 'package:second/utils/theme/theme.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(
    (FirebaseApp value) => Get.put(
      AuthenticationRepository(),
    ),
  );

  runApp(const MyApp());
}

  // runApp(
  //   MediaQuery(
  //     data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(
  //       textScaleFactor: 1.0,
  //     ),
  //     child: const MyApp(),
  //   ),
  // );




// keytool -list -v -keystore "C:\Users\shahn\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
// Alias name: androiddebugkey
// Creation date: 29-Apr-2024
// Entry type: PrivateKeyEntry
// Certificate chain length: 1
// Certificate[1]:
// Owner: C=US, O=Android, CN=Android Debug
// Issuer: C=US, O=Android, CN=Android Debug
// Serial number: 1
// Valid from: Mon Apr 29 22:59:14 IST 2024 until: Wed Apr 22 22:59:14 IST 2054
// Certificate fingerprints:
//          SHA1: 78:53:D5:9F:48:A3:58:89:F5:00:0E:ED:E5:B6:5F:5F:39:AD:44:B0
//          SHA256: E1:6B:9D:76:99:8A:8F:9A:4C:5F:74:73:7C:86:CD:DD:F7:B5:9D:2E:EC:2F:5D:15:9A:8A:C7:32:F2:63:87:9B
// Signature algorithm name: SHA1withRSA (weak)
// Subject Public Key Algorithm: 2048-bit RSA key
// Version: 1