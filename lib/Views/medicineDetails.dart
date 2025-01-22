import 'package:MedTime/Models/medicineHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../Controllers/medicineController.dart'; // Import the MedicineController
import '../Controllers/medicineHistoryController.dart';
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

  Future<void> _addHistoryEntry(String status) async {
    MedicineHistory history = MedicineHistory(
      medicine: _currentMedicine, // Pass the Medicine object directly
      status: status,
      timestamp: DateTime.now().toLocal(),
    );

    await ref
        .read(medicineHistoryControllerProvider.notifier)
        .addMedicineHistory(history);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Medicine $status successfully!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Custom Column with spacing
  Widget _buildSpacedColumn({
    required List<Widget> children,
    double spacing = 16.0,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children
          .map((child) => Padding(
                padding: EdgeInsets.only(bottom: spacing),
                child: child,
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

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
        padding: EdgeInsets.all(isPortrait ? 16.0 : 24.0),
        child: SingleChildScrollView(
          child: _buildSpacedColumn(
            spacing: isPortrait ? 16.0 : 24.0,
            children: [
              // Display the medicine photo
              if (_currentMedicine.image != null)
                Center(
                  child: Container(
                    width: isPortrait ? 120 : 160,
                    height: isPortrait ? 120 : 160,
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

              // Medicine details using custom DetailListTile
              _buildSpacedColumn(
                spacing: isPortrait ? 12.0 : 16.0,
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

              // Take Medicine Button
              Row(
                children: [
                  // Snooze Button

                  // Skip Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _addHistoryEntry(
                            'Skipped'); // Add history with "Skipped" status
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Skip'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.red, // Custom color for skip
                      ),
                    ),
                  ),
                ],
              ),

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
