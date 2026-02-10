import 'package:get/get.dart';
import '../../utils/logger.dart';
import '../../components/image_picker_widget.dart';

class LongCollageLogic extends GetxController {
  final images = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    Logger.d('LongCollageLogic initialized');
  }

  Future<void> addImage() async {
    Logger.d('Add image to long collage');
    final imagePath = await ImagePickerWidget.pickImage();
    if (imagePath != null) {
      images.add(imagePath);
      Logger.d('Image added: $imagePath');
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      Logger.d('Image removed at index: $index');
    }
  }

  void save() {
    Logger.d('Save long collage');
  }
}
