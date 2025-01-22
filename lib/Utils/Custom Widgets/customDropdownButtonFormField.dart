import 'package:flutter/material.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final T? value;
  final String labelText;
  final List<T> items;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final String Function(T)? displayText;

  const CustomDropdownButtonFormField({
    Key? key,
    required this.value,
    required this.labelText,
    required this.items,
    this.validator,
    this.onChanged,
    this.displayText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(labelText: labelText),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child:
              Text(displayText != null ? displayText!(item) : item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
