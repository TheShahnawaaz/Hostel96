import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second/utils/formatters/formatter.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  final String email;
  String phone;



  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });


  String get fullName => '$firstName $lastName';


  String get formattedPhoneNumber => TFormatter.formatPhoneNumber(phone);

  static List<String> nameParts(fullName) => fullName.split(' ');

  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
  );

  Map<String, dynamic> toJson() => {
        'FirstName': firstName,
        'LastName': lastName,
        'Email': email,
        'Phone': phone,
  };


  // Add a updated factory method to the UserModel class
  factory UserModel.updated({
    required UserModel user,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return UserModel(
      id: user.id,
      firstName: firstName ?? user.firstName,
      lastName: lastName ?? user.lastName,
      email: email ?? user.email,
      phone: phone ?? user.phone,
    );
  }



  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
  {
    if (snapshot.data() != null) {
      final data = snapshot.data()!;
      return UserModel(
        id: snapshot.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        email: data['Email'] ?? '',
        phone: data['Phone'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }


}
