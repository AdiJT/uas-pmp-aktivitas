import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/duration_picker.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
import 'package:flutter_application_uas_aktivitas/commons/validation.dart';
import 'package:flutter_application_uas_aktivitas/controllers/schedule_controller.dart';
import 'package:flutter_application_uas_aktivitas/models/schedule.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final controller = Get.find<ScheduleController>();

  void _showDeleteDialog(Schedule schedule) async {
    final delete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.orangeAccent
            .withOpacity(0.8), // Mengubah warna background AlertDialog
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Apakah anda yakin ingin menghapus?',
              style: TextStyle(
                color: Colors.white, // Mengubah warna teks AlertDialog
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    'Hapus',
                    style: TextStyle(
                      color: Colors.red, // Mengubah warna teks tombol Hapus
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: Colors.white, // Mengubah warna teks tombol Batal
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    if (delete != null && delete == true) {
      controller.deleteSchedule(schedule);
    }
  }

  void _addScheduleDialog(Day day) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final timeController = TextEditingController();
    final durationController = DurationPickerController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah Jadwal di Hari ${day.toCascadeString()}"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          label: Row(
                            children: [
                              Text('Judul'),
                              Text(
                                ' *',
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim() == "") {
                            return "Belum diisi";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        maxLines: 2,
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Dekripsi",
                        ),
                      ),
                      TextFormField(
                        controller: timeController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          final rules = [
                            notNullOrEmpty,
                            parseSuccess((s) {
                              try {
                                final format = DateFormat('h:mm a');
                                return TimeOfDay.fromDateTime(
                                    format.parse(value!));
                              } on Exception catch (_) {
                                return null;
                              }
                            }),
                            ValidationRule<String?>(
                                message: "Slot waktu hari ini tidak cukup",
                                rule: (s) {
                                  final format = DateFormat('h:mm a');
                                  final duration = durationController.value;
                                  final startTime = TimeOfDay.fromDateTime(
                                      format.parse(value!));

                                  return controller.checkTimeSlotInDay(
                                      day, startTime, duration);
                                })
                          ];

                          final result = rules.map((e) => e.validate(value));

                          if (!result.every((e) => e.success)) {
                            return result
                                .firstWhere((e) => e.success == false)
                                .errorMessage;
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Row(
                            children: [
                              Text('Waktu'),
                              Text(
                                ' *',
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          hintText: "h:mm AM/PM",
                          suffixIcon: IconButton(
                            onPressed: () async {
                              final timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (timeOfDay != null) {
                                if (context.mounted) {
                                  timeController.text =
                                      timeOfDay.format(context);
                                }
                              }
                            },
                            icon: const Icon(Icons.schedule),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Durasi'),
                          DurationPicker(
                            controller: durationController,
                            onChange: (value) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final format = DateFormat('h:mm a');

                            final schedule = Schedule(
                              title: titleController.text,
                              day: day,
                              time: TimeOfDay.fromDateTime(
                                  format.parse(timeController.text)),
                              duration: durationController.value,
                            );

                            Get.back(closeOverlays: true);
                            controller.addSchedule(schedule);
                          }
                        },
                        child: const Text('Tambah')),
                    TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Batal')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _scheduleCard(Day day, List<Schedule> schedules) {
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
              day.toCascadeString(),
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
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
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
                                  break;
                                case 'Hapus':
                                  _showDeleteDialog(schedule);
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
                    );
                  },
                )
              : Text(
                  "Jadwal Hari ${day.toCascadeString()} Kosong",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
          const Divider(color: Colors.white),
          TextButton(
            child: const Text('Tambah', style: TextStyle(color: Colors.white)),
            onPressed: () {
              _addScheduleDialog(day);
            },
          ),
        ],
      ),
    );
  }

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
                _scheduleCard(entries.key, entries.value)
            ],
          ),
        ),
      ),
    );
  }
}
