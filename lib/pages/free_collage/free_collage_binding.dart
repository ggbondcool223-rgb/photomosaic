import 'package:get/get.dart';
import 'free_collage_logic.dart';

class FreeCollageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FreeCollageLogic());
  }
}
