import 'package:get/get.dart';
import '../../utils/logger.dart';
import '../../utils/permission_util.dart';
import '../../components/image_picker_widget.dart';

class ImageEditLogic extends GetxController {
  final imagePath = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initPermission();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['imagePath'] != null) {
      imagePath.value = arguments['imagePath'] as String;
      Logger.d('Image path from arguments: ${imagePath.value}');
    } else {
      _autoSelectImage();
    }
    Logger.d('ImageEditLogic initialized');
  }

  Future<void> _initPermission() async {
    await PermissionUtil.checkPermission();
  }

  Future<void> _autoSelectImage() async {
    Logger.d('Auto select image from gallery');
    isLoading.value = true;
    try {
      final path = await ImagePickerWidget.pickImage();
      if (path != null) {
        imagePath.value = path;
        Logger.d('Image selected: $path');
      } else {
        Logger.d('No image selected, user cancelled');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectImage() async {
    Logger.d('Select image');
    isLoading.value = true;
    try {
      final path = await ImagePickerWidget.pickImage();
      if (path != null) {
        imagePath.value = path;
        Logger.d('Image selected: $path');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void save() {
    Logger.d('Save edited image');
  }
}
