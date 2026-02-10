import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../lang/lang.dart';
import '../../utils/logger.dart';
import '../../components/image_picker_widget.dart';

class HomeLogic extends GetxController {
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': Lang.homeAlbum,
      'icon': Icons.photo_library,
      'color': const Color(0xFF0080FF),
      'route': '/album',
    },
    {
      'title': Lang.homeCollage,
      'icon': Icons.grid_view,
      'color': const Color(0xFFBF00FF),
      'route': '/template_select',
    },
    {
      'title': Lang.homeCamera,
      'icon': Icons.camera_alt,
      'color': const Color(0xFFFF1493),
      'route': 'camera',
    },
    {
      'title': Lang.homeBeauty,
      'icon': Icons.face,
      'color': const Color(0xFF00FFFF),
      'route': '/beauty',
    },
  ];

  void onMenuTap(int index) async {
    final item = menuItems[index];
    final route = item['route'] as String;
    Logger.d('Navigate to: $route');
    
    if (route == 'camera') {
      await _openCameraAndEdit();
    } else {
      Get.toNamed(route);
    }
  }

  Future<void> _openCameraAndEdit() async {
    Logger.d('Open camera to take photo');
    final imagePath = await ImagePickerWidget.takePhoto();
    if (imagePath != null) {
      Get.toNamed(
        '/image_edit',
        arguments: {'imagePath': imagePath},
      );
    } else {
      Logger.d('No photo taken, user cancelled');
    }
  }

  void onSettingsTap() {
    Logger.d('Navigate to settings');
    Get.toNamed('/settings');
  }

  @override
  void onInit() {
    super.onInit();
    Logger.d('HomeLogic initialized');
  }
}
