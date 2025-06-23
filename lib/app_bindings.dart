import 'package:get/get.dart';
import 'controllers/admin_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/reservation_controller.dart';
import 'controllers/service_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(AdminController(), permanent: true);
    Get.lazyPut(() => ServiceController());
    Get.lazyPut(() => ReservationController());
    Get.lazyPut(() => ProfileController());
  }
}
