import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/logger.dart';
import '../../lang/lang.dart';

class ImagePreviewLogic extends GetxController {
  final imagePath = ''.obs;
  final onDeleteCallback = Get.arguments?['onDelete'];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['imagePath'] != null) {
      imagePath.value = args['imagePath'] as String;
      Logger.d('ImagePreviewLogic initialized with path: ${imagePath.value}');
    } else {
      Logger.d('ImagePreviewLogic initialized without image path');
    }
  }

  void showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(Lang.commonDelete),
        content: Text(Lang.imagePreviewDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(Lang.commonCancel),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if (onDeleteCallback != null) {
                onDeleteCallback();
              }
              Get.back();
            },
            child: Text(Lang.commonConfirm),
          ),
        ],
      ),
    );
  }
}
