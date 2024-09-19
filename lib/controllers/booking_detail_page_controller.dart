import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second/models/hostel_model.dart';
import 'package:second/models/landlord_model.dart';
import 'package:second/models/order_model.dart';

class BookingDetailPageController extends GetxController {
  static BookingDetailPageController get instance => Get.find();

  var isLoading = true.obs;
  var landlord = LandlordModel.empty().obs;
  var hostel = HostelModel.empty().obs;
  var variation = HostelVariation.empty().obs;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> fetchLandlordAndHostel(OrderModel order) async {
    isLoading(true);

    try {
      // Fetch landlord details
      final landlordSnapshot =
          await _db.collection('Landlords').doc(order.landlordId).get();
      if (landlordSnapshot.exists) {
        landlord.value = LandlordModel.fromSnapshot(landlordSnapshot);
      }

      // Fetch hostel details
      final hostelSnapshot =
          await _db.collection('Hostels').doc(order.hostelId).get();
      if (hostelSnapshot.exists) {
        hostel.value = HostelModel.fromSnapshot(hostelSnapshot);
        // Set the variation
        variation.value = hostel.value.hostelVariations
            .firstWhere((element) => element.id == order.variationId);
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading(false);
    }
  }
}
