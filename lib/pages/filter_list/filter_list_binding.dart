import 'package:get/get.dart';
import 'filter_list_logic.dart';

class FilterListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FilterListLogic());
  }
}
