import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:second/models/order_model.dart';
import 'package:second/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:second/utils/exceptions/firebase_exceptions.dart';
import 'package:second/utils/exceptions/format_exceptions.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    try {
      await _db
          .collection('Orders')
          .doc(order.orderId)
          .set(order.toJson()); //Changes
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException();
    } catch (e) {
      print(e);
      throw "Something went wrong, Please try again";
    }
  }

  Future<OrderModel> fetchOrderDetails(String orderId) async {
    try {
      final snapshot = await _db.collection('Orders').doc(orderId).get();

      if (snapshot.exists) {
        return OrderModel.fromSnapshot(snapshot);
      } else {
        throw "Order not found";
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException();
    } catch (e) {
      print(e);
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> updateOrderDetails(OrderModel order) async {
    try {
      await _db.collection('Orders').doc(order.orderId).update(order.toJson());
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

  Future<List<OrderModel>> fetchOrdersByStudent(String studentId) async {
    try {
      final snapshot = await _db
          .collection('Orders')
          .where('StudentId', isEqualTo: studentId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => OrderModel.fromSnapshot(doc))
            .toList();
      } else {
        return [];
      }
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

  Future<List<OrderModel>> fetchOrdersByLandlord(String landlordId) async {
    try {
      final snapshot = await _db
          .collection('Orders')
          .where('LandlordId', isEqualTo: landlordId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => OrderModel.fromSnapshot(doc))
            .toList();
      } else {
        return [];
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException();
    } catch (e) {
      print(e);
      throw "Something went wrong, Please try again";
    }
  }
}
