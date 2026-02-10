import 'package:get/get.dart';
import 'image_preview_logic.dart';

class ImagePreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ImagePreviewLogic());
  }
}
