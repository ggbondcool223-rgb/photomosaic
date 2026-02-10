import 'package:get/get.dart';
import 'background_select_logic.dart';

class BackgroundSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BackgroundSelectLogic());
  }
}
