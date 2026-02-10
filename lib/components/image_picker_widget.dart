import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../utils/logger.dart';
import '../utils/permission_util.dart';
import '../lang/lang.dart';

class ImagePickerWidget {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImage({bool allowMultiple = false}) async {
    try {
      await PermissionUtil.checkPermission();
      if (!PermissionUtil.isGranted) {
        await PermissionUtil.requestPermission();
        if (!PermissionUtil.isGranted) {
          Logger.d('Permission not granted, cannot pick image');
          return null;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        Logger.d('Image picked: ${image.path}');
        return image.path;
      }
      return null;
    } catch (e) {
      Logger.e('Failed to pick image', e);
      return null;
    }
  }

  static Future<String?> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (image != null) {
        Logger.d('Photo taken: ${image.path}');
        return image.path;
      }
      return null;
    } catch (e) {
      Logger.e('Failed to take photo', e);
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('permission') || errorMessage.contains('denied')) {
        Get.snackbar('', Lang.cameraPermissionDenied);
      } else if (errorMessage.contains('camera') || errorMessage.contains('not available')) {
        Get.snackbar('', Lang.cameraNotAvailable);
      } else {
        Get.snackbar('', Lang.cameraTakePhotoFailed);
      }
      return null;
    }
  }

  static Future<List<String>> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      final paths = images.map((img) => img.path).toList();
      Logger.d('Picked ${paths.length} images');
      return paths;
    } catch (e) {
      Logger.e('Failed to pick multiple images', e);
      return [];
    }
  }
}
