import 'package:cloud_firestore/cloud_firestore.dart';


class OrderModel {
  final String orderId;
  final String studentId;
  final String landlordId;
  final String hostelId;
  final DateTime orderDateTime;
  final String variationId;
  final int amount;
  final bool isCancelled;
  final bool isShifted;
  final String paymentStatus; // New field
  final String orderStatus; // New field

  OrderModel({
    required this.orderId,
    required this.studentId,
    required this.landlordId,
    required this.hostelId,
    required this.orderDateTime,
    required this.variationId,
    required this.amount,
    this.isCancelled = false,
    this.isShifted = false,
    this.paymentStatus = 'Pending', // Default value
    this.orderStatus = 'Processing', // Default value
  });

  static OrderModel empty() => OrderModel(
        orderId: '',
        studentId: '',
        landlordId: '',
        hostelId: '',
        orderDateTime: DateTime.now(),
        variationId: '',
        amount: 0,
      );

  Map<String, dynamic> toJson() {
    return {
      // 'OrderId': orderId, // Change
      'StudentId': studentId,
      'LandlordId': landlordId,
      'HostelId': hostelId,
      'OrderDateTime': orderDateTime.toIso8601String(),
      'VariationId': variationId,
      'Amount': amount,
      'IsCancelled': isCancelled,
      'IsShifted': isShifted,
      'PaymentStatus': paymentStatus,
      'OrderStatus': orderStatus,
    };
  }

  factory OrderModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() == null) {
      return OrderModel.empty();
    }
    final data = snapshot.data()!;
    return OrderModel(
      orderId: snapshot.id, //Change 
      studentId: data['StudentId'],
      landlordId: data['LandlordId'],
      hostelId: data['HostelId'],
      orderDateTime: DateTime.parse(data['OrderDateTime']),
      variationId: data['VariationId'],
      amount: data['Amount'],
      isCancelled: data['IsCancelled'],
      isShifted: data['IsShifted'],
      paymentStatus: data['PaymentStatus'],
      orderStatus: data['OrderStatus'],
    );
  }

  factory OrderModel.updated({
    required OrderModel order,
    String? orderId,
    String? studentId,
    String? landlordId,
    String? hostelId,
    DateTime? orderDateTime,
    String? variationId,
    int? amount,
    bool? isCancelled,
    bool? isShifted,
    String? paymentStatus,
    String? orderStatus,
  }) {
    return OrderModel(
      orderId: orderId ?? order.orderId,
      studentId: studentId ?? order.studentId,
      landlordId: landlordId ?? order.landlordId,
      hostelId: hostelId ?? order.hostelId,
      orderDateTime: orderDateTime ?? order.orderDateTime,
      variationId: variationId ?? order.variationId,
      amount: amount ?? order.amount,
      isCancelled: isCancelled ?? order.isCancelled,
      isShifted: isShifted ?? order.isShifted,
      paymentStatus: paymentStatus ?? order.paymentStatus,
      orderStatus: orderStatus ?? order.orderStatus,
    );
  }
}
