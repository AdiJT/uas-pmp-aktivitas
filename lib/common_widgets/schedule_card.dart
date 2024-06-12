import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/dialogs.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
import 'package:flutter_application_uas_aktivitas/controllers/schedule_controller.dart';
import 'package:flutter_application_uas_aktivitas/models/schedule.dart';
import 'package:get/get.dart';

import 'add_schedule_form.dart';
import 'edit_schedule_form.dart';

class ScheduleCard extends StatefulWidget {
  const ScheduleCard({
    super.key,
    required this.schedules,
    required this.day,
    this.title,
    this.canAdd = true,
    this.showMenu = true,
  });

  final List<Schedule> schedules;
  final Day day;
  final String? title;
  final bool canAdd;
  final bool showMenu;

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  final controller = Get.find<ScheduleController>();
  String get _effectiveTitle => widget.title ?? widget.day.toCascadeString();
  Day get day => widget.day;
  List<Schedule> get schedules => widget.schedules;

  void _addScheduleDialog(Day day) {
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah Jadwal di Hari ${day.toCascadeString()}"),
          content: AddScheduleForm(day: day),
        );
      },
    );
  }

  void _showEditScheduleDialog(Schedule schedule) {

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Jadwal"),
          content: EditScheduleForm(schedule: schedule,),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.purpleAccent.withOpacity(
          0.8), // Warna Card menjadi purpleAccent dengan transparansi 0.8
      elevation: 7,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              _effectiveTitle,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.white), // Warna teks putih
            ),
          ),
          const Divider(color: Colors.white), // Warna Divider putih
          schedules.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];

                    return ListTile(
                      title: Text(
                        schedule.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white, // Warna teks putih
                        ),
                      ),
                      trailing: widget.showMenu
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${"${schedule.time.hour}".padLeft(2, '0')}:${"${schedule.time.minute}".padLeft(2, '0')}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      schedule.duration.formatDuration(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                PopupMenuButton<String>(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 8,
                                    bottom: 8,
                                  ),
                                  iconColor: Colors.white,
                                  onSelected: (v) {
                                    switch (v) {
                                      case 'Edit':
                                        _showEditScheduleDialog(schedule);
                                        break;
                                      case 'Hapus':
                                        showDeleteDialog(
                                            deleteAction: () => controller
                                                .deleteSchedule(schedule),
                                            context: context);
                                        break;
                                      default:
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return {'Edit', 'Hapus'}
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${"${schedule.time.hour}".padLeft(2, '0')}:${"${schedule.time.minute}".padLeft(2, '0')}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  schedule.duration.formatDuration(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                    );
                  },
                )
              : Column(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 100,
                      color: Colors.white54,
                    ),
                    Text(
                      "Jadwal Hari ${day.toCascadeString()} Kosong",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
          if (widget.canAdd) ...[
            const Divider(color: Colors.white),
            TextButton(
              child:
                  const Text('Tambah', style: TextStyle(color: Colors.white)),
              onPressed: () {
                _addScheduleDialog(day);
              },
            ),
          ]
        ],
      ),
    );
  }
}
