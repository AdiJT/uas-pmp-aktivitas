import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/commons/validation.dart';
import 'package:intl/intl.dart';

class TimeTextFormField extends StatelessWidget {
  const TimeTextFormField(
      {super.key, this.validator, required this.controller});

  final String? Function(TimeOfDay?)? validator;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
          return result.firstWhere((e) => e.success == false).errorMessage;
        }

        if(validator != null) return validator!(TimeOfDay.fromDateTime(DateFormat('h:mm a').parse(value!)));

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
                controller.text = timeOfDay.format(context);
              }
            }
          },
          icon: const Icon(Icons.schedule),
        ),
      ),
    );
  }
}
