// razorpay_handler.dart
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayHandler {
  late Razorpay _razorpay;
  final Function onSuccess;
  final Function onFail;

  RazorpayHandler({
    required this.onSuccess,
    required this.onFail,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void initiatePayment({required double amount, required String orderId}) {
    var options = {
      'key': 'rzp_test_API_key',
      'amount': (amount * 100)
          .toInt(), // Razorpay takes amounts in the smallest currency unit, e.g., paise
      'name': 'Hostel96',
      'description': 'Product Description',
      'order_id':
          orderId, // Generate this id from your backend or use Razorpay API
      'prefill': {'contact': '9876543210', 'email': 'email@example.com'},
      'theme': {'color': '#FF0000'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error in Payment: $e');
      onFail(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Success Response: ${response.paymentId}');
    onSuccess(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Error: ${response.code} - ${response.message}');
    onFail(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
  }

  void dispose() {
    _razorpay.clear(); // Removes all listeners
  }
}
