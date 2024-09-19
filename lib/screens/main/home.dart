import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:second/controllers/banner_controller.dart';
import 'package:second/controllers/user_controller.dart';
import 'package:second/widgets/appbar.dart';
import 'package:second/screens/main/city_list.dart';
import 'package:second/utils/constants/colors.dart';
import 'package:second/utils/constants/image_strings.dart';
import 'package:second/utils/constants/sizes.dart';
import 'package:second/utils/constants/text_strings.dart';
import 'package:second/utils/device/device_utility.dart';
import 'package:second/utils/helpers/helper_functions.dart';
import 'package:second/widgets/shimmer_loader.dart';

import '../../controllers/home_controller.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final userController = Get.put(UserController());
    final bannerController = Get.put(BannerController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurveEdgesWidget(
              child: Column(
                children: [
                  TAppBar(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(TTexts.homeAppbarTitle,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .apply(color: TColors.grey)),
                        Obx(() {
                          if (userController.isProfileLoading.value) {
                            return const TShimmerEffect(width: 100, height: 20);
                          }
                          return Text(
                              "Hello, ${userController.user.value.fullName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .apply(color: TColors.white));
                        }),
                      ],
                    ),
                    // actions: [
                    //   Stack(
                    //     children: [
                    //       IconButton(
                    //           onPressed: () {},
                    //           icon: const Icon(
                    //             Iconsax.shopping_bag,
                    //             color: TColors.white,
                    //           )),
                    //     ],
                    //   )
                    // ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SeachContainer(
                    text: "Search for City",
                    onTap: () => Get.to(() => const SearchCityListScreen()),
                  ),
                  // SizedBox(height: TSizes.spaceBtwSections),
                  PopularCities(),
                ],
              ),
            ),
            // const Text("data"),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: TSliderBanner(controller: bannerController),
            ),

            Obx(
              () => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                child: Container(
                  decoration: BoxDecoration(
                    color: TColors.light,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: (bannerController.isLoadingLargeBanner.value)
                        ? TShimmerEffect(
                            width: double.infinity,
                            height: 600,
                          )
                        : GestureDetector(
                            onTap: () {
                              if (!bannerController
                                  .largeBanner!.value.isClickable) return;

                              THelperFunctions.openLink(
                                  context,
                                  bannerController
                                      .largeBanner!.value.externalLink);
                            },
                            child: Image.network(
                              bannerController.largeBanner!.value.imageUrl,
                              fit: BoxFit.cover,
                              height: bannerController.largeBanner!.value.height
                                  .toDouble(),
                              width: double.infinity,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null)
                                  return child; // Image has fully loaded
                                return CustomImageLoader(
                                  width: double.infinity,
                                  height: bannerController
                                      .largeBanner!.value.height
                                      .toDouble(),
                                );
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                // Show a placeholder of same size if image fails to load
                                return CustomImageLoader(
                                  width: double.infinity,
                                  height: bannerController
                                      .largeBanner!.value.height
                                      .toDouble(),
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            Obx(
              () => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                child: Container(
                  decoration: BoxDecoration(
                    color: TColors.light,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: (bannerController.isLoadingFooterBanner.value)
                        ? const TShimmerEffect(
                            width: double.infinity,
                            height: 100,
                          )
                        : GestureDetector(
                            onTap: () {
                              if (!bannerController
                                  .footerBanner!.value.isClickable) return;

                              THelperFunctions.openLink(
                                  context,
                                  bannerController
                                      .footerBanner!.value.externalLink);
                            },
                            child: Image.network(
                              bannerController.footerBanner!.value.imageUrl,
                              fit: BoxFit.cover,
                              height: bannerController
                                  .footerBanner!.value.height
                                  .toDouble(),
                              width: double.infinity,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null)
                                  return child; // Image has fully loaded
                                return CustomImageLoader(
                                  width: double.infinity,
                                  height: bannerController
                                      .footerBanner!.value.height
                                      .toDouble(),
                                );
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                // Show a placeholder of same size if image fails to load
                                return CustomImageLoader(
                                  width: double.infinity,
                                  height: bannerController
                                      .footerBanner!.value.height
                                      .toDouble(),
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Padding(
            //   padding: const EdgeInsets.all(TSizes.defaultSpace),
            //   child: TSliderBanner(
            //     controller: controller,
            //     banners: const [
            //       TImages.promoPlaceholder,
            //       TImages.promoPlaceholder,
            //       TImages.promoPlaceholder,
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(TSizes.defaultSpace),
            //   child: TSliderBanner(
            //     controller: controller,
            //     banners: const [
            //       TImages.promoPlaceholder,
            //       TImages.promoPlaceholder,
            //       TImages.promoPlaceholder,
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class TSliderBanner extends StatelessWidget {
  final BannerController controller;

  const TSliderBanner({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const TShimmerEffect(
            width: double.infinity,
            height: 200,
          );
        }

        if (controller.banners.isEmpty) {
          return const TShimmerEffect(
            width: double.infinity,
            height: 200,
          );
        }

        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                // aspectRatio: 2.0,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  controller.updateCarouselIndex(index);
                },
              ),
              items: controller.banners
                  .map((banner) => TRoundedImage(
                        imageUrl: banner.imageUrl,
                        isNetworkImage: true,
                        onPressed: () {
                          if (banner.isExternalLink) {
                            // TExternalLinkLauncher.launch(banner.externalLink);
                          } else {
                            print("Target Screen: ${banner.targetScreen}");
                            Get.toNamed(banner.targetScreen);
                          }
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Center(
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < controller.banners.length; i++)
                      TCircularContainer(
                        width: 20,
                        height: 6,
                        margin: const EdgeInsets.only(right: 10),
                        backgroundColor:
                            controller.carouselCurrentIndex.value == i
                                ? TColors.primary
                                : TColors.grey,
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PopularCities extends StatelessWidget {
  PopularCities({
    super.key,
  });

  final List<Map<String, dynamic>> cities = [
    {"image": TImages.patnaIcon, "title": "Patna", "state": "Bihar"},
    {"image": TImages.kotaIcon, "title": "Kota", "state": "Rajasthan"},
    {"image": TImages.ranchiIcon, "title": "Ranchi", "state": "Jharkhand"},
    {"image": TImages.delhiIcon, "title": "Delhi", "state": "Delhi"},
    {"image": TImages.kolkataIcon, "title": "Kolkata", "state": "West Bengal"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            title: "Popular Cities",
            showAction: true,
            color: TColors.light,
            buttonText: "View All",
            onButtonPressed: () => Get.to(() => const SearchCityListScreen()),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          SizedBox(
            height: 100,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount:
                  cities.length, // Use dynamic length based on cities list
              itemBuilder: (context, index) {
                return VerticalImageTextCity(
                  image: cities[index]["image"],
                  title: cities[index]["title"],
                  textColor: TColors.light,
                  onTap: () {
                    Get.toNamed(
                      "/hostel-list/${cities[index]["title"]}/${cities[index]["state"]}",
                      parameters: {
                        "city": cities[index]["title"],
                        "state": cities[index]["state"],
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    this.color = TColors.dark,
    this.showAction = true,
    this.buttonText = "View All",
    required this.title,
    this.onButtonPressed,
  });

  final Color color;
  final bool showAction;
  final String title;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style:
                Theme.of(context).textTheme.headlineMedium!.apply(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        if (showAction)
          TextButton(
            onPressed: onButtonPressed,
            child: Text(buttonText,
                style:
                    Theme.of(context).textTheme.bodyMedium!.apply(color: color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
      ],
    );
  }
}

class SeachContainer extends StatelessWidget {
  const SeachContainer({
    super.key,
    this.text = "Search for City",
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
  });

  final String text;
  final IconData icon;
  final bool showBackground, showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
        child: Container(
          width: TDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
            color: showBackground
                ? dark
                    ? TColors.dark
                    : TColors.light
                : Colors.transparent,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            border: showBorder
                ? Border.all(
                    color: dark ? TColors.darkGrey : TColors.lightGrey,
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Iconsax.search_normal, color: TColors.darkGrey),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text("Search for City",
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
