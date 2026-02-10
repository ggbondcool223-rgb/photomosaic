import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_photo_mosaic/db_photo_mosaic_helper.dart';
import '../../db_photo_mosaic/db_photo_mosaic_entity.dart';
import '../../utils/logger.dart';

class BackgroundSelectLogic extends GetxController {
  final selectedType = 'color'.obs;
  final backgrounds = <BackgroundEntity>[].obs;
  final colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  @override
  void onInit() {
    super.onInit();
    loadBackgrounds('color');
  }

  Future<void> loadBackgrounds(String type) async {
    try {
      final helper = DbPhotoMosaicHelper();
      final items = await helper.getBackgroundsByType(type);
      backgrounds.value = items;
      Logger.d('Loaded ${items.length} backgrounds for type: $type');
    } catch (e) {
      Logger.e('Failed to load backgrounds', e);
    }
  }

  void selectType(String type) {
    selectedType.value = type;
    loadBackgrounds(type);
  }

  void selectColor(Color color) {
    Logger.d('Selected color: $color');
    Get.back(result: {'type': 'color', 'color': color});
  }

  void selectBackground(int id) {
    Logger.d('Selected background: $id');
    Get.back(result: {'type': 'background', 'id': id});
  }
}
