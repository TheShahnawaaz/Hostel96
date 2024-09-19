import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:second/screens/authentication/login.dart';
import 'package:second/screens/authentication/verify_email.dart';
import 'package:second/utils/exceptions/exceptions.dart';
import 'package:second/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:second/utils/exceptions/firebase_exceptions.dart';
import 'package:second/utils/exceptions/format_exceptions.dart';
import 'package:second/utils/exceptions/platform_exceptions.dart';
import 'package:second/widgets/navigation_menu.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 1), () {
      screenRedirect();
    });
  }

  screenRedirect() async {
    // Get.offAllNamed(LoginScreen.routeName);
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const NavigationMenu());
      } else {
        Get.offAll(() => VerifyEmailScreen(
              email: user.email,
            ));
      }
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  Future<UserCredential> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final student =
          await _db.collection('Users').doc(userCredential.user?.uid).get();

      if (!student.exists) {
        await _auth.signOut();
        throw TFirebaseAuthException('user-not-found').message;
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code}");
      print("FirebaseAuthException: ${TExceptions(e.code).message}");
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
      // // } on PlatformException catch (e) {
      //   throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
      // } on PlatformException catch (e) {
      //   throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
      // } on PlatformException catch (e) {
      //   throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
