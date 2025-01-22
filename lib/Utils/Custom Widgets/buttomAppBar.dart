import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  // final VoidCallback onMedicalTipsPressed;
  final VoidCallback onAddMedicinePressed;
  final VoidCallback onProfilePressed;

  const CustomBottomAppBar({
    Key? key,
    // required this.onMedicalTipsPressed,
    required this.onAddMedicinePressed,
    required this.onProfilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // // Medical Tips Button
          // IconButton.filled(
          //   onPressed: onMedicalTipsPressed,
          //   icon: const Icon(Icons.medical_services),
          //   tooltip: 'Medical Tips',
          // ),
          // Add Medicine Button
          IconButton.outlined(
            onPressed: onAddMedicinePressed,
            icon: const Icon(Icons.add),
            color: Colors.blue[900],
            tooltip: 'Add Medicine',
          ),
          // User Profile Button
          IconButton.filled(
            onPressed: onProfilePressed,
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
          ),
        ],
      ),
    );
  }
}
