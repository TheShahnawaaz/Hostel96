import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Using GetX for navigation and state management
import 'package:iconsax/iconsax.dart';
import 'package:second/screens/main/city_listing_screen.dart';
import 'package:second/widgets/appbar.dart';
import 'package:second/screens/main/home.dart';
import 'package:second/utils/constants/colors.dart';
import 'package:second/utils/constants/sizes.dart';
import 'package:second/utils/helpers/helper_functions.dart';
import '../../widgets/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:second/controllers/city_controller.dart'; // Import your CityController

class SearchCityListScreen extends StatefulWidget {
  const SearchCityListScreen({super.key});

  @override
  State<SearchCityListScreen> createState() => _SearchCityListScreenState();
}

class _SearchCityListScreenState extends State<SearchCityListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // No need for _filteredCities as it's managed in the controller
  // bool _isLoading = true; // No need as loading state is also in the controller

  final cityController =
      Get.put(CityController()); // Create an instance of CityController

  // final cityController = CityController(); // Get the CityController instance

  // @override
  // void initState() {
  //   super.initState();
  //   cityController.fetchCities(); // Fetch cities on screen initialization
  // }

  // void _filterCities(String enteredKeyword) {
  //   cityController.filterCities(
  //       enteredKeyword); // Call the filter method in the controller
  // }

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
                    'Search by City',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(color: TColors.white),
                  ),
                  showBackArrow: true,
                ),
                SearchTextField(
                  controller: _searchController,
                  onChanged: cityController.filterCities,
                  hintText: "Search for City",
                  autoFocus: false,
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
                // Use Obx to observe changes in the controller
                () => cityController.isLoading.value
                    ? TAnimationLogoWidget()
                    : cityController.filteredCities.isEmpty
                        ? Center(
                            child: Text(
                              'No cities found',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .apply(
                                      color:
                                          dark ? TColors.white : TColors.dark),
                            ),
                          )
                        : Column(
                            children: [
                              SectionHeading(
                                title: 'All Cities',
                                showAction: false,
                                color: dark ? TColors.white : TColors.dark,
                              ),
                              Expanded(
                                flex: 1,
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: TSizes.spaceBtwItems),
                                  itemCount:
                                      cityController.filteredCities.length,
                                  itemBuilder: (context, index) {
                                    final cityData =
                                        cityController.filteredCities[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      child: Card(
                                        color: dark
                                            ? TColors.white.withOpacity(0.1)
                                            : TColors.white,
                                        shadowColor: dark
                                            ? Colors.transparent
                                            : TColors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        elevation: 4.0,
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),
                                          leading: Icon(Iconsax.location,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 30),
                                          title: Text(
                                            cityData.city,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                          subtitle: Text(
                                            cityData.state,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          trailing: Icon(Iconsax.arrow_right_3,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          onTap: () {
                                            Get.to(() => CityDetailsScreen(
                                                  cityName: cityData.city,
                                                  stateName: cityData.state,
                                                ));
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
