import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:second/controllers/user_controller.dart';
import 'package:second/models/hostel_model.dart';
import 'package:second/models/landlord_model.dart';
import 'package:second/screens/main/booking_page.dart';
import 'package:second/screens/main/home.dart';
import 'package:second/utils/constants/colors.dart';
import 'package:second/utils/constants/sizes.dart';
import 'package:second/utils/constants/text_strings.dart';
import 'package:second/utils/helpers/helper_functions.dart';
import 'package:second/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class HostelDetailsScreen extends StatefulWidget {
  final HostelModel hostel;

  HostelDetailsScreen({Key? key, required this.hostel}) : super(key: key);

  @override
  _HostelDetailsScreenState createState() => _HostelDetailsScreenState();
}

class _HostelDetailsScreenState extends State<HostelDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  final userController = UserController.instance;

  double _opacity = 0.0;
  double _courselOpacity = 1.0;
  int _current = 0; // Current index of the carousel

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _opacity = offset <= 0
          ? 0.0
          : (offset > 0 && offset <= 300 ? offset / 300 : 1.0);
      _courselOpacity = offset <= 0
          ? 1.0
          : (offset > 0 && offset <= 220 ? 1 - (offset / 220) : 0.0);
    });
  }

  String? _selectedId; // For tracking the selected variation

  @override
  Widget build(BuildContext context) {
    List<HostelVariation> variations = widget.hostel.hostelVariations;
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _courselOpacity,
                  child: ClipPath(
                    clipper: CustomCurvesEdges(),
                    child: Stack(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            height: 350.0,
                            viewportFraction: 1.0,
                            enableInfiniteScroll:
                                false, // Disable infinite scroll
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          items: widget.hostel.imageSliderUrls
                              .map((item) => Image.network(
                                    item,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null)
                                        return child; // Image has fully loaded
                                      return CustomImageLoader(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 350.0,
                                        loadingProgress: loadingProgress,
                                        showProgressIndicator: true,
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return ImageNotFound(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 350.0,
                                      );
                                    },
                                  ))
                              .toList(),
                        ),

                        // Carousel indicator
                        CarouselIndicator(widget: widget, current: _current),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  // Your list tiles go here
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomHostelTile(hostel: widget.hostel),
                        HostelPricingTile(hostel: widget.hostel),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: TSizes.defaultSpace),
                              child: Text(
                                'Choose your variation',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics:
                                    NeverScrollableScrollPhysics(), // to disable scrolling within the ListView
                                itemCount: variations.length,
                                itemBuilder: (context, index) {
                                  HostelVariation variation = variations[index];
                                  bool isEnabled = variation.bedCount != 0;
                                  return Card(
                                    elevation: 1,
                                    margin: EdgeInsets.all(8),
                                    child: RadioListTile<String>(
                                      // selected: _selectedId == variation.id,
                                      selectedTileColor: TColors.primary,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0),
                                      dense:
                                          true, // To reduce the space between the elements
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      value: variation.id,
                                      groupValue: _selectedId,
                                      title: Text(
                                        "${variation.sharingType}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                              color: isEnabled
                                                  ? null
                                                  : Colors.grey,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onChanged: isEnabled
                                          ? (String? value) {
                                              setState(() {
                                                _selectedId = value;
                                              });
                                            }
                                          : (String? value) {
                                              TLoaders.warningSnackbar(
                                                  message:
                                                      "No bed available in this variation",
                                                  title: "Not Bed Available");
                                            },
                                      activeColor: TColors.primary,
                                      secondary: Text(
                                        '₹${variation.finalPrice}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                              color: isEnabled
                                                  ? TColors.primary
                                                  : Colors.grey,
                                            ),
                                      ),
                                      fillColor: MaterialStateProperty.all(
                                          TColors.primary),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Divider(
                              thickness: 5,
                              height: 30,
                              color: dark
                                  ? const Color.fromARGB(255, 70, 71, 76)
                                  : const Color.fromARGB(255, 240, 240, 240),
                            ),
                          ],
                        ),
                        HostelAnimitiesTile(hostel: widget.hostel),
                        HostelAdressTile(hostel: widget.hostel),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          TopBarAnimated(opacity: _opacity, widget: widget),
        ],
      ),
      persistentFooterButtons: [
        Row(children: [
          IconButton(
            icon: Icon(
              Icons.call,
              color: TColors.white,
            ),
            onPressed: () => _showConfirmationDialog(context,
                userController.user.value.phone, widget.hostel.landlordId),
            iconSize: 35,
            tooltip: "Call Landlord",
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                TColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                print("Selected variation: ${_selectedId}");
                // Add your logic here
                if (_selectedId == null) {
                  TLoaders.warningSnackbar(
                      message: "Please Select a variation to proceed",
                      title: "Variation not selected");
                  return;
                }
                Get.to(() => BookingPage(
                      hostel: widget.hostel,
                      variationId: _selectedId!,
                    ));
              },
              child: Text('Reserve Now'),
            ),
          ),
        ])
      ],
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String phoneNumber, String landlordId) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    final landlordSnapshot =
        await _db.collection('Landlords').doc(landlordId).get();
    if (landlordSnapshot.exists) {
      final landlord = LandlordModel.fromSnapshot(landlordSnapshot);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Call Request'),
            content: Text(
                'Request call for $phoneNumber?\nIf this is not your phone number, please update your phone number in your profile.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  // https://prpmobility.com/Api/ClickCallReq.aspx?uname=20240139&pass=20240139&reqid=121&aparty=9472859728&bparty=7209390860
                  final response = await http.get(Uri.parse(
                      'https://prpmobility.com/Api/ClickCallReq.aspx?uname=20240139&pass=20240139&reqid=121&aparty=${landlord.phone}&bparty=$phoneNumber'));
                  if (response.statusCode == 200) {
                    // Successfully called the endpoint
                    TLoaders.successSnackbar(
                        title: "Call Request Sent",
                        message:
                            "You will get a call from the landlord in few minutes.");
                  } else {
                    // Error calling the endpoint
                    TLoaders.errorSnackbar(
                        title: "Call Request Failed",
                        message: "Please try again later.");
                  }

                  print(landlord.phone);
                },
                child: Text('Yes'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class HostelAdressTile extends StatelessWidget {
  const HostelAdressTile({
    super.key,
    required this.hostel,
  });

  final HostelModel hostel;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Address Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              (hostel.googleAddressLink.isNotEmpty)
                  ? GestureDetector(
                      onTap: () =>
                          launchUrl(Uri.parse(hostel.googleAddressLink)),
                      child: Container(
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
                              Iconsax.location,
                              color: Theme.of(context).primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Show on Map',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: dark ? Colors.white : Colors.black,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.defaultSpace,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text('Full Address',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: TColors.primary,
                      )),
              Text(
                hostel.fullAddress,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      // overflow: TextOverflow.ellipsis,
                    ),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              Text('Locality',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: TColors.primary,
                      )),
              Text(
                hostel.locality,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      // overflow: TextOverflow.ellipsis,
                    ),
                // maxLines: 2,
              ),
              const SizedBox(height: 10),
              (hostel.instituteName.isNotEmpty)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nearby Institute/College',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: TColors.primary,
                                )),
                        Text(
                          hostel.instituteName,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                          // maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        Divider(
          thickness: 5,
          height: 5,
          color: dark
              ? const Color.fromARGB(255, 70, 71, 76)
              : const Color.fromARGB(255, 240, 240, 240),
        ),
      ],
    );
  }
}

