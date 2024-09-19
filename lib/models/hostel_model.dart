import 'package:cloud_firestore/cloud_firestore.dart';

// HostelVariation is a class that represents a hostel variation.
// It is used to represent a hostel variation in the app.
// It can be Single Sharing, Double Sharing, Triple Sharing or Quad Sharing.
// It has a SharingType, AskedPrice by the hostel owner, FinalPrice after negotiation by the Admin, and an Id.
// A HostelModel can have multiple hostel variations. but atmost one of each type.

class HostelModel {
  String id;
  final String name;
  final String city;
  final String area;
  final String gender;
  final String type;
  final String fullAddress;
  final String googleAddressLink;
  final String locality;
  final String instituteName;
  final bool hasFood;
  final bool hasWifi;
  final bool hasCCTV;
  final bool hasFridge;
  final bool hasBiometric;
  final bool hasAc;
  final bool hasStudyTable;
  final bool hasWaterCooler;
  List<HostelVariation> hostelVariations;
  List<String> imageSliderUrls;
  final String landlordId;
  final bool isVerified;
  final bool isDeleted;
  final bool isFeatured;
  final int ranking;
  final int dummyPrice;
  final int thumbnailIndex;

  HostelModel({
    this.id = "",
    required this.city,
    required this.name,
    required this.area,
    required this.gender,
    required this.type,
    required this.fullAddress,
    this.googleAddressLink = '',
    this.locality = '',
    this.instituteName = '',
    this.hasFood = false,
    this.hasWifi = false,
    this.hasCCTV = false,
    this.hasFridge = false,
    this.hasBiometric = false,
    this.hasAc = false,
    this.hasStudyTable = false,
    this.hasWaterCooler = false,
    this.isVerified = false,
    this.isDeleted = false,
    this.isFeatured = false,
    required this.hostelVariations,
    required this.imageSliderUrls,
    required this.landlordId,
    this.ranking = 9999,
    this.dummyPrice = 50000,
    this.thumbnailIndex = 0,
  });

  static HostelModel empty() => HostelModel(
      id: '',
      name: '',
      city: '',
      area: '',
      gender: '',
      type: '',
      fullAddress: '',
      hostelVariations: [],
      imageSliderUrls: [],
      landlordId: '');

  toJson() {
    return {
      // 'Id': id,
      'Name': name,
      'City': city,
      'Area': area,
      'Gender': gender,
      'Type': type,
      'FullAddress': fullAddress,
      'GoogleAddressLink': googleAddressLink,
      'Locality': locality,
      'InstituteName': instituteName,
      'HasFood': hasFood,
      'HasWifi': hasWifi,
      'HasCCTV': hasCCTV,
      'HasFridge': hasFridge,
      'HasBiometric': hasBiometric,
      'HasAc': hasAc,
      'HasStudyTable': hasStudyTable,
      'HasWaterCooler': hasWaterCooler,
      'HostelVariations': hostelVariations.map((e) => e.toJson()).toList(),
      'ImageSliderUrls': imageSliderUrls,
      'LandlordId': landlordId,
      'IsVerified': isVerified,
      'IsDeleted': isDeleted,
      'IsFeatured': isFeatured,
      'Ranking': ranking,
      'DummyPrice': dummyPrice,
      'ThumbnailIndex': thumbnailIndex,
    };
  }


  int get minPrice {
    return hostelVariations.map((e) => e.finalPrice).reduce((a, b) => a < b ? a : b);
  }
  // Usage: hostelModel.minPrice

