import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/commons/date_time_extension.dart';
import 'package:flutter_application_uas_aktivitas/commons/validation.dart';

class DateTextFormField extends StatelessWidget {
  const DateTextFormField({
    super.key,
    required this.dateController,
    this.validator,
  });

  final String? Function(DateTime?)? validator;
  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        final rules = [notNullOrEmpty, parseSuccess((s) => s?.parseIdStyle())];

        final result = rules.map((e) => e.validate(value));

        if (!result.every((e) => e.success)) {
          return result.firstWhere((e) => e.success == false).errorMessage;
        }

        if(validator != null) {
          return validator!(value.parseIdStyle());
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
              firstDate:
                  DateTime.now().subtract(const Duration(days: 100 * 365)),
              lastDate: DateTime.now().add(const Duration(days: 100 * 365)),
              initialDate: DateTime.now(),
            );

            if (date != null) {
              dateController.text = date.toIdStyleString();
            }
          },
          icon: const Icon(Icons.calendar_today),
        ),
      ),
    );
  }
}
