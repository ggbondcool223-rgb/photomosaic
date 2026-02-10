import 'package:get/get.dart';
import '../../db_photo_mosaic/db_photo_mosaic_helper.dart';
import '../../db_photo_mosaic/db_photo_mosaic_entity.dart';
import '../../utils/logger.dart';

class MyWorksLogic extends GetxController {
  final works = <WorkEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWorks();
  }

  Future<void> loadWorks() async {
    try {
      final helper = DbPhotoMosaicHelper();
      final items = await helper.getAllWorks();
      works.value = items;
      Logger.d('Loaded ${items.length} works');
    } catch (e) {
      Logger.e('Failed to load works', e);
    }
  }

  void previewWork(int id) {
    Logger.d('Preview work: $id');
  }

  void showDeleteDialog(int id) {
    Logger.d('Show delete dialog for work: $id');
  }
}