  factory HostelModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() == null) {
      return HostelModel.empty();
    }
    final data = snapshot.data()!;
    return HostelModel(
      id: snapshot.id,
      name: data['Name'],
      city: data['City'],
      area: data['Area'],
      gender: data['Gender'],
      type: data['Type'],
      fullAddress: data['FullAddress'],
      googleAddressLink: data['GoogleAddressLink'],
      locality: data['Locality'],
      instituteName: data['InstituteName'],
      hasFood: data['HasFood'],
      hasWifi: data['HasWifi'],
      hasCCTV: data['HasCCTV'],
      hasFridge: data['HasFridge'],
      hasBiometric: data['HasBiometric'],
      hasAc: data['HasAc'],
      hasStudyTable: data['HasStudyTable'],
      hasWaterCooler: data['HasWaterCooler'],
      imageSliderUrls: List<String>.from(data['ImageSliderUrls'] ?? []),
      landlordId: data['LandlordId'],
      hostelVariations: (data['HostelVariations'] as List)
          .map((e) => HostelVariation.fromJson(e as Map<String, dynamic>))
          .toList(),
      isVerified: data['IsVerified'],
      isDeleted: data['IsDeleted'],
      isFeatured: data['IsFeatured'],
      ranking: data['Ranking'],
      dummyPrice: data['DummyPrice'],
      thumbnailIndex: data['ThumbnailIndex'],
    );
  }

  factory HostelModel.updated({
    required HostelModel hostel,
    String? name,
    String? city,
    String? area,
    String? gender,
    String? type,
    String? fullAddress,
    String? googleAddressLink,
    String? locality,
    String? instituteName,
    bool? hasFood,
    bool? hasWifi,
    bool? hasCCTV,
    bool? hasFridge,
    bool? hasBiometric,
    bool? hasAc,
    bool? hasStudyTable,
    bool? hasWaterCooler,
    bool? isVerified,
    bool? isDeleted,
    bool? isFeatured,
    int? ranking,
    List<HostelVariation>? hostelVariations,
    List<String>? imageSliderUrls,
    String? landlordId,
    int? dummyPrice,
    int? thumbnailIndex,
  }) {
    return HostelModel(
      id: hostel.id,
      name: name ?? hostel.name,
      city: city ?? hostel.city,
      area: area ?? hostel.area,
      gender: gender ?? hostel.gender,
      type: type ?? hostel.type,
      fullAddress: fullAddress ?? hostel.fullAddress,
      googleAddressLink: googleAddressLink ?? hostel.googleAddressLink,
      locality: locality ?? hostel.locality,
      instituteName: instituteName ?? hostel.instituteName,
      hasFood: hasFood ?? hostel.hasFood,
      hasWifi: hasWifi ?? hostel.hasWifi,
      hasCCTV: hasCCTV ?? hostel.hasCCTV,
      hasFridge: hasFridge ?? hostel.hasFridge,
      hasBiometric: hasBiometric ?? hostel.hasBiometric,
      hasAc: hasAc ?? hostel.hasAc,
      hasStudyTable: hasStudyTable ?? hostel.hasStudyTable,
      hasWaterCooler: hasWaterCooler ?? hostel.hasWaterCooler,
      hostelVariations: hostelVariations ?? hostel.hostelVariations,
      imageSliderUrls: imageSliderUrls ?? hostel.imageSliderUrls,
      landlordId: landlordId ?? hostel.landlordId,
      isVerified: isVerified ?? hostel.isVerified,
      isDeleted: isDeleted ?? hostel.isDeleted,
      isFeatured: isFeatured ?? hostel.isFeatured,
      ranking: ranking ?? hostel.ranking,
      dummyPrice: dummyPrice ?? hostel.dummyPrice,
      thumbnailIndex: thumbnailIndex ?? hostel.thumbnailIndex,
    );
  }
}

class HostelVariation {
  String sharingType;
  int askedPrice;
  final int finalPrice;
  int bedCount;
  String id;

  HostelVariation({
    this.id = '',
    this.sharingType = '',
    this.askedPrice = 0,
    this.finalPrice = 999999,
    this.bedCount = 0,
  });

  static HostelVariation empty() => HostelVariation(id: '');

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'SharingType': sharingType,
      'AskedPrice': askedPrice,
      'FinalPrice': finalPrice,
      'BedCount': bedCount,
    };
  }

  factory HostelVariation.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return HostelVariation.empty();
    }
    return HostelVariation(
      id: json['Id'],
      sharingType: json['SharingType'],
      askedPrice: json['AskedPrice'],
      finalPrice: json['FinalPrice'],
      bedCount: json['BedCount'],
    );
  }
}
