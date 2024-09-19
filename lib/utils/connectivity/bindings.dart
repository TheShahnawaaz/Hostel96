import 'package:get/get.dart';
import 'package:second/utils/connectivity/connectivity.dart';

class GeneralBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}