class HostelAnimitiesTile extends StatelessWidget {
  const HostelAnimitiesTile({
    super.key,
    required this.hostel,
  });

  final HostelModel hostel;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Text(
            'Amenities',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics:
                NeverScrollableScrollPhysics(), // to disable scrolling within the ListView
            itemExtent: 50,
            children: _getAvailableAmenities(hostel)
                .map(
                  (amenity) => _buildSwitchListTile(
                    context,
                    amenity['icon'],
                    amenity['title'],
                    amenity['key'],
                    amenity['subtitle'],
                  ),
                )
                .toList(),
          ),
        ),
        Divider(
          thickness: 5,
          height: 30,
          color: dark
              ? const Color.fromARGB(255, 70, 71, 76)
              : const Color.fromARGB(255, 240, 240, 240),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getAvailableAmenities(HostelModel hostel) {
    return [
      {
        'icon': Icons.restaurant,
        'title': TTexts.foodAvailable,
        'key': 'HasFood',
        'subtitle': TTexts.foodAvailableDesc,
      },
      {
        'icon': Icons.wifi,
        'title': TTexts.wifiAvailable,
        'key': 'HasWifi',
        'subtitle': TTexts.wifiAvailableDesc,
      },
      {
        'icon': Icons.videocam,
        'title': TTexts.cctvAvailable,
        'key': 'HasCCTV',
        'subtitle': TTexts.cctvAvailableDesc,
      },
      {
        'icon': Icons.kitchen,
        'title': TTexts.fridgeAvailable,
        'key': 'HasFridge',
        'subtitle': TTexts.fridgeAvailableDesc,
      },
      {
        'icon': Icons.fingerprint,
        'title': TTexts.biometricAvailable,
        'key': 'HasBiometric',
        'subtitle': TTexts.biometricAvailableDesc,
      },
      {
        'icon': Icons.ac_unit,
        'title': TTexts.acAvailable,
        'key': 'HasAc',
        'subtitle': TTexts.acAvailableDesc,
      },
      {
        'icon': Icons.desk,
        'title': TTexts.studyTableAvailable,
        'key': 'HasStudyTable',
        'subtitle': TTexts.studyTableAvailableDesc,
      },
      {
        'icon': Icons.local_drink,
        'title': TTexts.waterCoolerAvailable,
        'key': 'HasWaterCooler',
        'subtitle': TTexts.waterCoolerAvailableDesc,
      },
    ].where((amenity) => hostel.toJson()[amenity['key']] == true).toList();
  }

  Widget _buildSwitchListTile(
    BuildContext context,
    IconData leadingIcon,
    String title,
    String key,
    String subtitle,
  ) {
    // print('Key: $key');
    // print('Value: ${hostel.toJson()[key]}');
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: TColors.primary,
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class HostelPricingTile extends StatelessWidget {
  const HostelPricingTile({
    super.key,
    required this.hostel,
  });

  final HostelModel hostel;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Text(
                'Starting from',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 4),
              Text(
                ' ₹${hostel.dummyPrice}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: TColors.primary.withOpacity(0.6),
                    ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Text(
                '₹${hostel.minPrice}',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
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
        ),
        Divider(
          thickness: 5,
          height: 30,
          color: dark
              ? const Color.fromARGB(255, 70, 71, 76)
              : const Color.fromARGB(255, 240, 240, 240),
        ),
      ],
    );
  }
}

