import 'package:flutter/material.dart';

Widget buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue[900],
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    ),
  );
}
