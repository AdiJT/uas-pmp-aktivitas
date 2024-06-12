import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/activity_form.dart';
import 'package:flutter_application_uas_aktivitas/commons/date_time_extension.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:get/get.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key, this.dateTime});

  final DateTime? dateTime;

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final controller = Get.find<ActivityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        title: Row(
          mainAxisAlignment: widget.dateTime == null
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tambah Aktivitas'),
            if (widget.dateTime != null)
              Text(widget.dateTime!.toIdStyleStringWithMonthName())
          ],
        ),
        backgroundColor: Colors.lightBlue, // Warna AppBar menjadi lightblue
      ),
      body: ActivityForm(
        dateTime: widget.dateTime,
        onSubmit: (value) => controller.addActivity(value),
        submitButtonIcon: const Icon(Icons.add),
      ),
    );
  }
}
