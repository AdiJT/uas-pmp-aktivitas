import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(HomeController());

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '${hours > 0 ? "$hours jam" : ""}${minutes > 0 ? " $minutes menit" : ""}${seconds > 0 ? " $seconds detik" : ""}';
  }

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
      body: Column(
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
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.todayActivities.length,
                      itemBuilder: (context, index) {
                        final activity = controller.todayActivities[index];

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
                              Text(_formatDuration(activity.duration)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
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
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.todaySchedule.length,
                      itemBuilder: (context, index) {
                        final schedule = controller.todaySchedule[index];

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
                                  '${schedule.time.hour}:${"${schedule.time.minute}".padLeft(2, '0')}'),
                              Text(_formatDuration(schedule.duration)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
