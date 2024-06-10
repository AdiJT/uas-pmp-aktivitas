import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/commons/validation.dart';

class NumberPicker extends StatefulWidget {
  const NumberPicker({
    super.key,
    required this.onChange,
    this.initialValue = 0,
    this.max = 100,
    this.min = 0,
  });

  final void Function(int value) onChange;
  final int initialValue;
  final int max;
  final int min;

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  int value = 0;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
    controller.text = value.toString();
  }

  void _increment() {
    setState(() {
      value++;
      value = value.clamp(widget.min, widget.max);
    });

    controller.text = value.toString();
    widget.onChange(value);
  }

  void _decrement() {
    setState(() {
      value--;
      value = value.clamp(widget.min, widget.max);
    });

    controller.text = value.toString();
    widget.onChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 35,
            onPressed: _increment,
            icon: const Icon(Icons.arrow_drop_up),
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              maxLines: 1,
              controller: controller,
              onSubmitted: (string) {
                final validationRules = [
                  notNullOrEmpty,
                  mustBeNumber,
                  parseSuccess((s) => int.tryParse(s!)),
                ];
            
                var result = validationRules.map((r) => r.validate(string)).toList();
            
                if(result.every((r) => r.success)) {
                  setState(() {
                    value = int.parse(string);
                    value = value.clamp(widget.min, widget.max);
                  });
                  controller.text = value.toString();
                  widget.onChange(value);
                } else {
                  controller.text = value.toString();
                }
              },
            ),
          ),
          IconButton(
            iconSize: 35,
            onPressed: _decrement,
            icon: const Icon(Icons.arrow_drop_down),
          ),
        ],
      ),
    );
  }
}
