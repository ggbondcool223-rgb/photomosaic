import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_photo_mosaic/db_photo_mosaic_helper.dart';
import '../../db_photo_mosaic/db_photo_mosaic_entity.dart';
import '../../utils/logger.dart';
import '../../lang/lang.dart';

class AlbumLogic extends GetxController {
  final works = <WorkEntity>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWorks();
  }

  Future<void> loadWorks() async {
    isLoading.value = true;
    try {
      final helper = DbPhotoMosaicHelper();
      final items = await helper.getAllWorks();
      works.value = items;
      Logger.d('Loaded ${items.length} works');
    } catch (e) {
      Logger.e('Failed to load works', e);
    } finally {
      isLoading.value = false;
    }
  }

  void previewWork(int id) {
    Logger.d('Preview work: $id');
    final work = works.firstWhere((w) => w.id == id);
    if (work.imagePath.isNotEmpty && File(work.imagePath).existsSync()) {
      Logger.d('Preview image: ${work.imagePath}');
      Get.toNamed(
        '/image_preview',
        arguments: {
          'imagePath': work.imagePath,
          'onDelete': () => deleteWork(id),
        },
      );
    } else {
      Get.snackbar('', Lang.imagePreviewError);
    }
  }

  void showDeleteDialog(int id) {
    Get.dialog(
      AlertDialog(
        title: Text(Lang.commonDelete),
        content: Text(Lang.myWorksDelete),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(Lang.commonCancel),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await deleteWork(id);
            },
            child: Text(Lang.commonConfirm),
          ),
        ],
      ),
    );
  }

  Future<void> deleteWork(int id) async {
    try {
      final helper = DbPhotoMosaicHelper();
      await helper.deleteWork(id);
      await loadWorks();
      Logger.d('Work deleted: $id');
    } catch (e) {
      Logger.e('Failed to delete work', e);
    }
  }
}
