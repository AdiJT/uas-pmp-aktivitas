import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/date_text_form_field.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/duration_picker.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/time_text_form_field.dart';
import 'package:flutter_application_uas_aktivitas/commons/date_time_extension.dart';
import 'package:flutter_application_uas_aktivitas/commons/duration_extension.dart';
import 'package:flutter_application_uas_aktivitas/controllers/user_controller.dart';
import 'package:flutter_application_uas_aktivitas/models/activity.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({
    super.key,
    this.initialValue,
    required this.onSubmit,
    required this.submitButtonIcon,
    this.dateTime,
  });

  final Activity? initialValue;
  final void Function(Activity) onSubmit;
  final Icon submitButtonIcon;
  final DateTime? dateTime;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final _formKey = GlobalKey<FormState>();

  final userController = Get.find<UserController>();

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
              if (widget.dateTime == null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: DateTextFormField(dateController: dateController),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TimeTextFormField(controller: timeController),
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
            if (widget.dateTime != null) {
              date = widget.dateTime;
            }

            final format = DateFormat('h:mm a');
            final time = TimeOfDay.fromDateTime(
                format.parse(timeController.text.trim()));

            date = date!.copyWith(hour: time.hour, minute: time.minute);
            Get.back(closeOverlays: true);
            widget.onSubmit(
              Activity(
                id: widget.initialValue?.id,
                userId: userController.user.value.id,
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
