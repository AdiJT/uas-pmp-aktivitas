import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/controllers/schedule_controller.dart';
import 'package:flutter_application_uas_aktivitas/database/database_helper.dart';
import 'package:flutter_application_uas_aktivitas/views/main_layout.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final instance = await dbInstance;
  Get.put(instance, permanent: true);

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
      debugShowCheckedModeBanner: false,
      home: const MainLayout(),
    );
  }
}
