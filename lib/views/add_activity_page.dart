import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/activity_form.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:get/get.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final controller = Get.find<ActivityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Aktivitas',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white), // Warna teks putih
        ),
        backgroundColor: Colors.lightBlue, // Warna AppBar menjadi lightblue
      ),
      body: ActivityForm(
        onSubmit: (value) => controller.addActivity(value),
        submitButtonIcon: const Icon(Icons.add),
      ),
    );
  }
}