class CustomHostelTile extends StatelessWidget {
  final HostelModel hostel;

  CustomHostelTile({Key? key, required this.hostel}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              hostel.name,
              style: Theme.of(context).textTheme.headlineMedium!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Row(
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
          ),
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
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  hostel.type,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: dark ? Colors.white : Colors.black,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
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
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  hostel.gender,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: dark ? Colors.white : Colors.black,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CarouselIndicator extends StatelessWidget {
  const CarouselIndicator({
    super.key,
    required this.widget,
    required int current,
  }) : _current = current;

  final HostelDetailsScreen widget;
  final int _current;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.0,
      left: 0.0,
      right: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.hostel.imageSliderUrls.asMap().entries.map((entry) {
          return Container(
            width: 12.0,
            height: 12.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (_current == entry.key
                  ? TColors.primary
                  : TColors.white.withOpacity(0.4)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TopBarAnimated extends StatelessWidget {
  const TopBarAnimated({
    super.key,
    required double opacity,
    required this.widget,
  }) : _opacity = opacity;

  final double _opacity;
  final HostelDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        child: Container(
          // color: Colors.white
          //     .withOpacity(_opacity), // White background with opacity
          decoration: BoxDecoration(
            color: TColors.primary.withOpacity(_opacity),
          ),
          child: SafeArea(
            child: ListTile(
              leading: SizedBox(
                width: 40,
                height: 40,
                child: Container(
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Iconsax.arrow_left,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
              title: (_opacity == 1.0)
                  ? Text(
                      widget.hostel.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

// ListTile(
//                             title: Text('Call'),
//                             trailing: IconButton(
//                                 icon: Icon(Icons.call),
//                                 onPressed: () => launch('tel:7209390860'))),
//                         ListTile(
//                             title: Text('Full Address'),
//                             subtitle: Text(widget.hostel.fullAddress)),
//                         ListTile(
//                             title: Text('Google Maps Link'),
//                             trailing: IconButton(
//                                 icon: Icon(Icons.map),
//                                 onPressed: () => launchUrl(Uri.parse(
//                                     widget.hostel.googleAddressLink)))),
//                         ListTile(
//                             title: Text('Price'),
//                             subtitle: Text(widget
//                                 .hostel.hostelVariations.first.finalPrice
//                                 .toString())),
//                         ListTile(
//                             title: Text('Locality'),
//                             subtitle: Text(widget.hostel.locality)),
//                         ListTile(
//                             title: Text('Nearby Institute/College'),
//                             subtitle: Text(widget.hostel.instituteName)),
//                         ListTile(
//                             title: Text('Gender'),
//                             subtitle: Text(widget.hostel.gender)),
//                         ListTile(
//                             title: Text('Food'),
//                             subtitle: Text(widget.hostel.hasFood
//                                 ? "Available"
//                                 : "Not Available")),
//                         ListTile(
//                             title: Text('WiFi'),
//                             subtitle: Text(widget.hostel.hasWifi
//                                 ? "Available"
//                                 : "Not Available")),
//                         ListTile(
//                             title: Text('CCTV'),
//                             subtitle: Text(widget.hostel.hasCCTV
//                                 ? "Available"
//                                 : "Not Available")),
//                         ListTile(
//                             title: Text('Fridge'),
//                             subtitle: Text(widget.hostel.hasFridge
//                                 ? "Available"
//                                 : "Not Available")),
//                         ListTile(
//                             title: Text('Biometric Access'),
//                             subtitle: Text(widget.hostel.hasBiometric
//                                 ? "Available"
//                                 : "Not Available")),
//                         ListTile(
//                             title: Text('AC'),
//                             subtitle: Text(widget.hostel.hasAc
//                                 ? "Available"
//                                 : "Not Available")),
//                         ListTile(
//                             title: Text('Study Table'),
//                             subtitle: Text(widget.hostel.hasStudyTable
//                                 ? "Available"
//                                 : "Not Available")),
//                         ListTile(
//                             title: Text('Water Cooler'),
//                             subtitle: Text(widget.hostel.hasWaterCooler
//                                 ? "Available"
//                                 : "Not Available")),
