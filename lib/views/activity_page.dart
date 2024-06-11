import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/activity_list_tile.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/views/add_activity_page.dart';
import 'package:get/get.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final controller = Get.find<ActivityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aktivitas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.activities.length,
          itemBuilder: (context, index) {
            final activity = controller.activities[index];

            return Container(
              decoration: BoxDecoration(
                color: activity.isDone == true
                    ? const Color.fromARGB(255, 214, 165, 92)
                    : Colors.orangeAccent.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ActivityListTile(activity: activity),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Get.to(() => const AddActivityPage()),
      ),
    );
  }
}
