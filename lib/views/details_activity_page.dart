import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/commons/date_time_extension.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/models/activity.dart';
import 'package:flutter_application_uas_aktivitas/views/edit_activity_page.dart';
import 'package:get/get.dart';

class DetailsActivityPage extends StatefulWidget {
  const DetailsActivityPage({super.key, required this.activity});

  final Activity activity;

  @override
  State<DetailsActivityPage> createState() => _DetailsActivityPageState();
}

class _DetailsActivityPageState extends State<DetailsActivityPage> {
  final controller = Get.find<ActivityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Aktivitas',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white), // Warna teks putih
        ),
        backgroundColor: Colors.lightBlue, // Warna AppBar menjadi lightblue
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Get.to(() => EditActivityPage(activity: widget.activity)),
        backgroundColor: Colors.lightBlue,
        child: const Icon(
            Icons.edit), // Warna FloatingActionButton menjadi lightblue
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(20),
          color: Colors.orangeAccent.withOpacity(
              0.8), // Warna detail aktivitas menjadi orangeAccent dengan transparansi 0.8
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    controller.getById(widget.activity.id).name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Obx(
                    () => Text(
                        controller.getById(widget.activity.id).description,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(
                    () => Text(
                      controller
                          .getById(widget.activity.id)
                          .date
                          .toIdStyleStringWithMonthName(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(
                    () => Text(
                      TimeOfDay.fromDateTime(
                        controller.getById(widget.activity.id).date,
                      ).format(context),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(
                    () => Text(
                      controller
                          .getById(widget.activity.id)
                          .duration
                          .formatDuration(),
                      style: const TextStyle(
                          color: Colors.white), // Warna teks putih
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
