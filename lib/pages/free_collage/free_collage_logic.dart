import 'package:get/get.dart';
import '../../utils/logger.dart';
import '../../components/image_picker_widget.dart';

class FreeCollageLogic extends GetxController {
  final images = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    Logger.d('FreeCollageLogic initialized');
  }

  Future<void> addImage() async {
    Logger.d('Add image');
    final imagePath = await ImagePickerWidget.pickImage();
    if (imagePath != null) {
      images.add({
        'path': imagePath,
        'x': 0.1,
        'y': 0.1,
        'width': 0.3,
        'height': 0.3,
      });
    }
  }

  void updateImagePosition(int index, double dx, double dy) {
    if (index >= 0 && index < images.length) {
      final updatedImages = List<Map<String, dynamic>>.from(images);
      final image = Map<String, dynamic>.from(updatedImages[index]);
      image['x'] = ((image['x'] as num).toDouble() + dx).clamp(0.0, 1.0);
      image['y'] = ((image['y'] as num).toDouble() + dy).clamp(0.0, 1.0);
      updatedImages[index] = image;
      images.value = updatedImages;
    }
  }

  void save() {
    Logger.d('Save free collage');
  }
}
