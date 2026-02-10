import 'db_photo_mosaic_helper.dart';
import 'db_photo_mosaic_entity.dart';
import '../utils/logger.dart';

class DbPhotoMosaicData {
  static Future<void> initData() async {
    final helper = DbPhotoMosaicHelper();
    final templates = await helper.getAllTemplates();
    if (templates.isEmpty) {
      await _initTemplates(helper);
    }
    final filters = await helper.getAllFilters();
    if (filters.isEmpty) {
      await _initFilters(helper);
    }
    final stickers = await helper.getStickerCategories();
    if (stickers.isEmpty) {
      await _initStickers(helper);
    }
    Logger.i('Database data initialized');
  }

  static Future<void> _initTemplates(DbPhotoMosaicHelper helper) async {
    final defaultTemplates = [
      TemplateEntity(
        name: '单图',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":1,"height":1}]}',
        sortOrder: 1,
      ),
      TemplateEntity(
        name: '左右两分',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":1},{"x":0.5,"y":0,"width":0.5,"height":1}]}',
        sortOrder: 2,
      ),
      TemplateEntity(
        name: '上下两分',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":1,"height":0.5},{"x":0,"y":0.5,"width":1,"height":0.5}]}',
        sortOrder: 3,
      ),
      TemplateEntity(
        name: '四宫格',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":0.5},{"x":0.5,"y":0,"width":0.5,"height":0.5},{"x":0,"y":0.5,"width":0.5,"height":0.5},{"x":0.5,"y":0.5,"width":0.5,"height":0.5}]}',
        sortOrder: 4,
      ),
      TemplateEntity(
        name: '三列垂直',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.333,"height":1},{"x":0.333,"y":0,"width":0.333,"height":1},{"x":0.666,"y":0,"width":0.334,"height":1}]}',
        sortOrder: 5,
      ),
      TemplateEntity(
        name: '三行水平',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":1,"height":0.333},{"x":0,"y":0.333,"width":1,"height":0.333},{"x":0,"y":0.666,"width":1,"height":0.334}]}',
        sortOrder: 6,
      ),
      TemplateEntity(
        name: '左大右小',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":1},{"x":0.5,"y":0,"width":0.5,"height":0.5},{"x":0.5,"y":0.5,"width":0.5,"height":0.5}]}',
        sortOrder: 7,
      ),
      TemplateEntity(
        name: '上大下小',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":1,"height":0.5},{"x":0,"y":0.5,"width":0.5,"height":0.5},{"x":0.5,"y":0.5,"width":0.5,"height":0.5}]}',
        sortOrder: 8,
      ),
      TemplateEntity(
        name: '左小右大',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":0.5},{"x":0,"y":0.5,"width":0.5,"height":0.5},{"x":0.5,"y":0,"width":0.5,"height":1}]}',
        sortOrder: 9,
      ),
      TemplateEntity(
        name: '上小下大',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":0.5},{"x":0.5,"y":0,"width":0.5,"height":0.5},{"x":0,"y":0.5,"width":1,"height":0.5}]}',
        sortOrder: 10,
      ),
      TemplateEntity(
        name: '左大右三',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":1},{"x":0.5,"y":0,"width":0.5,"height":0.333},{"x":0.5,"y":0.333,"width":0.5,"height":0.333},{"x":0.5,"y":0.666,"width":0.5,"height":0.334}]}',
        sortOrder: 11,
      ),
      TemplateEntity(
        name: '上二下一',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":0.5},{"x":0.5,"y":0,"width":0.5,"height":0.5},{"x":0,"y":0.5,"width":1,"height":0.5}]}',
        sortOrder: 12,
      ),
      TemplateEntity(
        name: '四列垂直',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.25,"height":1},{"x":0.25,"y":0,"width":0.25,"height":1},{"x":0.5,"y":0,"width":0.25,"height":1},{"x":0.75,"y":0,"width":0.25,"height":1}]}',
        sortOrder: 13,
      ),
      TemplateEntity(
        name: '上一下二',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":1,"height":0.5},{"x":0,"y":0.5,"width":0.5,"height":0.5},{"x":0.5,"y":0.5,"width":0.5,"height":0.5}]}',
        sortOrder: 14,
      ),
      TemplateEntity(
        name: '左中右',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.333,"height":1},{"x":0.333,"y":0,"width":0.334,"height":0.5},{"x":0.333,"y":0.5,"width":0.334,"height":0.5},{"x":0.666,"y":0,"width":0.334,"height":1}]}',
        sortOrder: 15,
      ),
      TemplateEntity(
        name: '左二右一',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":0.5},{"x":0,"y":0.5,"width":0.5,"height":0.5},{"x":0.5,"y":0,"width":0.5,"height":1}]}',
        sortOrder: 16,
      ),
      TemplateEntity(
        name: '上三下一',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.333,"height":0.5},{"x":0.333,"y":0,"width":0.334,"height":0.5},{"x":0.666,"y":0,"width":0.334,"height":0.5},{"x":0,"y":0.5,"width":1,"height":0.5}]}',
        sortOrder: 17,
      ),
      TemplateEntity(
        name: '左一右二',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":1},{"x":0.5,"y":0,"width":0.5,"height":0.5},{"x":0.5,"y":0.5,"width":0.5,"height":0.5}]}',
        sortOrder: 18,
      ),
      TemplateEntity(
        name: '上一下三',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":1,"height":0.5},{"x":0,"y":0.5,"width":0.333,"height":0.5},{"x":0.333,"y":0.5,"width":0.334,"height":0.5},{"x":0.666,"y":0.5,"width":0.334,"height":0.5}]}',
        sortOrder: 19,
      ),
      TemplateEntity(
        name: '左三右一',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":0.333},{"x":0,"y":0.333,"width":0.5,"height":0.334},{"x":0,"y":0.666,"width":0.5,"height":0.334},{"x":0.5,"y":0,"width":0.5,"height":1}]}',
        sortOrder: 20,
      ),
      TemplateEntity(
        name: '上二下三',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":0.5},{"x":0.5,"y":0,"width":0.5,"height":0.5},{"x":0,"y":0.5,"width":0.333,"height":0.5},{"x":0.333,"y":0.5,"width":0.334,"height":0.5},{"x":0.666,"y":0.5,"width":0.334,"height":0.5}]}',
        sortOrder: 21,
      ),
      TemplateEntity(
        name: '左一右三',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":1},{"x":0.5,"y":0,"width":0.5,"height":0.333},{"x":0.5,"y":0.333,"width":0.5,"height":0.334},{"x":0.5,"y":0.666,"width":0.5,"height":0.334}]}',
        sortOrder: 22,
      ),
      TemplateEntity(
        name: '上三下二',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.333,"height":0.5},{"x":0.333,"y":0,"width":0.334,"height":0.5},{"x":0.666,"y":0,"width":0.334,"height":0.5},{"x":0,"y":0.5,"width":0.5,"height":0.5},{"x":0.5,"y":0.5,"width":0.5,"height":0.5}]}',
        sortOrder: 23,
      ),
      TemplateEntity(
        name: '左二右三',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.5,"height":0.5},{"x":0,"y":0.5,"width":0.5,"height":0.5},{"x":0.5,"y":0,"width":0.5,"height":0.333},{"x":0.5,"y":0.333,"width":0.5,"height":0.334},{"x":0.5,"y":0.666,"width":0.5,"height":0.334}]}',
        sortOrder: 24,
      ),
      TemplateEntity(
        name: '上一下四',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":1,"height":0.5},{"x":0,"y":0.5,"width":0.25,"height":0.5},{"x":0.25,"y":0.5,"width":0.25,"height":0.5},{"x":0.5,"y":0.5,"width":0.25,"height":0.5},{"x":0.75,"y":0.5,"width":0.25,"height":0.5}]}',
        sortOrder: 25,
      ),
      TemplateEntity(
        name: '左四右一',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.25,"height":0.5},{"x":0,"y":0.5,"width":0.25,"height":0.5},{"x":0.25,"y":0,"width":0.25,"height":0.5},{"x":0.25,"y":0.5,"width":0.25,"height":0.5},{"x":0.5,"y":0,"width":0.5,"height":1}]}',
        sortOrder: 26,
      ),
      TemplateEntity(
        name: '六宫格',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.333,"height":0.5},{"x":0.333,"y":0,"width":0.334,"height":0.5},{"x":0.666,"y":0,"width":0.334,"height":0.5},{"x":0,"y":0.5,"width":0.333,"height":0.5},{"x":0.333,"y":0.5,"width":0.334,"height":0.5},{"x":0.666,"y":0.5,"width":0.334,"height":0.5}]}',
        sortOrder: 27,
      ),
      TemplateEntity(
        name: '九宫格',
        type: 'template',
        layoutData: '{"slots":[{"x":0,"y":0,"width":0.333,"height":0.333},{"x":0.333,"y":0,"width":0.334,"height":0.333},{"x":0.666,"y":0,"width":0.334,"height":0.333},{"x":0,"y":0.333,"width":0.333,"height":0.334},{"x":0.333,"y":0.333,"width":0.334,"height":0.334},{"x":0.666,"y":0.333,"width":0.334,"height":0.334},{"x":0,"y":0.666,"width":0.333,"height":0.334},{"x":0.333,"y":0.666,"width":0.334,"height":0.334},{"x":0.666,"y":0.666,"width":0.334,"height":0.334}]}',
        sortOrder: 28,
      ),
      TemplateEntity(
        name: '自由拼图',
        type: 'free',
        layoutData: '{}',
        sortOrder: 100,
      ),
      TemplateEntity(
        name: '长拼图',
        type: 'long',
        layoutData: '{"direction":"vertical"}',
        sortOrder: 101,
      ),
    ];

    for (var template in defaultTemplates) {
      await helper.insertTemplate(template);
    }
  }

  static Future<void> _initFilters(DbPhotoMosaicHelper helper) async {
    final defaultFilters = [
      FilterEntity(name: '原图', type: 'none', intensity: 1.0),
      FilterEntity(name: '黑白', type: 'grayscale', intensity: 1.0),
      FilterEntity(name: '怀旧', type: 'sepia', intensity: 1.0),
      FilterEntity(name: '鲜艳', type: 'vibrant', intensity: 1.0),
      FilterEntity(name: '柔和', type: 'soft', intensity: 1.0),
    ];

    for (var filter in defaultFilters) {
      await helper.insertFilter(filter);
    }
  }

  static Future<void> _initStickers(DbPhotoMosaicHelper helper) async {
    final defaultStickers = [
      StickerEntity(name: '心形1', category: '表情', imagePath: '', sortOrder: 1),
      StickerEntity(name: '心形2', category: '表情', imagePath: '', sortOrder: 2),
      StickerEntity(name: '星星1', category: '装饰', imagePath: '', sortOrder: 1),
      StickerEntity(name: '星星2', category: '装饰', imagePath: '', sortOrder: 2),
    ];

    for (var sticker in defaultStickers) {
      await helper.insertSticker(sticker);
    }
  }
}
