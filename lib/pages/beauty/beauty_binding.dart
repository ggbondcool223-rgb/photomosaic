import 'package:get/get.dart';
import 'beauty_logic.dart';

class BeautyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BeautyLogic());
  }
}
