import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:second/controllers/order_controller.dart';
import 'package:second/controllers/user_controller.dart';
import 'package:second/models/order_model.dart';
import 'package:second/screens/main/booking_details_screen.dart';
import 'package:second/screens/main/booking_page.dart';
import 'package:second/utils/constants/colors.dart';
import 'package:second/utils/constants/sizes.dart';
import 'package:second/utils/helpers/helper_functions.dart';
import 'package:second/widgets/appbar.dart';
import 'package:second/widgets/widgets.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  final orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    orderController.fetchOrdersByStudent(UserController.instance.user.value.id);
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Column(
        children: [
          CurveEdgesWidget(
            child: Column(
              children: [
                TAppBar(
                  title: Text(
                    'My Bookings',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(color: TColors.white),
                  ),
                  showBackArrow: false,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Obx(
                () => orderController.isOrderLoading.value
                    ? TAnimationLogoWidget()
                    : orderController.studentOrders.isEmpty
                        ? Center(
                            child: Text(
                              'No bookings found',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .apply(
                                      color:
                                          dark ? TColors.white : TColors.dark),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                                bottom: TSizes.spaceBtwSections),
                            itemCount: orderController.studentOrders.length,
                            itemBuilder: (context, index) {
                              final order =
                                  orderController.studentOrders[index];

                              return BookingCard(
                                order: order,
                                onTap: () {
                                  if (order.isCancelled) return;

                                  Get.to(
                                      () => BookingDetailsScreen(order: order));
                                },
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final OrderModel order;
  final Function() onTap;

  const BookingCard({
    Key? key,
    required this.order,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final statusColor = !order.isCancelled ? TColors.success : TColors.warning;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Card(
          color: dark ? TColors.white.withOpacity(0.1) : TColors.white,
          shadowColor: dark ? Colors.transparent : TColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.ticket,
                        color: Theme.of(context).primaryColor, size: 30),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        order.orderId,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Copy',
                      icon: Icon(Iconsax.copy,
                          color: Theme.of(context).primaryColor),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: order.orderId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy | HH:mm')
                          .format(order.orderDateTime),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order.isCancelled ? 'Cancelled' : order.orderStatus,
                        style: TextStyle(
                            color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Amount Paid :",
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),
                        Expanded(child: Container()),
                        Text(
                          formatAsIndianCurrency(order.amount),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: TColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
