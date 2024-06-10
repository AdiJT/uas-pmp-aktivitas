import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/common_widgets/number_picker.dart';

class DurationPicker extends StatefulWidget {
  const DurationPicker({super.key, required this.onChange});

  final void Function(Duration value) onChange;

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  int inHours = 0;
  int inMinutes = 0;
  int inSeconds = 0;

  void _durationChange() {
    widget.onChange(
        Duration(hours: inHours, minutes: inMinutes, seconds: inSeconds));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            NumberPicker(
              onChange: (v) {
                setState(() => inHours = v);
                _durationChange();
              },
              initialValue: 0,
              max: 24,
            ),
            const Text('Jam'),
          ],
        ),
        Column(
          children: [
            NumberPicker(
              onChange: (v) {
                setState(() => inMinutes = v);
                _durationChange();
              },
              initialValue: 0,
              max: 60,
            ),
            const Text('Menit'),
          ],
        ),
        Column(
          children: [
            NumberPicker(
              onChange: (v) {
                setState(() => inSeconds = v);
                _durationChange();
              },
              initialValue: 0,
              max: 60,
            ),
            const Text('Detik'),
          ],
        ),
      ],
    );
  }
}
