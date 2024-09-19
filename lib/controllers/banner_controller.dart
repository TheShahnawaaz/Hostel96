import 'package:get/get.dart';
import 'package:second/dummy_data.dart';
import 'package:second/models/banner_model.dart';
import 'package:second/repositories/banner_repository.dart';
import 'package:second/utils/connectivity/connectivity.dart';
import 'package:second/widgets/widgets.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();

  final carouselCurrentIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final bannerRepo = Get.put(BannerRepository());

  final isLoadingLargeBanner = true.obs;
  Rx<HomeImageModel>? largeBanner;

  final isLoadingFooterBanner = true.obs;
  Rx<HomeImageModel>? footerBanner;

  void updateCarouselIndex(int index) {
    carouselCurrentIndex.value = index;
  }

  @override
  void onInit() {
    fetchBanners();
    fetchLargeBanner();
    fetchFooterBanner();
    super.onInit();
  }

  // @override
  // void onReady() {
  //   bannerRepo.uploadDummyData(MyDummyData.banners);
  //   fetchBanners();
  //   super.onReady();
  // }

  Future<void> fetchLargeBanner() async {
    try {
      isLoadingLargeBanner.value = true;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackbar(
            title: "No internet connection!",
            message: "Please check your internet connection and try again.");
        return;
      }

      final banner = await bannerRepo.fetchLargeBanner();
      largeBanner = banner.obs;
    } catch (e) {
      TLoaders.errorSnackbar(
          title: "Couldn't fetch large banner", message: e.toString());
    } finally {
      isLoadingLargeBanner.value = false;
    }
  }

  Future<void> fetchFooterBanner() async {
    try {
      isLoadingFooterBanner.value = true;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackbar(
            title: "No internet connection!",
            message: "Please check your internet connection and try again.");
        return;
      }

      final banner = await bannerRepo.fetchFooterBanner();
      footerBanner = banner.obs;
      print(footerBanner!.value.imageUrl);
    } catch (e) {
      TLoaders.errorSnackbar(
          title: "Couldn't fetch footer banner", message: e.toString());
    } finally {
      isLoadingFooterBanner.value = false;
    }
  }

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // TFullScreenLoader.closeLoadingDialog();
        TLoaders.warningSnackbar(
            title: "No internet connection!",
            message: "Please check your internet connection and try again.");
        return;
      }

      final bannerList = await bannerRepo.fetchBanners();

      // this.banners.assignAll(bannerList);
      // Assign only those where inMain is true
      this.banners.assignAll(bannerList.where((element) => element.inMain));
    } catch (e) {
      TLoaders.errorSnackbar(
          title: "Couldn't fetch banners", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
