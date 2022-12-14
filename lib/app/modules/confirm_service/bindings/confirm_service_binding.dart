import 'package:get/get.dart';

import '../controllers/confirm_service_controller.dart';

class ConfirmServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmServiceController>(
      () => ConfirmServiceController(),
    );
  }
}
