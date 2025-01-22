import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichTextButton extends StatelessWidget {
  final String normalText;
  final String clickableText;
  final VoidCallback onPressed;
  final Color normalTextColor;
  final Color clickableTextColor;

  const RichTextButton({
    required this.normalText,
    required this.clickableText,
    required this.onPressed,
    this.normalTextColor = Colors.black,
    this.clickableTextColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: normalTextColor),
        children: [
          TextSpan(text: normalText),
          TextSpan(
            text: clickableText,
            style: TextStyle(
              color: clickableTextColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = onPressed,
          ),
        ],
      ),
    );
  }
}
