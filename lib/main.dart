import 'package:flutter/material.dart';
import 'package:flutter_crud_api_app/utils/initial_binding.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'firebase_options.dart'; // from flutterfire configure

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter REST + Auth Demo',
      initialBinding: InitialBinding(),
      theme: ThemeData(
        useMaterial3: true, // optional
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.LOGIN,
      // initialRoute: Routes.OBJECT_LIST,
      getPages: AppPages.pages,
    );
  }
}
