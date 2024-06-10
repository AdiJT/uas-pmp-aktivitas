import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/controllers/schedule_controller.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
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
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                elevation: 7,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        'Aktivitas Hari Ini',
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Divider(color: Theme.of(context).colorScheme.primary),
                    activityController.todayActivities.isNotEmpty ?
                    Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: activityController.todayActivities.length,
                        itemBuilder: (context, index) {
                          final activity = activityController.todayActivities[index];
        
                          return ListTile(
                            title: Text(
                              activity.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                                '${activity.date.day}/${activity.date.month}/${activity.date.year}'),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    '${activity.date.hour}:${activity.date.minute}'),
                                Text(activity.duration.formatDuration()),
                              ],
                            ),
                          );
                        },
                      ),
                    ) : const Text("Tidak Ada Aktivitas Hari Ini"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                elevation: 7,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        'Jadwal Hari Ini',
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Divider(color: Theme.of(context).colorScheme.primary),
                    scheduleController.todaySchedule.isNotEmpty ?
                    Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: scheduleController.todaySchedule.length,
                        itemBuilder: (context, index) {
                          final schedule = scheduleController.todaySchedule[index];
        
                          return ListTile(
                            title: Text(
                              schedule.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    '${"${schedule.time.hour}".padLeft(2, '0')}:${"${schedule.time.minute}".padLeft(2, '0')}'),
                                Text(schedule.duration.formatDuration()),
                              ],
                            ),
                          );
                        },
                      ),
                    ) : const Text("Jadwal Kosong"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
