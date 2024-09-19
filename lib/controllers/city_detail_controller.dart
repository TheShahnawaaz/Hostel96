import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:second/models/hostel_model.dart';

class CityDetailsController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final hostels = <HostelModel>[].obs;
  final filteredHostels = <HostelModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  final String cityName;
  DocumentSnapshot? lastDocument; // Snapshot of the last document fetched

  CityDetailsController(this.cityName) {
    scrollController.addListener(_scrollListener);
    loadMoreHostels();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading.value &&
        !isLastPage.value) {
      loadMoreHostels();
    }
  }

  void loadMoreHostels() async {
    if (isLoading.value) return;
    isLoading.value = true;

    var query = FirebaseFirestore.instance
        .collection('Hostels')
        .where('City', isEqualTo: cityName)
        .orderBy('Ranking')
        .limit(5);

    // Start after the last document if it exists
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    var querySnapshot = await query.get();

    if (querySnapshot.docs.isEmpty) {
      isLastPage.value = true; // No more documents to fetch
      print('No more documents');
      update();
    } else {
      List<HostelModel> newHostels = querySnapshot.docs
          .map((doc) => HostelModel.fromSnapshot(doc))
          .toList();
      if (newHostels.isNotEmpty) {
        lastDocument = querySnapshot.docs.last; // Update the last document
        // Take only those hostels whose isVerified is true
        hostels.addAll(newHostels.where((hostel) =>
            hostel.isVerified == true &&
            hostel.isDeleted == false &&
            hostel.isFeatured == true));
        update();
        filteredHostels.assignAll(hostels);
      }
    }

    isLoading.value = false;
  }

  void filterHostels(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      filteredHostels.assignAll(hostels);
    } else {
      filteredHostels.assignAll(hostels
          .where((hostel) =>
              hostel.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              hostel.area.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList());
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
