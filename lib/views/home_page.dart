import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/activity_card.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/schedule_card.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/controllers/schedule_controller.dart';
import 'package:flutter_application_uas_aktivitas/models/schedule.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final activityController = Get.find<ActivityController>();
  final scheduleController = Get.find<ScheduleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(
                () => ActivityCard(
                  activities: activityController.todayActivities,
                  title: "Aktivitas Hari Ini",
                  emptyCollectionLabel: "Tidak Ada Aktivitas Hari Ini",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(
                () => ActivityCard(
                  activities: activityController.dueActivities,
                  title: "Aktivitas Belum Selesai",
                  emptyCollectionLabel: "Semua Aktivitas Telah Dilakukan",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Obx(
                () => ScheduleCard(
                  schedules: scheduleController.todaySchedule,
                  day: dayFromDateTime(DateTime.now()),
                  title: "Jadwal Hari Ini",
                  canAdd: false,
                  showMenu: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
