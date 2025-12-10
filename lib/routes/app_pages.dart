import 'package:get/get.dart';
import '../views/auth/login_view.dart';
import '../views/auth/otp_view.dart';
import '../views/objects/object_list_view.dart';
import '../views/objects/object_detail_view.dart';
import '../views/objects/object_form_view.dart';
import '../controllers/object_controller.dart';
import '../services/api_service.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(name: Routes.OTP, page: () => const OtpView()),
    GetPage(
      name: Routes.OBJECT_LIST,
      page: () => const ObjectListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ObjectController(ApiService()));
      }),
    ),
    GetPage(name: Routes.OBJECT_DETAIL, page: () => const ObjectDetailView()),
    GetPage(name: Routes.OBJECT_FORM, page: () => const ObjectFormView()),
  ];
}
