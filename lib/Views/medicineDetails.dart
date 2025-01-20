import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../Controllers/medicineController.dart'; // Import the MedicineController
import '../Models/medicine.dart';
import 'editMedicine.dart'; // Import the EditMedicinePage

class MedicineDetailsPage extends StatefulWidget {
  final Medicine medicine;
  final MedicineNotifier
      medicineController; // Use MedicineController instead of DatabaseHelper

  const MedicineDetailsPage({
    Key? key,
    required this.medicine,
    required this.medicineController, // Pass the MedicineController
  }) : super(key: key);

  @override
  State<MedicineDetailsPage> createState() => _MedicineDetailsPageState();
}

class _MedicineDetailsPageState extends State<MedicineDetailsPage> {
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

  // Helper function to build a detail row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
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
                    medicineController: widget.medicineController,
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

              // Medicine details using _buildDetailRow
              _buildDetailRow('Name', _currentMedicine.name),
              _buildDetailRow('Type', _currentMedicine.type),
              _buildDetailRow('Dosage', _currentMedicine.dosage),
              _buildDetailRow('Frequency', _currentMedicine.frequency),
              if (_currentMedicine.frequency.contains('Weekly'))
                _buildDetailRow('Day of the Week',
                    _currentMedicine.frequency.replaceAll('Every ', '')),
              _buildDetailRow('Times', _currentMedicine.time),
              _buildDetailRow(
                  'Start Date', _formatDate(_currentMedicine.startDate)),
              _buildDetailRow(
                  'End Date', _formatDate(_currentMedicine.endDate)),
              _buildDetailRow('Notes', _currentMedicine.notes),

              const SizedBox(height: 20),

              // Take Medicine Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle the "Take Medicine" action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Taking ${_currentMedicine.name}'),
                      ),
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
                      builder: (context) => AlertDialog(
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
                      await widget.medicineController
                          .deleteMedicine(_currentMedicine.id!);
                      Navigator.pop(context);
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
