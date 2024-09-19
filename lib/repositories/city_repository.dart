import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/city_model.dart';
import '../utils/exceptions/exceptions.dart';
import '../utils/exceptions/firebase_auth_exceptions.dart';
import '../utils/exceptions/format_exceptions.dart';

class CityRepository extends GetxController {
  static CityRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<CityModel>> fetchCities() async {
    try {
      final querySnapshot = await _db.collection('Cities').get();
      return querySnapshot.docs
          .map((doc) => CityModel.fromSnapshot(doc))
          .toList();
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


  // Upload 


  // Add other methods like fetchCityById, addCity, updateCity, deleteCity as needed
}
