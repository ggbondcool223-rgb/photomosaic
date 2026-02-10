import 'package:get/get.dart';
import 'collage_edit_logic.dart';

class CollageEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CollageEditLogic());
  }
}
