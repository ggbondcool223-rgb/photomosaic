import 'package:get/get.dart';
import '../../db_photo_mosaic/db_photo_mosaic_helper.dart';
import '../../db_photo_mosaic/db_photo_mosaic_entity.dart';
import '../../utils/logger.dart';

class TemplateSelectLogic extends GetxController {
  final templates = <TemplateEntity>[].obs;
  final totalCount = 0.obs;
  final currentPage = 0.obs;
  final pageCount = 1.obs;

  @override
  void onInit() {
    super.onInit();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    try {
      final helper = DbPhotoMosaicHelper();
      final allTemplates = await helper.getAllTemplates();
      templates.value = allTemplates;
      totalCount.value = allTemplates.length;
      pageCount.value = (allTemplates.length / 16).ceil();
      Logger.d('Loaded ${allTemplates.length} templates');
    } catch (e) {
      Logger.e('Failed to load templates', e);
    }
  }

  void selectTemplate(int templateId) {
    Logger.d('Selected template: $templateId');
    final template = templates.firstWhere((t) => t.id == templateId);
    if (template.type == 'free') {
      Get.toNamed('/free_collage', arguments: {'templateId': templateId});
    } else if (template.type == 'long') {
      Get.toNamed('/long_collage', arguments: {'templateId': templateId});
    } else {
      Get.toNamed('/collage_edit', arguments: {'templateId': templateId});
    }
  }
}
