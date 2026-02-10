import 'package:get/get.dart';

import 'mosaic_edit_logic.dart';

class MosaicEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      MosaicEditLogic(),
      permanent: true,
    );
  }
}
