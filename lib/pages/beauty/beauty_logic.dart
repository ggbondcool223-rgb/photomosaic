import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/logger.dart';
import '../../utils/permission_util.dart';
import '../../components/image_picker_widget.dart';
import '../../utils/image_processor.dart';
import '../../utils/file_util.dart';
import '../../lang/lang.dart';

class BeautyLogic extends GetxController {
  final imagePath = ''.obs;
  final isLoading = false.obs;
  final smoothValue = 0.0.obs;
  final whitenValue = 0.0.obs;
  final slimFaceValue = 0.0.obs;
  final bigEyesValue = 0.0.obs;
  final brightEyesValue = 0.0.obs;
  final whitenTeethValue = 0.0.obs;
  String? originalImagePath;
  final GlobalKey imagePreviewKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    _initPermission();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['imagePath'] != null) {
      imagePath.value = arguments['imagePath'] as String;
      originalImagePath = imagePath.value;
      Logger.d('BeautyLogic initialized with path: ${imagePath.value}');
    } else {
      _autoSelectImage();
    }
    Logger.d('BeautyLogic initialized');
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
        originalImagePath = path;
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
        originalImagePath = path;
        _resetAllValues();
        Logger.d('Image selected: $path');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _resetAllValues() {
    smoothValue.value = 0.0;
    whitenValue.value = 0.0;
    slimFaceValue.value = 0.0;
    bigEyesValue.value = 0.0;
    brightEyesValue.value = 0.0;
    whitenTeethValue.value = 0.0;
  }

  void showBeautySlider(String type) {
    if (imagePath.isEmpty) {
      Get.snackbar('', Lang.beautyNoImage);
      return;
    }

    String title = '';
    
    switch (type) {
      case 'smooth':
        title = Lang.beautySmooth;
        break;
      case 'whiten':
        title = Lang.beautyWhiten;
        break;
      case 'slimFace':
        title = Lang.beautySlimFace;
        break;
      case 'bigEyes':
        title = Lang.beautyBigEyes;
        break;
      case 'brightEyes':
        title = Lang.beautyBrightEyes;
        break;
      case 'whitenTeeth':
        title = Lang.beautyWhitenTeeth;
        break;
    }

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ScreenUtil().radius(20)),
            topRight: Radius.circular(ScreenUtil().radius(20)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Obx(() {
              double value = 0.0;
              switch (type) {
                case 'smooth':
                  value = smoothValue.value;
                  break;
                case 'whiten':
                  value = whitenValue.value;
                  break;
                case 'slimFace':
                  value = slimFaceValue.value;
                  break;
                case 'bigEyes':
                  value = bigEyesValue.value;
                  break;
                case 'brightEyes':
                  value = brightEyesValue.value;
                  break;
                case 'whitenTeeth':
                  value = whitenTeethValue.value;
                  break;
              }
              return Column(
                children: [
                  Slider(
                    value: value,
                    min: 0.0,
                    max: 100.0,
                    divisions: 100,
                    label: value.toStringAsFixed(0),
                    onChanged: (newValue) {
                      _updateBeautyValue(type, newValue);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        value.toStringAsFixed(0),
                        style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(16)),
                      ),
                      Text(
                        '100',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              );
            }),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    _resetBeautyValue(type);
                    Get.back();
                  },
                  child: Text(
                    Lang.commonCancel,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _applyBeauty(type);
                    Get.back();
                  },
                  child: Text(
                    Lang.commonConfirm,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _updateBeautyValue(String type, double value) {
    switch (type) {
      case 'smooth':
        smoothValue.value = value;
        break;
      case 'whiten':
        whitenValue.value = value;
        break;
      case 'slimFace':
        slimFaceValue.value = value;
        break;
      case 'bigEyes':
        bigEyesValue.value = value;
        break;
      case 'brightEyes':
        brightEyesValue.value = value;
        break;
      case 'whitenTeeth':
        whitenTeethValue.value = value;
        break;
    }
  }

  void _resetBeautyValue(String type) {
    _updateBeautyValue(type, 0.0);
  }

  Future<void> _applyBeauty(String type) async {
    if (imagePath.isEmpty) return;

    isLoading.value = true;
    try {
      final sourcePath = originalImagePath ?? imagePath.value;
      final resultPath = await ImageProcessor.applyBeauty(
        sourcePath,
        type,
        _getBeautyValue(type),
      );

      if (resultPath != null) {
        imagePath.value = resultPath;
        Logger.d('Beauty applied: $type, value: ${_getBeautyValue(type)}');
      } else {
        Get.snackbar('', Lang.beautyApplyFailed);
      }
    } catch (e) {
      Logger.e('Failed to apply beauty', e);
      Get.snackbar('', Lang.beautyApplyFailed);
    } finally {
      isLoading.value = false;
    }
  }

  double _getBeautyValue(String type) {
    switch (type) {
      case 'smooth':
        return smoothValue.value;
      case 'whiten':
        return whitenValue.value;
      case 'slimFace':
        return slimFaceValue.value;
      case 'bigEyes':
        return bigEyesValue.value;
      case 'brightEyes':
        return brightEyesValue.value;
      case 'whitenTeeth':
        return whitenTeethValue.value;
      default:
        return 0.0;
    }
  }

  Future<void> save() async {
    Logger.d('Save beauty image');
    if (imagePath.isEmpty) {
      Get.snackbar('', Lang.beautyNoImage);
      return;
    }

    isLoading.value = true;
    try {
      final screenshotPath = await _captureScreenshot();
      if (screenshotPath != null) {
        final savedPath = await FileUtil.saveImageToGallery(screenshotPath);
        if (savedPath != null) {
          Get.snackbar('', Lang.beautySaveSuccess);
          Logger.d('Beauty image saved: $savedPath');
        } else {
          Get.snackbar('', Lang.beautySaveFailed);
        }
      } else {
        final savedPath = await FileUtil.saveImageToGallery(imagePath.value);
        if (savedPath != null) {
          Get.snackbar('', Lang.beautySaveSuccess);
          Logger.d('Beauty image saved: $savedPath');
        } else {
          Get.snackbar('', Lang.beautySaveFailed);
        }
      }
    } catch (e) {
      Logger.e('Failed to save beauty image', e);
      Get.snackbar('', Lang.beautySaveFailed);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _captureScreenshot() async {
    try {
      final RenderRepaintBoundary boundary = imagePreviewKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        Logger.e('Failed to capture screenshot');
        return null;
      }

      final directory = await getApplicationDocumentsDirectory();
      final screenshotPath = '${directory.path}/beauty_screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(screenshotPath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      Logger.d('Screenshot captured: $screenshotPath');
      return screenshotPath;
    } catch (e) {
      Logger.e('Failed to capture screenshot', e);
      return null;
    }
  }
}
