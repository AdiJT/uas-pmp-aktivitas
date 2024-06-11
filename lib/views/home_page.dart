import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/activity_list_tile.dart';
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
              child: Card(
                color: Colors.orangeAccent.withOpacity(0.8),
                elevation: 7,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        'Aktivitas Hari Ini',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.white),
                    activityController.todayActivities.isNotEmpty
                        ? Obx(
                            () => ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  activityController.todayActivities.length,
                              itemBuilder: (context, index) {
                                final activity =
                                    activityController.todayActivities[index];

                                return ActivityListTile(activity: activity);
                              },
                            ),
                          )
                        : const Text(
                            "Tidak Ada Aktivitas Hari Ini",
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: ScheduleCard(
                schedules: scheduleController.todaySchedule,
                day: dayFromDateTime(DateTime.now()),
                title: "Jadwal Hari Ini",
                canAdd: false,
                showMenu: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
