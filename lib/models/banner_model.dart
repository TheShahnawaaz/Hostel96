import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String imageUrl;
  final String targetScreen;
  final bool isExternalLink;
  final String externalLink;
  final bool isActive;
  final String name;
  final int order;
  final bool inMain;
  final bool isClickable;

  BannerModel({
    required this.imageUrl,
    required this.targetScreen,
    required this.isExternalLink,
    required this.externalLink,
    required this.isActive,
    required this.name,
    required this.order,
    this.inMain = false,
    this.isClickable = true,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      imageUrl: json['imageUrl'],
      targetScreen: json['targetScreen'],
      isExternalLink: json['isExternalLink'],
      externalLink: json['externalLink'],
      isActive: json['isActive'],
      name: json['name'],
      order: json['order'],
      inMain: json['inMain'],
      isClickable: json['isClickable'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = imageUrl;
    data['targetScreen'] = targetScreen;
    data['isExternalLink'] = isExternalLink;
    data['externalLink'] = externalLink;
    data['isActive'] = isActive;
    data['name'] = name;
    data['order'] = order;
    data['inMain'] = inMain;
    data['isClickable'] = isClickable;
    return data;
  }

  factory BannerModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BannerModel(
      imageUrl: data['imageUrl'],
      targetScreen: data['targetScreen'],
      isExternalLink: data['isExternalLink'],
      externalLink: data['externalLink'],
      isActive: data['isActive'],
      name: data['name'],
      order: data['order'],
      inMain: data['inMain'],
      isClickable: data['isClickable'],
    );
  }
}


class HomeImageModel {
  String imageUrl;
  final bool isClickable;
  final String externalLink;
  final int height;
  final String id;

  HomeImageModel({
    required this.imageUrl,
    required this.isClickable,
    required this.externalLink,
    required this.height,
    required this.id,
  });

  factory HomeImageModel.fromJson(Map<String, dynamic> json) {
    return HomeImageModel(
      imageUrl: json['imageUrl'],
      isClickable: json['isClickable'],
      externalLink: json['externalLink'],
      height: json['height'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = imageUrl;
    data['isClickable'] = isClickable;
    data['externalLink'] = externalLink;
    data['height'] = height;
    data['id'] = id;
    return data;
  }

  factory HomeImageModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return HomeImageModel(
      imageUrl: data['imageUrl'],
      isClickable: data['isClickable'],
      externalLink: data['externalLink'],
      height: data['height'],
      id: snapshot.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'isClickable': isClickable,
      'externalLink': externalLink,
      'height': height,
      'id': id,
    };
  }

}

