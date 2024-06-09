import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/views/main_layout.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
