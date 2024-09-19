import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService extends GetxController {
  static FirebaseStorageService get instance => Get.find();

  final _firebaseStorage = FirebaseStorage.instance;

  /// Upload Local Assets from IDE
  Future<Uint8List> getImageDataFromAssets(String path) async {
    try {
      print('Loading image data: $path');
      final byteData = await rootBundle.load(path);
      final imageData = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      print('Image data loaded: $imageData');
      return imageData;
    } catch (e) {
      throw 'Error loading image data: $e';
    }
  }

  /// Returns the download URL of the uploaded image.
  Future<String> uploadImageData(String path, Uint8List image, String name) async {
    try {
      print('Uploading image: $name');
      // Add a timestamp to the image name
      name = '$name-${DateTime.now().millisecondsSinceEpoch}';
      // Add extension to the image name
      name = '$name.jpg';
      final ref = _firebaseStorage.ref(path).child(name);
      await ref.putData(image);
      final url = await ref.getDownloadURL();
      print('Image uploaded: $url');
      return url;
    } catch (e) {
      if (e is FirebaseException) {
        throw 'Firebase Exception: ${e.message}';
      } else if (e is SocketException) {
        throw 'Network Error: ${e.message}';
      } else if (e is PlatformException) {
        throw 'Platform Exception: ${e.message}';
      } else {
        throw 'Something Went Wrong! Please try again.';
      }
    }
  }

  /// Returns the download URL of the uploaded image.
  Future<String> uploadImageFile(String path, XFile image, String name) async {
    try {
      final ref = _firebaseStorage.ref(path).child(name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      print('Image uploaded: $url');

      return url;
    } catch (e) {
      if (e is FirebaseException) {
        throw 'Firebase Exception: ${e.message}';
      } else if (e is SocketException) {
        throw 'Network Error: ${e.message}';
      } else if (e is PlatformException) {
        throw 'Platform Exception: ${e.message}';
      } else {
        throw 'Something Went Wrong! Please try again.';
      }
    }
  }
}

