import 'package:get/get.dart';
import 'poster_collage_logic.dart';

class PosterCollageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PosterCollageLogic());
  }
}
