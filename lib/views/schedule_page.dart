import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/duration_picker.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
import 'package:flutter_application_uas_aktivitas/commons/validation.dart';
import 'package:flutter_application_uas_aktivitas/controllers/schedule_controller.dart';
import 'package:flutter_application_uas_aktivitas/models/schedule.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final controller = Get.find<ScheduleController>();

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
                                  final startTime = TimeOfDay.fromDateTime(
                                      format.parse(value!));

                                  final startTimeInHour =
                                      startTime.hour.toDouble() +
                                          (startTime.minute.toDouble() / 60);
                                  final duration = durationController.value;

                                  if (startTimeInHour + duration.inHours > 24) {
                                    return false;
                                  }

                                  final endTimeInHour = startTimeInHour +
                                      (duration.inHours +
                                          (duration.inMinutes % 60) / 60);

                                  final daySchedules =
                                      controller.scheduleByDay[day]?.map((e) {
                                    final sT = e.time.hour.toDouble() +
                                        (e.time.minute.toDouble() / 60);
                                    final eT = sT +
                                        (e.duration.inHours +
                                            (e.duration.inMinutes % 60) / 60);
                                    return (sT, eT);
                                  }).toList();

                                  if (daySchedules == null ||
                                      daySchedules.isEmpty) return true;

                                  if (daySchedules
                                      .any((s) => s.$1 == startTimeInHour)) {
                                    return false;
                                  }

                                  if (daySchedules
                                      .any((s) => s.$2 == endTimeInHour)) {
                                    return false;
                                  }

                                  

                                  return true;
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
                    TextButton(onPressed: () {
                      if(formKey.currentState!.validate()) {
                        
                      }
                    }, child: const Text('Tambah')),
                    TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
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
          Divider(color: Colors.white), // Warna Divider putih
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
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              '${"${schedule.time.hour}".padLeft(2, '0')}:${"${schedule.time.minute}".padLeft(2, '0')}',
                              style: const TextStyle(
                                  color: Colors.white)), // Warna teks putih
                          Text(schedule.duration.formatDuration(),
                              style: const TextStyle(
                                  color: Colors.white)), // Warna teks putih
                        ],
                      ),
                    );
                  },
                )
              : Text("Jadwal Hari ${day.toCascadeString()} Kosong",
                  style:
                      const TextStyle(color: Colors.white)), // Warna teks putih
          Divider(color: Colors.white), // Warna Divider putih
          TextButton(
            child: const Text('Tambah',
                style: TextStyle(color: Colors.white)), // Warna teks putih
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
