// import 'package:cloud_firestore/cloud_firestore.dart';

// class LandlordModel {
//   final String id;
//   String firstName;
//   String lastName;
//   final String email;
//   String phone;
//   // Bank Details
//   String bankName;
//   String accountNumber;
//   String ifscCode;
//   String beneficiaryName;
//   String upiId; // Optional, depending on your requirements
//   String gstNumber;
//   String address;
//   DateTime? createdAt;
//   DateTime? updatedAt;

//   LandlordModel({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.phone,
//     required this.bankName,
//     required this.accountNumber,
//     required this.ifscCode,
//     required this.beneficiaryName,
//     required this.upiId,
//     required this.gstNumber,
//     required this.address,
//     this.createdAt,
//     this.updatedAt,
//   });

//   String get fullName => '$firstName $lastName';

//   static List<String> nameParts(fullName) => fullName.split(' ');

//   static LandlordModel empty() => LandlordModel(
//         id: '',
//         firstName: '',
//         lastName: '',
//         email: '',
//         phone: '',
//         bankName: '',
//         accountNumber: '',
//         ifscCode: '',
//         beneficiaryName: '',
//         upiId: '',
//         gstNumber: '',
//         address: '',
//         createdAt: null,
//         updatedAt: null,
//       );

//   Map<String, dynamic> toJson() => {
//         'FirstName': firstName,
//         'LastName': lastName,
//         'Email': email,
//         'Phone': phone,
//         'BankName': bankName,
//         'AccountNumber': accountNumber,
//         'IfscCode': ifscCode,
//         'BeneficiaryName': beneficiaryName,
//         'UpiId': upiId,
//         'GstNumber': gstNumber,
//         'Address': address,
//         'CreatedAt': createdAt?.toIso8601String(),
//         'UpdatedAt': updatedAt?.toIso8601String(),
//       };

//   factory LandlordModel.fromSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> snapshot) {
//     if (snapshot.data() != null) {
//       final data = snapshot.data()!;
//       return LandlordModel(
//         id: snapshot.id,
//         firstName: data['FirstName'] ?? '',
//         lastName: data['LastName'] ?? '',
//         email: data['Email'] ?? '',
//         phone: data['Phone'] ?? '',
//         bankName: data['BankName'] ?? '',
//         accountNumber: data['AccountNumber'] ?? '',
//         ifscCode: data['IfscCode'] ?? '',
//         beneficiaryName: data['BeneficiaryName'] ?? '',
//         upiId: data['UpiId'] ?? '',
//         gstNumber: data['GstNumber'] ?? '',
//         address: data['Address'] ?? '',
//         createdAt: data['CreatedAt'] != null
//             ? (data['CreatedAt'] as Timestamp).toDate()
//             : null,
//         updatedAt: data['UpdatedAt'] != null
//             ? (data['UpdatedAt'] as Timestamp).toDate()
//             : null,
//       );
//     } else {
//       return LandlordModel.empty();
//     }
//   }

//   factory LandlordModel.updated({
//     required LandlordModel landlord,
//     String? firstName,
//     String? lastName,
//     String? email,
//     String? phone,
//     String? bankName,
//     String? accountNumber,
//     String? ifscCode,
//     String? beneficiaryName,
//     String? upiId,
//     String? gstNumber,
//     String? address,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return LandlordModel(
//       id: landlord.id,
//       firstName: firstName ?? landlord.firstName,
//       lastName: lastName ?? landlord.lastName,
//       email: email ?? landlord.email,
//       phone: phone ?? landlord.phone,
//       bankName: bankName ?? landlord.bankName,
//       accountNumber: accountNumber ?? landlord.accountNumber,
//       ifscCode: ifscCode ?? landlord.ifscCode,
//       beneficiaryName: beneficiaryName ?? landlord.beneficiaryName,
//       upiId: upiId ?? landlord.upiId,
//       gstNumber: gstNumber ?? landlord.gstNumber,
//       address: address ?? landlord.address,
//       createdAt: createdAt ?? landlord.createdAt,
//       updatedAt: updatedAt ?? landlord.updatedAt,
//     );
//   }
//   // Add more methods as needed
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class LandlordModel {
  final String id;
  String firstName;
  String lastName;
  final String email;
  String phone;

  // Bank Details
  String bankName;
  String accountNumber;
  String ifscCode;
  String beneficiaryName;
  String bankBranch;
  String upiId; // Optional, depending on your requirements

  String address;

  LandlordModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.beneficiaryName,
    required this.bankBranch,
    required this.upiId,
    required this.address,
  });

  String get fullName => '$firstName $lastName';

  static List<String> nameParts(fullName) => fullName.split(' ');

  static LandlordModel empty() => LandlordModel(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        bankName: '',
        accountNumber: '',
        ifscCode: '',
        beneficiaryName: '',
        bankBranch: '',
        upiId: '',
        address: '',
      );

  Map<String, dynamic> toJson() => {
        'FirstName': firstName,
        'LastName': lastName,
        'Email': email,
        'Phone': phone,
        'BankName': bankName,
        'AccountNumber': accountNumber,
        'IfscCode': ifscCode,
        'BeneficiaryName': beneficiaryName,
        'BankBranch': bankBranch,
        'UpiId': upiId,
        'Address': address,
      };

  factory LandlordModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    // Check if the snapshot has data before accessing it

    if (snapshot.data() != null) {
      final data = snapshot.data()!;

      LandlordModel landlord = LandlordModel(
        id: snapshot.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        email: data['Email'] ?? '',
        phone: data['Phone'] ?? '',
        bankName: data['BankName'] ?? '',
        accountNumber: data['AccountNumber'] ?? '',
        ifscCode: data['IfscCode'] ?? '',
        beneficiaryName: data['BeneficiaryName'] ?? '',
        bankBranch: data['BankBranch'] ?? '',
        upiId: data['UpiId'] ?? '',
        address: data['Address'] ?? '',
      );
      print(landlord.firstName);
      return landlord;
    } else {
      return LandlordModel.empty();
    }
  }

  // Add a updated factory method to the LandlordModel class
  factory LandlordModel.updated({
    required LandlordModel landlord,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? beneficiaryName,
    String? bankBranch,
    String? upiId,
    String? gstNumber,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LandlordModel(
      id: landlord.id,
      firstName: firstName ?? landlord.firstName,
      lastName: lastName ?? landlord.lastName,
      email: email ?? landlord.email,
      phone: phone ?? landlord.phone,
      bankName: bankName ?? landlord.bankName,
      accountNumber: accountNumber ?? landlord.accountNumber,
      ifscCode: ifscCode ?? landlord.ifscCode,
      beneficiaryName: beneficiaryName ?? landlord.beneficiaryName,
      bankBranch: bankBranch ?? landlord.bankBranch,
      upiId: upiId ?? landlord.upiId,
      address: address ?? landlord.address,
    );
  }

  // Add more methods as needed
}
