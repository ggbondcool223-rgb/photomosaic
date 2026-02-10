import 'package:get/get.dart';
import '../../db_photo_mosaic/db_photo_mosaic_helper.dart';
import '../../db_photo_mosaic/db_photo_mosaic_entity.dart';
import '../../utils/logger.dart';

class StickerListLogic extends GetxController {
  final categories = <String>[].obs;
  final stickers = <StickerEntity>[].obs;
  final selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final helper = DbPhotoMosaicHelper();
      final cats = await helper.getStickerCategories();
      categories.value = cats;
      if (cats.isNotEmpty) {
        selectedCategory.value = cats.first;
        loadStickers(cats.first);
      }
      Logger.d('Loaded ${cats.length} sticker categories');
    } catch (e) {
      Logger.e('Failed to load sticker categories', e);
    }
  }

  Future<void> loadStickers(String category) async {
    try {
      final helper = DbPhotoMosaicHelper();
      final items = await helper.getStickersByCategory(category);
      stickers.value = items;
      Logger.d('Loaded ${items.length} stickers for category: $category');
    } catch (e) {
      Logger.e('Failed to load stickers', e);
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    loadStickers(category);
  }

  void selectSticker(int stickerId) {
    Logger.d('Selected sticker: $stickerId');
    Get.back(result: {'stickerId': stickerId});
  }
}
