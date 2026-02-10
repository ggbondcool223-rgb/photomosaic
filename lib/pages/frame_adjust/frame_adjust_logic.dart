import 'package:get/get.dart';
import '../../utils/logger.dart';

class FrameAdjustLogic extends GetxController {
  final selectedStyle = 'Borderless'.obs;
  final spacing = 8.0.obs;
  final radius = 0.0.obs;
  final styles = ['Borderless', 'Thin bezel', 'Thick border', 'Rounded corner border'];

  @override
  void onInit() {
    super.onInit();
    Logger.d('FrameAdjustLogic initialized');
  }
}
