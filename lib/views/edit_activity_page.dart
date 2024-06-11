import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/activity_form.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:get/get.dart';

class EditActivityPage extends StatefulWidget {
  const EditActivityPage({super.key, required this.index});

  final int index;

  @override
  State<EditActivityPage> createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  final controller = Get.find<ActivityController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Aktivitas',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white), // Warna teks putih
        ),
        backgroundColor: Colors.lightBlue, // Warna AppBar menjadi lightblue
      ),
      body: ActivityForm(
        initialValue: controller.activities[widget.index],
        onSubmit: (value) => controller.editActivity(widget.index, value),
        submitButtonIcon: const Icon(Icons.edit),
      ),
    );
  }
}
