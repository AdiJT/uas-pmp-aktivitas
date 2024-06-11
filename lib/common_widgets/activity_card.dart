import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/activity_list_tile.dart';
import 'package:flutter_application_uas_aktivitas/models/activity.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activities,
    required this.title,
    required this.emptyCollectionLabel,
  });

  final List<Activity> activities;
  final String title;
  final String emptyCollectionLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orangeAccent.withOpacity(0.8),
      elevation: 7,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(color: Colors.white),
          activities.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];

                    return ActivityListTile(activity: activity);
                  },
                )
              : Column(
                  children: [
                    const Icon(
                      Icons.checklist,
                      size: 120,
                      color: Colors.white54,
                    ),
                    Text(
                      emptyCollectionLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
        ],
      ),
    );
  }
}
