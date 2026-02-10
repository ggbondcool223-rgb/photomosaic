import 'package:get/get.dart';
import '../../db_photo_mosaic/db_photo_mosaic_helper.dart';
import '../../db_photo_mosaic/db_photo_mosaic_entity.dart';
import '../../utils/logger.dart';

class FilterItem {
  final FilterEntity entity;
  final RxDouble intensity;

  FilterItem({required this.entity}) : intensity = RxDouble(entity.intensity);
}

class FilterListLogic extends GetxController {
  final filters = <FilterItem>[].obs;
  final selectedIntensity = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadFilters();
  }

  Future<void> loadFilters() async {
    try {
      final helper = DbPhotoMosaicHelper();
      final filterEntities = await helper.getAllFilters();
      filters.value = filterEntities.map((e) => FilterItem(entity: e)).toList();
      Logger.d('Loaded ${filterEntities.length} filters');
    } catch (e) {
      Logger.e('Failed to load filters', e);
    }
  }
}
