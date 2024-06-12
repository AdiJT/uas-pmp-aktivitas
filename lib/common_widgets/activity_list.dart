import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/activity_list_tile.dart';
import 'package:flutter_application_uas_aktivitas/models/activity.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({
    super.key,
    required this.activities,
  });

  final List<Activity> activities;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
    
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
    );
  }
}
