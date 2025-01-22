import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../Controllers/medicineController.dart'; // Import the MedicineController
import '../Models/medicine.dart';
import '../Utils/Custom Widgets/detailListTile.dart';
import 'editMedicine.dart'; // Import the EditMedicinePage

class MedicineDetailsPage extends ConsumerStatefulWidget {
  final Medicine medicine;

  const MedicineDetailsPage({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  @override
  _MedicineDetailsPageState createState() => _MedicineDetailsPageState();
}

class _MedicineDetailsPageState extends ConsumerState<MedicineDetailsPage> {
  late Medicine _currentMedicine;

  @override
  void initState() {
    super.initState();
    _currentMedicine = widget.medicine; // Initialize with the passed medicine
  }

  // Helper function to format the date
  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString; // Return the original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentMedicine.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Navigate to the EditMedicinePage
              final updatedMedicine = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMedicinePage(
                    medicine: _currentMedicine,
                  ),
                ),
              );

              if (updatedMedicine != null) {
                // Update the state with the new medicine data
                setState(() {
                  _currentMedicine = updatedMedicine;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the medicine photo
              if (_currentMedicine.image != null)
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _currentMedicine.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Medicine details using custom DetailListTile
              Column(
                children: [
                  DetailListTile(
                    title: 'Name',
                    value: _currentMedicine.name,
                  ),
                  DetailListTile(
                    title: 'Type',
                    value: _currentMedicine.type,
                  ),
                  DetailListTile(
                    title: 'Dosage',
                    value: _currentMedicine.dosage,
                  ),
                  DetailListTile(
                    title: 'Frequency',
                    value: _currentMedicine.frequency,
                  ),
                  if (_currentMedicine.frequency.contains('Weekly'))
                    DetailListTile(
                      title: 'Day of the Week',
                      value:
                          _currentMedicine.frequency.replaceAll('Every ', ''),
                    ),
                  DetailListTile(
                    title: 'Times',
                    value: _currentMedicine.time,
                  ),
                  DetailListTile(
                    title: 'Start Date',
                    value: _formatDate(_currentMedicine.startDate),
                  ),
                  DetailListTile(
                    title: 'End Date',
                    value: _formatDate(_currentMedicine.endDate),
                  ),
                  DetailListTile(
                    title: 'Notes',
                    value: _currentMedicine.notes,
                    showDivider: false, // No divider after the last item
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Take Medicine Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Show an alert dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog.adaptive(
                          icon: const Icon(Icons.info_outline,
                              color: Color(0xFF1565C0), size: 40),
                          title: const Text('Coming Soon'),
                          content: const Text(
                              'Taking will be available in a future update. Stay tuned!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.medical_services),
                  label: const Text('Take Medicine'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Delete Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Confirm deletion
                    final confirmed = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog.adaptive(
                        title: const Text('Delete Medicine'),
                        content: const Text(
                            'Are you sure you want to delete this medicine?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      // Delete the medicine from the database using the MedicineController
                      await ref
                          .read(medicineControllerProvider.notifier)
                          .deleteMedicine(_currentMedicine.id!);
                      // Show success dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog.adaptive(
                          icon: const Icon(Icons.verified,
                              color: Color(0xFF1565C0), size: 40),
                          title: const Text('Success'),
                          content: const Text('Medicine deleted successfully!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context, true);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Medicine'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
