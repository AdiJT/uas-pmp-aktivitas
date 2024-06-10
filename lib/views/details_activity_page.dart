import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/commons/date_time_extension.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/views/edit_activity_page.dart';
import 'package:get/get.dart';

class DetailsActivityPage extends StatefulWidget {
  const DetailsActivityPage({super.key, required this.index});

  final int index;

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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () => Get.to(() => EditActivityPage(index: widget.index)),
      ),
      body: SingleChildScrollView(
        child: Card.outlined(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() => Text(controller.activities[widget.index].name)),
                const Divider(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Obx(() =>
                      Text(controller.activities[widget.index].description)),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(
                    () => Text(
                      controller.activities[widget.index].date
                          .toIdStyleStringWithMonthName(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(
                    () => Text(
                      TimeOfDay.fromDateTime(
                              controller.activities[widget.index].date)
                          .format(context),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Obx(
                    () => Text(
                      controller.activities[widget.index].duration
                          .formatDuration(),
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
