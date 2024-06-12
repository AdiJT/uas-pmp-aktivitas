import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/views/activity_list_page.dart';
import 'package:flutter_application_uas_aktivitas/views/activity_timeline_page.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:get/get.dart';

enum ListType { list, date }

extension on ListType {
  String toLongString() {
    return switch (this) {
      ListType.date => "Tampilkan sebagai kalender",
      ListType.list => "Tampilkan sebagai daftar",
    };
  }

  Icon icon() {
    return switch (this) {
      ListType.list => const Icon(Icons.list_alt),
      ListType.date => const Icon(Icons.calendar_month_outlined),
    };
  }
}

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final controller = Get.find<ActivityController>();

  ListType listType = ListType.list;

  final pages = {
    ListType.date: const ActivityTimelinePage(),
    ListType.list: const ActivityListPage()
  };

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
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: PopupMenuButton<ListType>(
                icon: const Icon(Icons.sort),
                onSelected: (choice) {
                  setState(() {
                    listType = choice;
                  });
                },
                itemBuilder: (context) {
                  return ListType.values
                      .map((e) => PopupMenuItem(
                            value: e,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: e.icon(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(e.toLongString()),
                                )
                              ],
                            ),
                          ))
                      .toList();
                }),
          ),
          Expanded(child: pages[listType]!),
        ],
      ),
    );
  }
}
