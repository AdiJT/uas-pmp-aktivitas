import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/duration_picker.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/time_text_form_field.dart';
import 'package:flutter_application_uas_aktivitas/commons/validation.dart';
import 'package:flutter_application_uas_aktivitas/controllers/schedule_controller.dart';
import 'package:flutter_application_uas_aktivitas/controllers/user_controller.dart';
import 'package:flutter_application_uas_aktivitas/models/schedule.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddScheduleForm extends StatelessWidget {
  AddScheduleForm({super.key, required this.day});

  final Day day;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final timeController = TextEditingController();
  final durationController = DurationPickerController();

  final controller = Get.find<ScheduleController>();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                TimeTextFormField(
                  controller: timeController,
                  validator: (timeOfday) {
                    final rule = ValidationRule<TimeOfDay?>(
                      message: "Slot waktu hari ini tidak cukup",
                      rule: (startTime) => controller.checkTimeSlotInDay(
                          day, startTime!, durationController.value),
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
                        userId: userController.user.value.id,
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
                  onPressed: () => Get.back(), child: const Text('Batal')),
            ],
          ),
        ],
      ),
    );
  }
}
