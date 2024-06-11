import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/duration_picker.dart';
import 'package:flutter_application_uas_aktivitas/commons/date_time_extension.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
import 'package:flutter_application_uas_aktivitas/commons/validation.dart';
import 'package:flutter_application_uas_aktivitas/controllers/activity_controller.dart';
import 'package:flutter_application_uas_aktivitas/models/activity.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({Key? key}) : super(key: key);

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final controller = Get.find<ActivityController>();

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  var duration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Aktivitas',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white), // Warna teks putih
        ),
        backgroundColor: Colors.lightBlue, // Warna AppBar menjadi lightblue
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 5, left: 10, right: 10),
                child: TextFormField(
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    label: Row(
                      children: [
                        Text('Nama Aktivitas'),
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
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.trim() == "") {
                      return "Belum diisi";
                    }
                    return null;
                  },
                  maxLines: 3,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Deskripsi",
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: dateController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    final rules = [
                      notNullOrEmpty,
                      parseSuccess((s) => s.parseIdStyle())
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
                        Text('Tanggal'),
                        Text(
                          ' *',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    hintText: "dd-mm-yyyy",
                    suffixIcon: IconButton(
                      onPressed: () async {
                        var date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 100 * 365)),
                          lastDate: DateTime.now()
                              .add(const Duration(days: 100 * 365)),
                          initialDate: DateTime.now(),
                        );

                        if (date != null) {
                          dateController.text = date.toIdStyleString();
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  controller: timeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    final rules = [
                      notNullOrEmpty,
                      parseSuccess((s) {
                        try {
                          final format = DateFormat('h:mm a');
                          return TimeOfDay.fromDateTime(format.parse(value!));
                        } on Exception catch (_) {
                          return null;
                        }
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
                            timeController.text = timeOfDay.format(context);
                          }
                        }
                      },
                      icon: const Icon(Icons.schedule),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Durasi Aktivitas'),
                    DurationPicker(
                      onChange: (v) => setState(() {
                        duration = v;
                      }),
                    ),
                  ],
                ),
              ),
              Text(
                duration.formatDuration(),
                style: TextStyle(color: Colors.white), // Warna teks putih
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            var date = dateController.text.trim().parseIdStyle();

            final format = DateFormat('h:mm a');
            final time = TimeOfDay.fromDateTime(
                format.parse(timeController.text.trim()));

            date = date!.copyWith(hour: time.hour, minute: time.minute);

            Get.back(closeOverlays: true);
            controller.addActivity(
              Activity(
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
                date: date,
                duration: duration,
                isDone: false,
              ),
            );
          }
        },
        child: const Icon(Icons.add),
        backgroundColor:
            Colors.lightBlue, // Warna FloatingActionButton menjadi lightblue
      ),
    );
  }
}
