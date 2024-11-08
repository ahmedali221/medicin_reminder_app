import 'package:flutter/material.dart';

class SignInButtonIcon extends StatelessWidget {
  final String type;
  final VoidCallback ontap;
  const SignInButtonIcon({super.key, required this.type, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: 50, width: 50, child: Image.asset('assets/$type.png')),
        ),
      ),
    );
  }
}
