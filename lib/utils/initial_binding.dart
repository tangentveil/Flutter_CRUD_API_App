import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../controllers/auth_controller.dart';
import '../services/api_service.dart';
import '../controllers/object_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // singletons for entire app
    Get.put(AuthService());
    Get.put(AuthController(Get.find<AuthService>()));

    // object services/controllers
    Get.put(ApiService());
    Get.put(ObjectController(Get.find<ApiService>()));
  }
}
