import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/dialogs.dart';
import 'package:flutter_application_uas_aktivitas/commons/date_time_extension.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/models/activity.dart';
import 'package:flutter_application_uas_aktivitas/views/edit_activity_page.dart';
import 'package:get/get.dart';

class ActivityListTile extends StatefulWidget {
  const ActivityListTile({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityListTile> createState() => _ActivityListTileState();
}

class _ActivityListTileState extends State<ActivityListTile> {
  final controller = Get.find<ActivityController>();
  Activity get activity => widget.activity;

  void _showDetailDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.orangeAccent,
        content: SingleChildScrollView(
          child: Card(
            elevation: 0,
            color: Colors.orangeAccent,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    activity.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Divider(color: Colors.white),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(activity.description,
                        style: const TextStyle(color: Colors.white)),
                  ),
                  const Divider(color: Colors.white),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      activity.date.toIdStyleStringWithMonthName(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      TimeOfDay.fromDateTime(
                        activity.date,
                      ).format(context),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      activity.duration.formatDuration(),
                      style: const TextStyle(
                          color: Colors.white), // Warna teks putih
                    ),
                  ),
                  if (activity.isDone == false)
                    TextButton(
                      onPressed: () {
                        Get.back(closeOverlays: true);
                        controller.checkDoneActivity(activity);
                      },
                      child: const Text(
                        "Tandai Selesai",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _showDetailDialog(),
      leading: activity.isDone
          ? const Icon(
              Icons.done,
              color: Colors.white,
            )
          : activity.date.compareTo(DateTime.now()) < 0
              ? const Icon(
                  Icons.notifications_active,
                  color: Colors.red,
                )
              : null,
      title: Text(
        activity.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        '${activity.date.day}/${activity.date.month}/${activity.date.year}',
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: SizedBox(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(activity.date).format(context),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  activity.duration.formatDuration(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                switch (v) {
                  case 'Edit':
                    Get.to(() => EditActivityPage(activity: activity));
                    break;
                  case 'Hapus':
                    showDeleteDialog(
                        deleteAction: () {
                          controller.deleteActivity(activity.id);
                        },
                        context: context);
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Edit', 'Hapus'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
      ),
    );
  }
}
