import 'package:get/get.dart';
import 'long_collage_logic.dart';

class LongCollageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LongCollageLogic());
  }
}
