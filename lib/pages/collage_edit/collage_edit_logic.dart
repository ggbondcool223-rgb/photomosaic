import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/logger.dart';
import '../../components/image_picker_widget.dart';
import '../../db_photo_mosaic/db_photo_mosaic_helper.dart';
import '../../db_photo_mosaic/db_photo_mosaic_entity.dart';
import '../../utils/image_processor.dart';
import '../../utils/file_util.dart';
import '../../lang/lang.dart';

class ImageSlot {
  final String? imagePath;
  final bool isEmpty;
  final double x;
  final double y;
  final double width;
  final double height;

  ImageSlot({
    this.imagePath,
    this.x = 0,
    this.y = 0,
    this.width = 0.5,
    this.height = 0.5,
  }) : isEmpty = imagePath == null;
}

class CollageEditLogic extends GetxController {
  final imageSlots = <ImageSlot>[].obs;
  int? templateId;
  TemplateEntity? currentTemplate;
  final isLoading = false.obs;
  final backgroundColor = Colors.white.obs;
  final frameSpacing = 8.0.obs;
  final frameRadius = 4.0.obs;
  final selectedSlotIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['templateId'] != null) {
      templateId = args['templateId'];
    }
    _loadTemplate();
    Logger.d('CollageEditLogic initialized with templateId: $templateId');
  }

  Future<void> _loadTemplate() async {
    if (templateId == null) {
      _initDefaultSlots();
      return;
    }

    try {
      isLoading.value = true;
      final helper = DbPhotoMosaicHelper();
      final templates = await helper.getAllTemplates();
      currentTemplate = templates.firstWhere((t) => t.id == templateId);
      
      if (currentTemplate != null) {
        _parseLayoutData(currentTemplate!.layoutData);
      } else {
        _initDefaultSlots();
      }
    } catch (e) {
      Logger.e('Failed to load template', e);
      _initDefaultSlots();
    } finally {
      isLoading.value = false;
    }
  }

  void _parseLayoutData(String layoutDataJson) {
    try {
      final layoutData = json.decode(layoutDataJson) as Map<String, dynamic>;
      final slots = layoutData['slots'] as List<dynamic>?;
      
      if (slots != null && slots.isNotEmpty) {
        imageSlots.value = slots.map((slot) {
          return ImageSlot(
            x: (slot['x'] as num).toDouble(),
            y: (slot['y'] as num).toDouble(),
            width: (slot['width'] as num).toDouble(),
            height: (slot['height'] as num).toDouble(),
          );
        }).toList();
      } else {
        _initDefaultSlots();
      }
    } catch (e) {
      Logger.e('Failed to parse layout data', e);
      _initDefaultSlots();
    }
  }

  void _initDefaultSlots() {
    imageSlots.value = [
      ImageSlot(x: 0, y: 0, width: 0.5, height: 1),
      ImageSlot(x: 0.5, y: 0, width: 0.5, height: 1),
    ];
  }

  Future<void> selectImageSlot(int index) async {
    if (index < 0 || index >= imageSlots.length) return;
    
    selectedSlotIndex.value = index;
    final imagePath = await ImagePickerWidget.pickImage();
    if (imagePath != null) {
      imageSlots[index] = ImageSlot(
        imagePath: imagePath,
        x: imageSlots[index].x,
        y: imageSlots[index].y,
        width: imageSlots[index].width,
        height: imageSlots[index].height,
      );
      Logger.d('Image selected for slot $index: $imagePath');
    }
  }

  void deleteImageSlot(int index) {
    if (index < 0 || index >= imageSlots.length) return;
    
    final slot = imageSlots[index];
    imageSlots[index] = ImageSlot(
      x: slot.x,
      y: slot.y,
      width: slot.width,
      height: slot.height,
    );
    Logger.d('Image deleted from slot $index');
  }

  void replaceImageSlot(int index) {
    selectImageSlot(index);
  }

  Future<void> switchLayout() async {
    try {
      final helper = DbPhotoMosaicHelper();
      final templates = await helper.getAllTemplates();
      final templateTemplates = templates.where((t) => t.type == 'template').toList();
      
      if (templateTemplates.isEmpty) {
        Logger.d('No templates available');
        return;
      }

      final currentIndex = templateTemplates.indexWhere((t) => t.id == templateId);
      final nextIndex = (currentIndex + 1) % templateTemplates.length;
      final nextTemplate = templateTemplates[nextIndex];
      
      templateId = nextTemplate.id;
      currentTemplate = nextTemplate;
      _parseLayoutData(nextTemplate.layoutData);
      
      for (var i = 0; i < imageSlots.length; i++) {
        if (!imageSlots[i].isEmpty) {
          final oldSlot = imageSlots[i];
          imageSlots[i] = ImageSlot(
            imagePath: oldSlot.imagePath,
            x: oldSlot.x,
            y: oldSlot.y,
            width: oldSlot.width,
            height: oldSlot.height,
          );
        }
      }
      
      Logger.d('Layout switched to template: ${nextTemplate.id}');
    } catch (e) {
      Logger.e('Failed to switch layout', e);
    }
  }

  Future<void> saveWork() async {
    if (isLoading.value) {
      Logger.d('Save already in progress');
      return;
    }

    try {
      isLoading.value = true;
      
      final filledSlots = imageSlots.where((slot) => !slot.isEmpty).toList();
      if (filledSlots.isEmpty) {
        Logger.d('No images to save');
        Get.snackbar('', Lang.collageEditNoImages);
        isLoading.value = false;
        return;
      }

      final layout = <Map<String, dynamic>>[];
      final imagePaths = <String>[];
      
      for (var slot in imageSlots) {
        if (!slot.isEmpty && slot.imagePath != null) {
          layout.add({
            'x': slot.x,
            'y': slot.y,
            'width': slot.width,
            'height': slot.height,
          });
          imagePaths.add(slot.imagePath!);
        }
      }

      if (imagePaths.isEmpty) {
        Logger.d('No images to save');
        Get.snackbar('', Lang.collageEditNoImages);
        isLoading.value = false;
        return;
      }

      Logger.d('Starting to combine ${imagePaths.length} images');
      final combinedPath = await ImageProcessor.combineImages(imagePaths, layout);
      if (combinedPath == null) {
        Logger.e('Failed to combine images');
        Get.snackbar('', Lang.collageEditSaveFailed);
        isLoading.value = false;
        return;
      }

      Logger.d('Images combined, saving to gallery: $combinedPath');
      final savedPath = await FileUtil.saveImageToGallery(combinedPath);
      if (savedPath == null) {
        Logger.e('Failed to save image');
        Get.snackbar('', Lang.collageEditSaveFailed);
        isLoading.value = false;
        return;
      }

      Logger.d('Image saved, inserting to database: $savedPath');
      final helper = DbPhotoMosaicHelper();
      final now = DateTime.now().toIso8601String();
      final work = WorkEntity(
        name: 'Puzzle_works_${DateTime.now().millisecondsSinceEpoch}',
        thumbnailPath: savedPath,
        imagePath: savedPath,
        templateId: templateId,
        createdAt: now,
        updatedAt: now,
      );

      await helper.insertWork(work);
      Logger.d('Work saved successfully: ${work.name}');
      
      Get.snackbar('', Lang.collageEditSaveSuccess);
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back();
      Get.toNamed(
        '/image_preview',
        arguments: {
          'imagePath': savedPath,
        },
      );
    } catch (e, stackTrace) {
      Logger.e('Failed to save work', e, stackTrace);
      Get.snackbar('', Lang.collageEditSaveFailed);
    } finally {
      isLoading.value = false;
    }
  }

  void goToFrameAdjust() {
    Get.toNamed('/frame_adjust', arguments: {
      'spacing': frameSpacing.value,
      'radius': frameRadius.value,
    })?.then((result) {
      if (result != null && result is Map) {
        if (result['spacing'] != null) {
          frameSpacing.value = result['spacing'] as double;
        }
        if (result['radius'] != null) {
          frameRadius.value = result['radius'] as double;
        }
      }
    });
  }

  void goToBackgroundSelect() {
    Get.toNamed('/background_select')?.then((result) {
      if (result != null && result is Map) {
        if (result['type'] == 'color' && result['color'] != null) {
          backgroundColor.value = result['color'] as Color;
          Logger.d('Background color changed: ${backgroundColor.value}');
        } else if (result['type'] == 'background' && result['id'] != null) {
          Logger.d('Background selected: ${result['id']}');
        }
      }
    });
  }

  void goToTextEdit() {
    Get.toNamed('/text_edit');
  }

  void toggleFavorite() {
    Logger.d('Toggle favorite');
  }
}
