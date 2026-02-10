import 'package:get/get.dart';
import 'sticker_list_logic.dart';

class StickerListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StickerListLogic());
  }
}
