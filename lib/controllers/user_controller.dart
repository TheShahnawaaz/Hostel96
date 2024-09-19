import 'package:get/get.dart';
import 'package:second/models/user_model.dart';
import 'package:second/repositories/user_repository.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());
  final isProfileLoading = false.obs;

  @override
  void onInit() {
    fetchUserDetails();
    super.onInit();
  }

  Future<void> fetchUserDetails() async {
    try {
      isProfileLoading(true);
      user.value = await userRepository.fetchUserDetails();
    } catch (e) {
      user(UserModel.empty());
    } finally {
      isProfileLoading(false);
    }
  }

  Future<void> updateUserDetails(UserModel user) async {
    try {
      await userRepository.updateUserDetails(user);
    } catch (e) {
      print(e);
    }
  }
}
