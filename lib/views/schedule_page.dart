import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/schedule_card.dart';
import 'package:flutter_application_uas_aktivitas/controllers/schedule_controller.dart';
import 'package:get/get.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final controller = Get.find<ScheduleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwal',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white), // Warna teks putih
        ),
        backgroundColor: Colors.lightBlue, // Warna AppBar menjadi lightblue
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              for (var entries in controller.scheduleByDay.entries)
                ScheduleCard(schedules: entries.value, day: entries.key)
            ],
          ),
        ),
      ),
    );
  }
}
