import 'package:get/get.dart';
import 'image_edit_logic.dart';

class ImageEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ImageEditLogic());
  }
}
