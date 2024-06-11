import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/activity_form.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/models/activity.dart';
import 'package:get/get.dart';

class EditActivityPage extends StatefulWidget {
  const EditActivityPage({super.key, required this.activity});

  final Activity activity;

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
              color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: ActivityForm(
        initialValue: widget.activity,
        onSubmit: (value) =>
            controller.editActivity(value),
        submitButtonIcon: const Icon(Icons.edit),
      ),
    );
  }
}
