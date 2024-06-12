import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/activity_list.dart';
import 'package:flutter_application_uas_aktivitas/commons/date_time_extension.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/views/add_activity_page.dart';
import 'package:get/get.dart';

class ActivityTimelinePage extends StatefulWidget {
  const ActivityTimelinePage({super.key});

  @override
  State<ActivityTimelinePage> createState() => _ActivityTimelinePageState();
}

class _ActivityTimelinePageState extends State<ActivityTimelinePage> {
  DateTime selectedDate = DateTime.now();
  final EasyInfiniteDateTimelineController timelineController =
      EasyInfiniteDateTimelineController();
  final controller = Get.find<ActivityController>();

  @override
  void initState() {
    selectedDate = selectedDate.removeTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Get.to(() => AddActivityPage(dateTime: selectedDate));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_double_arrow_left),
                iconSize: 34,
                onPressed: () {
                  if (controller.uniqueDate.isEmpty) return;
                  int index = controller.uniqueDate.indexOf(selectedDate);

                  if (index == -1) {
                    setState(() {
                      selectedDate = controller.uniqueDate[0];
                    });
                  }
                  if (index == 0) {
                    setState(() {
                      selectedDate = controller
                          .uniqueDate[controller.uniqueDate.length - 1];
                    });
                  } else {
                    index = (index - 1) % controller.uniqueDate.length;
                    setState(() {
                      selectedDate = controller.uniqueDate[index];
                    });
                  }
                  timelineController.animateToFocusDate();
                },
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_double_arrow_right),
                iconSize: 34,
                onPressed: () {
                  if (controller.uniqueDate.isEmpty) return;

                  int index = controller.uniqueDate.indexOf(selectedDate);
                  if (index == -1) {
                    setState(() {
                      selectedDate = controller.uniqueDate[0];
                    });
                  } else {
                    index = (index + 1) % controller.uniqueDate.length;
                    setState(() {
                      selectedDate = controller.uniqueDate[index];
                    });
                  }
                  timelineController.animateToCurrentData();
                },
              )
            ],
          ),
          EasyInfiniteDateTimeLine(
            controller: timelineController,
            firstDate:
                DateTime.now().subtract(const Duration(hours: 100 * 365)),
            focusDate: selectedDate,
            locale: "id_ID",
            lastDate: DateTime.now().add(
              const Duration(days: 100 * 365),
            ),
            onDateChange: (dateTime) {
              setState(() {
                selectedDate = dateTime.removeTime();
              });
            },
          ),
          Obx(() {
            if (controller.activityByDate[selectedDate] != null) {
              return ActivityList(
                activities: controller.activityByDate[selectedDate]!,
              );
            }

            return SizedBox();
          })
        ],
      ),
    );
  }
}
