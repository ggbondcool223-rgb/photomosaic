import 'package:get/get.dart';
import '../../utils/logger.dart';

class PosterCollageLogic extends GetxController {
  final images = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    Logger.d('PosterCollageLogic initialized');
  }

  void addImage() {
    Logger.d('Add image to poster collage');
  }

  void save() {
    Logger.d('Save poster collage');
  }
}
