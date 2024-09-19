import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second/models/user_model.dart';
import 'package:second/repositories/authentication_repository.dart';
import 'package:second/utils/exceptions/firebase_auth_exceptions.dart';

import '../utils/exceptions/exceptions.dart';
import '../utils/exceptions/format_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection('Users').doc(user.id).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFormatException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      final doc = await _db.collection('Users').doc(AuthenticationRepository.instance.authUser?.uid).get();
      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      } else {
        throw "User not found";
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFormatException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }


  Future<void> updateUserDetails(UserModel user) async {
    try {
      await _db.collection('Users').doc(user.id).update(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFormatException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }



}
