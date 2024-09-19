import 'package:cloud_firestore/cloud_firestore.dart';

class CityModel {
  final String id;
  final String city;
  final String state;

  CityModel({
    required this.id,
    required this.city,
    required this.state,
  });

  static CityModel empty() => CityModel(id: '', city: '', state: '');

  Map<String, dynamic> toJson() => {
        'Id': id,
        'City': city,
        'State': state,
      };

  factory CityModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() != null) {
      final data = snapshot.data()!;
      return CityModel(
        id: snapshot.id,
        city: data['City'] ?? '',
        state: data['State'] ?? '',
      );
    } else {
      return CityModel.empty();
    }
  }
}
