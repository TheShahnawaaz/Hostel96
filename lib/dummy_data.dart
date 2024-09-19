import 'package:second/models/banner_model.dart';
import 'package:second/utils/constants/image_strings.dart';

class MyDummyData {
  static final List<BannerModel> banners = [
    BannerModel(
      imageUrl: TImages.banner1,
      targetScreen: '/city-list',
      isExternalLink: false,
      externalLink: '',
      isActive: true,
      name: 'Zero Brokerage',
      order: 1,
      inMain: true,
    ),
    BannerModel(
      imageUrl: TImages.banner2,
      targetScreen: '/city-list',
      isExternalLink: false,
      externalLink: '',
      isActive: true,
      name: 'Promote your Hostel',
      inMain: true,
      order: 2,
    ),
    BannerModel(
      imageUrl: TImages.banner3,
      targetScreen: '/city-list',
      isExternalLink: false,
      externalLink: '',
      isActive: true,
      name: 'Find your Hostel',
      order: 3,
      inMain: true,
    ),
  ];
}
