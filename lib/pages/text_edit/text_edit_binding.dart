import 'package:get/get.dart';
import 'text_edit_logic.dart';

class TextEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TextEditLogic());
  }
}
