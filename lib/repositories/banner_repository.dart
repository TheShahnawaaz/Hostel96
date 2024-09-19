import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:second/models/banner_model.dart';
import 'package:second/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:second/utils/exceptions/firebase_exceptions.dart';
import 'package:second/utils/exceptions/format_exceptions.dart';
import 'package:second/utils/firebase/firebase_storage.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<HomeImageModel> fetchLargeBanner() async {
    try {
      final snapshot =
          await _db.collection('Assets').doc('LargeBannerMain').get();

      return HomeImageModel.fromSnapshot(snapshot);
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

  Future<HomeImageModel> fetchFooterBanner() async {
    try {
      final snapshot =
          await _db.collection('Assets').doc('FooterBannerMain').get();

      return HomeImageModel.fromSnapshot(snapshot);
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

  Future<List<BannerModel>> fetchBanners() async {
    try {
      final snapshot = await _db
          .collection('Banners')
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();
      // Order by order

      return snapshot.docs.map((doc) => BannerModel.fromSnapshot(doc)).toList();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException {
      throw TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> uploadDummyData(List<BannerModel> banners) async {
    try {
      final storage = Get.put(FirebaseStorageService());

      for (final this_banner in banners) {
        print("Uploading banner: ${this_banner.imageUrl}");
        final file = await storage.getImageDataFromAssets(this_banner.imageUrl);

        final url =
            await storage.uploadImageData('Banners', file, this_banner.name);

        this_banner.imageUrl = url;

        await _db.collection('Banners').add(this_banner.toJson());
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
}
