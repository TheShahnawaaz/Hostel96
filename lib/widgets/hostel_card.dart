import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second/models/hostel_model.dart';
import 'package:second/screens/main/hostel.dart';
import 'package:iconsax/iconsax.dart';
import 'package:second/utils/constants/colors.dart';
import 'package:second/utils/constants/image_strings.dart';
import 'package:second/utils/constants/sizes.dart';
import 'package:second/utils/helpers/helper_functions.dart'; // Ensure you have this library in your pubspec.yaml
import 'package:flutter/material.dart';
import 'package:second/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:second/utils/constants/colors.dart';

class HostelCard extends StatelessWidget {
  final HostelModel hostel;
  final VoidCallback onTap;

  const HostelCard({
    Key? key,
    required this.hostel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5, // Adds shadow to the card
        margin: const EdgeInsets.all(8),
        color: dark ? TColors.white.withOpacity(0.1) : TColors.white,
        shadowColor: dark ? Colors.transparent : TColors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)), // Rounded corners
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: Image.network(
                    hostel.imageSliderUrls[hostel.thumbnailIndex],
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null)
                        return child; // Image has fully loaded
                      return CustomImageLoader(
                        width: double.infinity,
                        height: 200.0,
                      );
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      // Show a placeholder of same size if image fails to load
                      return const ImageNotFound(
                        width: double.infinity,
                        height: 200.0,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: dark
                              ? const Color.fromARGB(255, 70, 71, 76)
                              : const Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              getHostelTypeIcon(hostel.type),
                              color: TColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hostel.type,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: dark ? TColors.white : TColors.black,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: dark
                              ? const Color.fromARGB(255, 70, 71, 76)
                              : const Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              getGenderIcon(hostel.gender),
                              color: TColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hostel.gender,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: dark ? TColors.white : TColors.black,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hostel.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Iconsax.location,
                          size: 16, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hostel.area,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Samall text says starting from
                          Row(
                            children: [
                              Text(
                                'Starting from',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ' ₹${hostel.dummyPrice}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: TColors.primary.withOpacity(0.6),
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Price of the hostel
                          Row(
                            children: [
                              Text(
                                '₹${hostel.minPrice}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      color: TColors.primary,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '/month',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Add a book button here
                      ElevatedButton(
                        onPressed: onTap,
                        child: Text('Reserve Now',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: TColors.white,
                                )),
                        style: ElevatedButton.styleFrom(
                          // primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function for getting gender icon from string

  IconData getGenderIcon(String gender) {
    switch (gender) {
      case 'Male':
        return Icons.male;
      case 'Female':
        return Icons.female;
      default:
        return CupertinoIcons.person;
    }
  }

  IconData getHostelTypeIcon(String type) {
    switch (type) {
      case 'Pg':
        return Iconsax.home;
      case 'Hostel':
        return Iconsax.buildings;
      default:
        return Icons.home;
    }
  }
}

class HostelCardShimmer extends StatelessWidget {
  const HostelCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      color: dark ? TColors.white.withOpacity(0.1) : TColors.white,
      shadowColor: dark ? Colors.transparent : TColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 20,
                    width: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 24,
                        width: 100,
                        color: Colors.white,
                      ),
                      Container(
                        height: 24,
                        width: 100,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 20,
                        width: 60,
                        color: Colors.white,
                      ),
                      Container(
                        height: 20,
                        width: 100,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
