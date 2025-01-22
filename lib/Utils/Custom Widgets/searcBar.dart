import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Controllers/medicineController.dart';
import '../../Views/medicineDetails.dart';

class CustomSearchDelegate extends SearchDelegate {
  final WidgetRef ref;

  CustomSearchDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Enter your medicine name to search',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final medicines = ref.watch(medicineControllerProvider);

    // Filter medicines based on the query
    final filteredMedicines = medicines.where((medicine) {
      final medicineName = medicine.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return medicineName.contains(queryLower);
    }).toList();

    if (filteredMedicines.isEmpty) {
      return Center(
        child: Text(
          'No results found for "$query"',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredMedicines.length,
      itemBuilder: (context, index) {
        final medicine = filteredMedicines[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicineDetailsPage(
                    medicine: medicine,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dosage: ${medicine.dosage}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Type: ${medicine.type}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  // Text(
                  //   'Time: ${medicine.times}',
                  //   style: const TextStyle(fontSize: 16),
                  // ),
                  Text(
                    'Frequency: ${medicine.frequency}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Start Date: ${medicine.startDate}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'End Date: ${medicine.endDate}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Notes: ${medicine.notes}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Enter your medicine name ',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final medicines = ref.watch(medicineControllerProvider);

    final filteredMedicines = medicines.where((medicine) {
      final medicineName = medicine.name.toLowerCase();
      final queryLower = query.toLowerCase();

      // Check if the medicine name contains the query
      return medicineName.startsWith(queryLower);
    }).toList();

    if (filteredMedicines.isEmpty) {
      return Center(
        child: Text(
          'No results found for "$query"',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredMedicines.length,
      itemBuilder: (context, index) {
        final medicine = filteredMedicines[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicineDetailsPage(
                    medicine: medicine,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  medicine.image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            medicine.image!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.medication,
                          size: 40,
                          color: Colors.grey,
                        ),
                  const SizedBox(width: 16),
                  Text(
                    medicine.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
