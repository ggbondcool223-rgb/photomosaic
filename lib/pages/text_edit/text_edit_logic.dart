import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/logger.dart';

class TextEditLogic extends GetxController {
  final text = ''.obs;
  final selectedFont = '默认'.obs;
  final selectedColor = Colors.white.obs;
  final fonts = ['默认', '粗体', '斜体', '等宽'];
  final colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];

  @override
  void onInit() {
    super.onInit();
    Logger.d('TextEditLogic initialized');
  }

  void save() {
    Logger.d('Save text: ${text.value}');
    Get.back(result: {
      'text': text.value,
      'font': selectedFont.value,
      'color': selectedColor.value,
    });
  }
}
