import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/medecineItem.dart';

class MedicineDetailPage extends StatelessWidget {
  final MedicineItem medicineItem;

  const MedicineDetailPage({super.key, required this.medicineItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medicineItem.medicineName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          'Medicine Type', medicineItem.medicineType),
                      _buildDetailRow('Dosage', '${medicineItem.dosage}'),
                      _buildDetailRow('Frequency', medicineItem.frequency),
                      _buildDetailRow(
                          'Start Date',
                          DateFormat('dd/MM/yyyy')
                              .format(medicineItem.startDate)
                              .toString()),
                      _buildDetailRow(
                          'End Date',
                          DateFormat('dd/MM/yyyy')
                              .format(medicineItem.endDate)
                              .toString()),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dosage Times:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: medicineItem.times.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(medicineItem.times[index]),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
