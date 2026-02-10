import 'package:get/get.dart';
import 'template_select_logic.dart';

class TemplateSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TemplateSelectLogic());
  }
}
