import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/date_text_form_field.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/duration_picker.dart';
import 'package:flutter_application_uas_aktivitas/commons/date_time_extension.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
import 'package:flutter_application_uas_aktivitas/commons/validation.dart';
import 'package:flutter_application_uas_aktivitas/models/activity.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({
    super.key,
    this.initialValue,
    required this.onSubmit,
    required this.submitButtonIcon,
  });

  final Activity? initialValue;
  final void Function(Activity) onSubmit;
  final Icon submitButtonIcon;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      final activity = widget.initialValue!;

      nameController.text = activity.name;
      descriptionController.text = activity.description;
      dateController.text = activity.date.toIdStyleString();
      final dateFormat = DateFormat('h:mm a');
      timeController.text = dateFormat.format(activity.date);
      duration = activity.duration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    label: Row(
                      children: [
                        Text('Dekripsi'),
                        Text(
                          ' *',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: DateTextFormField(dateController: dateController),
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
                      initialDuration: duration,
                      onChange: (v) => setState(() {
                        duration = v;
                      }),
                    ),
                  ],
                ),
              ),
              Text(
                duration.formatDuration(), // Warna teks putih
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
            widget.onSubmit(
              Activity(
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
                date: date,
                duration: duration,
                isDone: widget.initialValue?.isDone ?? false,
              ),
            );
          }
        },
        backgroundColor: Colors.lightBlue,
        child: widget.submitButtonIcon,
      ),
    );
  }
}
