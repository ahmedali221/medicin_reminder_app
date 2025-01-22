import 'package:flutter/material.dart';

class DetailListTile extends StatelessWidget {
  final String title;
  final String value;
  final bool showDivider;

  const DetailListTile({
    Key? key,
    required this.title,
    required this.value,
    this.showDivider = true, // Default to true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2, // Add elevation
          margin: const EdgeInsets.symmetric(vertical: 4), // Add margin
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1565C0), // Apply the specified color
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
