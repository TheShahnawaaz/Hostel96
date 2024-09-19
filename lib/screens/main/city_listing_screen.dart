import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:second/controllers/city_detail_controller.dart';
import 'package:second/models/hostel_model.dart';
import 'package:second/screens/main/home.dart';
import 'package:second/utils/constants/colors.dart';
import 'package:second/utils/constants/image_strings.dart';
import 'package:second/utils/helpers/helper_functions.dart';
import 'package:second/widgets/appbar.dart';
import 'package:second/utils/constants/sizes.dart';
import 'package:second/screens/main/hostel_details_screen.dart';
import 'package:second/widgets/hostel_card.dart';
import 'package:second/widgets/shimmer_loader.dart';
import 'package:second/widgets/widgets.dart'; // Ensure you have this file created as described earlier

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'city_details_controller.dart';

class CityDetailsScreen extends StatelessWidget {
  final String? cityName;
  final String? stateName;

  CityDetailsScreen({Key? key, required this.cityName, required this.stateName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CityDetailsController(
        cityName ?? "")); // Use a default city name if none is provided
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Column(
        children: [
          CurveEdgesWidget(
            child: Column(
              children: [
                TAppBar(
                  title: Text('$cityName, $stateName',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white)),
                  showBackArrow: true,
                ),
                SearchTextField(
                  controller: controller.searchController,
                  onChanged: controller.filterHostels,
                  hintText: "Search for Hostel",
                  autoFocus: false,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              child: Obx(() {
                if (controller.isLoading.value && controller.hostels.isEmpty) {
                  return const TAnimationLogoWidget();
                } else if (controller.hostels.isEmpty &&
                    controller.isLastPage.value) {
                  return Center(
                    child: Text("We are not yet in $cityName",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: dark ? TColors.white : TColors.black,
                        )),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(0),
                  controller: controller.scrollController,
                  itemCount: controller.filteredHostels.length +
                      1 +
                      (controller.isLastPage.value ? 1 : 1),
                  itemBuilder: (context, index) {
                    // If list is empty, and

                    if (index == 0) {
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: TSizes.sm),
                        child: SectionHeading(
                          title: "Hostels in ${controller.cityName}",
                          showAction: false,
                          color: dark ? TColors.white : TColors.black,
                        ),
                      );
                    }
                    index -= 1; // Adjust the index to account for the header

                    if (index < controller.filteredHostels.length) {
                      return HostelCard(
                        hostel: controller.filteredHostels[index],
                        onTap: () => Get.to(
                            () => HostelDetailsScreen(
                                hostel: controller.filteredHostels[index]),
                            transition: Transition.fade),
                      );
                    } else if (index == controller.filteredHostels.length &&
                        !controller.isLastPage.value) {
                      // Show shimmer effect only if more items might be loaded
                      return HostelCardShimmer();
                    } else if (controller.isLastPage.value) {
                      // Show a message indicating no more hostels are available
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text("You've reached the end of the list",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: dark ? TColors.white : TColors.black,
                              )),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
