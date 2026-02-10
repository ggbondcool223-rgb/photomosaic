import 'package:get/get.dart';
import 'frame_adjust_logic.dart';

class FrameAdjustBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrameAdjustLogic());
  }
}
