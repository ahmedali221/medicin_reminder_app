import 'package:flutter/material.dart';

class CustomTimePicker extends StatelessWidget {
  final String labelText;
  final TimeOfDay selectedTime;
  final Function(TimeOfDay) onTimeSelected;

  const CustomTimePicker({
    Key? key,
    required this.labelText,
    required this.selectedTime,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$labelText: ${selectedTime.format(context)}'),
      trailing: const Icon(Icons.access_time),
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
    );
  }
}
