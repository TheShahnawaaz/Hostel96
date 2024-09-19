import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:second/controllers/order_controller.dart';
import 'package:second/controllers/user_controller.dart';
import 'package:second/models/hostel_model.dart';
import 'package:second/models/order_model.dart';
// import 'package:second/razorpay/razorpay_handler.dart';
import 'package:second/screens/main/home.dart';
import 'package:second/screens/main/hostel_details_screen.dart';
import 'package:second/utils/constants/colors.dart';
import 'package:second/utils/constants/image_strings.dart';
import 'package:second/utils/constants/sizes.dart';
import 'package:second/utils/helpers/helper_functions.dart';
import 'package:second/widgets/appbar.dart';
import 'package:second/widgets/navigation_menu.dart';
import 'package:second/widgets/widgets.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class BookingPage extends StatefulWidget {
  final HostelModel hostel;
  final String variationId;

  BookingPage({Key? key, required this.hostel, required this.variationId})
      : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    TLoaders.errorSnackbar(title: "Payment Failed", message: response.message!);
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    Get.put(OrderController());

    final orderController = OrderController.instance;

    final variation = widget.hostel.hostelVariations.firstWhere(
        (vari) => vari.id == widget.variationId,
        orElse: () => HostelVariation());

    print(
        "Response : paymentId : ${response.paymentId}, orderId : ${response.orderId}, signature : ${response.signature}");

    final newOrder = OrderModel.updated(
      order: OrderModel.empty(),
      orderId: response.paymentId ?? '',
      studentId: UserController.instance.user.value.id,
      landlordId: widget.hostel.landlordId,
      hostelId: widget.hostel.id,
      variationId: widget.variationId,
      amount: (1.12 * variation.finalPrice).toInt(),
      paymentStatus: "PAID",
      orderStatus: "CONFIRMED",
    );

    orderController.createOrder(newOrder);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    TLoaders.warningSnackbar(
        title: "External Wallet Selected", message: response.walletName!);
  }

  Future<String> _loadAssetAsBase64(String path) async {
    final bytes = await rootBundle.load(path);
    final buffer = bytes.buffer;
    final base64String = base64Encode(Uint8List.view(buffer));
    return base64String;
  }

  void startPayment() async {
    final variation = widget.hostel.hostelVariations
        .firstWhere((vari) => vari.id == widget.variationId);

    final logoBase64 = await _loadAssetAsBase64(TImages.lightAppLogo);

    var options = {
      'key': 'rzp_live_API_key',
      'amount': (variation.finalPrice * 112).toInt(), // Amount in paise
      'currency': 'INR',
      'name': 'Hostel96',
      'description': widget.hostel.name,
      'retry': {'enabled': true, 'max_count': 1},
      'image': 'data:image/png;base64,$logoBase64', // Local image as Base64
      'send_sms_hash': true,
      'prefill': {
        'contact': UserController.instance.user.value.phone,
        'email': UserController.instance.user.value.email,
        'name': UserController.instance.user.value.fullName,
      },
    };
    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    final variation = widget.hostel.hostelVariations.firstWhere(
        (vari) => vari.id == widget.variationId,
        orElse: () => HostelVariation());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Column(
        children: [
          CurveEdgesWidget(
            child: Column(
              children: [
                TAppBar(
                  title: Text('Booking Summary',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white)),
                  showBackArrow: true,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 1,
              itemBuilder: (context, index) => Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.defaultSpace),
                      child: Card(
                        color: dark
                            ? TColors.white.withOpacity(0.1)
                            : TColors.white,
                        shadowColor: dark ? Colors.transparent : TColors.white,
                        child: CustomHostelTile(
                          hostel: widget.hostel,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 5,
                      height: 30,
                      color: dark
                          ? const Color.fromARGB(255, 70, 71, 76)
                          : const Color.fromARGB(255, 240, 240, 240),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.defaultSpace),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: TSizes.defaultSpace),
                        child: Text('Chosen Variation',
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.defaultSpace),
                      child: Card(
                        color: dark
                            ? TColors.white.withOpacity(0.1)
                            : TColors.white,
                        shadowColor: dark ? Colors.transparent : TColors.white,
                        elevation: 1,
                        margin: EdgeInsets.all(0),
                        child: ListTile(
                          selectedTileColor: TColors.primary,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          dense: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          title: Text("${variation.sharingType}",
                              style:
                                  Theme.of(context).textTheme.headlineMedium!,
                              overflow: TextOverflow.ellipsis),
                          subtitle: Text(
                              "Price after 1st month: ${formatAsIndianCurrency(variation.askedPrice)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 10,
                                  ),
                              overflow: TextOverflow.ellipsis),
                          trailing: Text(
                            formatAsIndianCurrency(variation.finalPrice),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: TColors.primary,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.defaultSpace),
                      child: AlertBox(
                        title: 'Discount only available for first month',
                        subtitle:
                            'Contact the hostel owner or customer support if you have any questions.',
                        type: AlertType.success,
                        icon: Icons.monetization_on,
                      ),
                    ),
                    Divider(
                      thickness: 5,
                      height: 30,
                      indent: 0,
                      endIndent: 0,
                      color: dark
                          ? const Color.fromARGB(255, 70, 71, 76)
                          : const Color.fromARGB(255, 240, 240, 240),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.defaultSpace),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: TSizes.defaultSpace),
                        child: Text('Booking Details',
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.defaultSpace),
                      child: PriceDetailsWidget(
                          priceDetails: variation.finalPrice,
                          originalPrice: variation.askedPrice),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    SizedBox(height: TSizes.spaceBtwItems),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.defaultSpace),
                      child: AlertBox(
                        title: 'No Additional Cost Included',
                        subtitle:
                            'There are no hidden extra charges in this booking.',
                        type: AlertType.success,
                        icon: Icons.monetization_on,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        SlideAction(
          onSlideCompleted: startPayment,
        ),
      ],
    );
  }
}

