import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/dialogs.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/views/add_activity_page.dart';
import 'package:flutter_application_uas_aktivitas/views/details_activity_page.dart';
import 'package:flutter_application_uas_aktivitas/views/edit_activity_page.dart';
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
                color: activity.isDone == false
                    ? const Color.fromARGB(255, 214, 165, 92)
                    : Colors.orangeAccent.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ListTile(
                onTap: () => Get.to(() => DetailsActivityPage(index: index)),
                leading: activity.isDone ? Icon(Icons.done) : null,
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
                            TimeOfDay.fromDateTime(activity.date)
                                .format(context),
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
                              Get.to(() => EditActivityPage(index: index));
                              break;
                            case 'Hapus':
                              showDeleteDialog(deleteAction: () {
                              controller.deleteActivity(activity);
                            }, context: context);
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
              ),
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
