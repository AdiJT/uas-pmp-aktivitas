import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/controllers/schedule_controller.dart';
import 'package:flutter_application_uas_aktivitas/controllers/user_controller.dart';
import 'package:flutter_application_uas_aktivitas/database/database_helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPref = await SharedPreferences.getInstance();
  Get.put(sharedPref, permanent: true);

  final instance = await dbInstance;
  Get.put(instance, permanent: true);

  Get.put(UserController());
  Get.put(ActivityController());
  Get.put(ScheduleController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red, brightness: Brightness.light),
        useMaterial3: true,
        fontFamily: 'Century Gothic',
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
