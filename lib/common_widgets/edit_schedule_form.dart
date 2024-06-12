import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/duration_picker.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/time_text_form_field.dart';
import 'package:flutter_application_uas_aktivitas/commons/validation.dart';
import 'package:flutter_application_uas_aktivitas/controllers/schedule_controller.dart';
import 'package:flutter_application_uas_aktivitas/models/schedule.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditScheduleForm extends StatefulWidget {
  const EditScheduleForm({
    super.key,
    required this.schedule,
  });

  final Schedule schedule;

  @override
  State<EditScheduleForm> createState() => _EditScheduleFormState();
}

class _EditScheduleFormState extends State<EditScheduleForm> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final timeController = TextEditingController();

  final controller = Get.find<ScheduleController>();

  Day day = Day.senin;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    titleController.text = widget.schedule.title;
    descriptionController.text = widget.schedule.description ?? "";

    final format = DateFormat("h:mm a");
    timeController.text = format.format(DateTime(
      0,
      0,
      0,
      widget.schedule.time.hour,
      widget.schedule.time.minute,
    ));

    duration = widget.schedule.duration;
    day = widget.schedule.day;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                DropdownButtonFormField<Day>(
                  value: day,
                  items: Day.values.map(
                    (e) {
                      return DropdownMenuItem<Day>(
                        value: e,
                        child: Text(e.toCascadeString()),
                      );
                    },
                  ).toList(),
                  onChanged: (e) {
                    setState(() {
                      day = e!;
                    });
                  },
                ),
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
                TimeTextFormField(
                  controller: timeController,
                  validator: (timeOfday) {
                    final rule = ValidationRule<TimeOfDay?>(
                      message: "Slot waktu hari ini tidak cukup",
                      rule: (startTime) => controller.checkTimeSlotInDay(
                          day, startTime!, duration),
                    );
                    final result = rule.validate(timeOfday);

                    if (result.success == false) {
                      return result.errorMessage;
                    }

                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Durasi'),
                    DurationPicker(
                      initialDuration: duration,
                      onChange: (value) {
                        setState(() {
                          duration = value;
                        });
                      },
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
                        id: widget.schedule.id,
                        userId: widget.schedule.userId,
                        title: titleController.text,
                        description: descriptionController.text,
                        day: day,
                        time: TimeOfDay.fromDateTime(
                            format.parse(timeController.text)),
                        duration: duration,
                      );

                      Get.back(closeOverlays: true);
                      controller.editSchedule(schedule);
                    }
                  },
                  child: const Text('Edit')),
              TextButton(
                  onPressed: () => Get.back(), child: const Text('Batal')),
            ],
          ),
        ],
      ),
    );
  }
}
