import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MedicineItem extends StatelessWidget {
  final String medicineName;
  final int dosage;
  final String frequency;
  final List<String> times;
  final String medicineType;
  final DateTime startDate;
  final DateTime endDate;

  const MedicineItem({
    super.key,
    required this.medicineName,
    required this.medicineType,
    required this.frequency,
    required this.dosage,
    required this.times,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMedicineTypeIcon(medicineType),
              const SizedBox(height: 16.0),
              Text(
                medicineName,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' ${dosage.toString()} ${getFrequencyLabel(frequency)} ',
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8,
                runSpacing: 5,
                children: times
                    .map((timestamp) => SizedBox(
                          child: Chip(
                            shape: const StadiumBorder(),
                            label: Text(
                              timestamp,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getFrequencyLabel(String frequency) {
    switch (frequency) {
      case 'Daily':
        return 'Times/Day';
      case 'Weekly':
        return 'Times/Week';
      case 'Monthly':
        return 'Times/Month';
      default:
        return 'Times';
    }
  }

  Widget _buildMedicineTypeIcon(String type) {
    switch (type) {
      case 'MedicineType.Tablet':
        return const Icon(Symbols.pill_sharp, color: Colors.grey);
      case 'MedicineType.Capsule':
        return const Icon(Symbols.pill, color: Colors.grey);
      case 'MedicineType.Syrup':
        return const Icon(Icons.local_drink_rounded, color: Colors.grey);
      case 'MedicineType.Injection':
        return const Icon(Symbols.syringe_rounded, color: Colors.grey);
      default:
        return const Text(
          'Unknown',
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
        );
    }
  }
}