String formatAsIndianCurrency(int number) {
  final formatCurrency = NumberFormat.currency(
    locale: "en_IN", // Set locale to Indian
    symbol: "₹", // Define the currency symbol
    decimalDigits: 2, // Define the number of decimal places
  );
  return formatCurrency.format(number);
}

enum AlertType { success, error, warning }

class AlertBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final AlertType type;
  final IconData icon;

  const AlertBox({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
  }) : super(key: key);

  Color _getBackgroundColor() {
    switch (type) {
      case AlertType.success:
        return Colors.green[100]!;
      case AlertType.error:
        return Colors.red[100]!;
      case AlertType.warning:
        return Colors.orange[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.warning:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: Border.all(color: _getBorderColor()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: _getBorderColor(), size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: _getBorderColor())),
                Text(subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SlideAction extends StatefulWidget {
  final VoidCallback onSlideCompleted;
  const SlideAction({Key? key, required this.onSlideCompleted})
      : super(key: key);

  @override
  State<SlideAction> createState() => _SlideActionState();
}

class _SlideActionState extends State<SlideAction> {
  double _dragPosition = 0;
  double _dragPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: TColors.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Center(
            child: Text(
              'SLIDE TO BOOK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: _dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragPosition += details.primaryDelta ?? 0;
                  _dragPercentage = _dragPosition / (context.size?.width ?? 1);
                  if (_dragPosition < 0) {
                    _dragPosition = 0;
                  } else if (_dragPosition > context.size!.width - 60) {
                    _dragPosition = context.size!.width - 60;
                  }
                });
              },
              onHorizontalDragEnd: (details) {
                print(_dragPercentage);
                if (_dragPercentage > 0.70) {
                  widget.onSlideCompleted();
                }
                setState(() {
                  _dragPosition = 0; // Reset the button to the start position
                  _dragPercentage = 0;
                });
              },
              child: Container(
                margin: EdgeInsets.all(5),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(Iconsax.direct_right, color: TColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PriceDetailsWidget extends StatelessWidget {
  final int priceDetails;
  final int originalPrice;

  const PriceDetailsWidget({
    Key? key,
    required this.priceDetails,
    required this.originalPrice,
  }) : super(key: key);

  Widget _buildPriceDetailRow(String label, dynamic value,
      {bool isTotal = false, bool isOriginalPrice = false}) {
    final dark = THelperFunctions.isDarkMode(Get.context!);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
                fontSize: 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: !dark
                    ? (isTotal ? Colors.black : Colors.black54)
                    : (isTotal ? Colors.white : Colors.white70),
                decoration: isOriginalPrice
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Card(
      color: dark ? TColors.white.withOpacity(0.1) : TColors.white,
      shadowColor: dark ? Colors.transparent : TColors.white,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     'Price details',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          // Divider(),
          _buildPriceDetailRow(
              'Original Price', formatAsIndianCurrency(originalPrice),
              isOriginalPrice: true),
          _buildPriceDetailRow(
              'Hostel96 Price', formatAsIndianCurrency(priceDetails)),
          _buildPriceDetailRow('Term length', '1 month'),
          _buildPriceDetailRow(
              'Total rent', formatAsIndianCurrency(priceDetails)),
          Divider(),
          _buildPriceDetailRow('GST (12%)',
              formatAsIndianCurrency((0.12 * priceDetails).toInt())),
          _buildPriceDetailRow('Brokerage Charges', formatAsIndianCurrency(0)),
          _buildPriceDetailRow('Convenience Fee', formatAsIndianCurrency(0)),
          _buildPriceDetailRow(
              'Hostel96 Service Fee', formatAsIndianCurrency(0)),
          Divider(),
          _buildPriceDetailRow('Net Total',
              formatAsIndianCurrency((1.12 * priceDetails).toInt()),
              isTotal: true),
        ],
      ),
    );
  }
}
