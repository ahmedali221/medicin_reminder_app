import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../Controllers/medicineHistoryController.dart';
import '../Models/medicineHistory.dart';

// StateProvider to manage the selected filter type
final filterTypeProvider = StateProvider<String>((ref) => 'All');

// ... (previous helper methods remain the same)

class MedicineHistoryPage extends ConsumerWidget {
  const MedicineHistoryPage({Key? key}) : super(key: key);

  // Group medicine history by date
  Map<DateTime, List<MedicineHistory>> _groupHistoryByDate(
      List<MedicineHistory> histories) {
    final groupedHistories = <DateTime, List<MedicineHistory>>{};

    for (var history in histories) {
      final date = DateTime(history.timestamp.year, history.timestamp.month,
          history.timestamp.day);

      if (!groupedHistories.containsKey(date)) {
        groupedHistories[date] = [];
      }
      groupedHistories[date]!.add(history);
    }

    // Sort dates in descending order
    return Map.fromEntries(groupedHistories.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key)));
  }

  // Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }
    return DateFormat('MMM dd').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineHistoryList = ref.watch(medicineHistoryControllerProvider);
    final selectedFilterType = ref.watch(filterTypeProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // Filter the list based on the selected type
    final filteredList = selectedFilterType == 'All'
        ? medicineHistoryList
        : medicineHistoryList
            .where((history) => history.medicine.type == selectedFilterType)
            .toList();

    // Group filtered histories by date
    final groupedHistories = _groupHistoryByDate(filteredList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await ref
                  .read(medicineHistoryControllerProvider.notifier)
                  .clearMedicineHistory();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips (Previous implementation remains the same)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 8, // Horizontal spacing between chips
              children: ['All', 'Pills', 'Syrup', 'Injection'].map((type) {
                return FilterChip(
                  label: Text(type),
                  selected: selectedFilterType == type,
                  onSelected: (selected) {
                    ref.read(filterTypeProvider.notifier).state = type;
                  },
                  backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                  selectedColor: Theme.of(context).chipTheme.selectedColor,
                  checkmarkColor: Theme.of(context).chipTheme.checkmarkColor,
                  labelStyle: selectedFilterType == type
                      ? Theme.of(context).chipTheme.secondaryLabelStyle
                      : Theme.of(context).chipTheme.labelStyle,
                  shape: Theme.of(context).chipTheme.shape,
                );
              }).toList(),
            ),
          ),
          // Grouped History List
          Expanded(
            child: groupedHistories.isEmpty
                ? const Center(
                    child: Text(
                      'No medicine history available.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: groupedHistories.length,
                    itemBuilder: (context, dateIndex) {
                      final date = groupedHistories.keys.elementAt(dateIndex);
                      final dayHistories = groupedHistories[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              _formatDate(date),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700]),
                            ),
                          ),

                          // Medicines for this date
                          ...dayHistories.map((history) {
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        history.medicine.image != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.memory(
                                                  history.medicine.image!,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.medical_information,
                                                size: 50,
                                                color: Colors.blue,
                                              ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                history.medicine.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Type: ${history.medicine.type}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 104, 103, 103),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 20),
                                    Text(
                                      'Dosage: ${formatDosage(history.medicine.dosage, history.medicine.type)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 104, 103, 103),
                                      ),
                                    ),
                                    buildStatusWidget(history.status),
                                    Text(
                                      '${formatTimestamp(history.timestamp)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 104, 103, 103),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Helper function to format dosage and type
String formatDosage(String dosage, String type) {
  switch (type.toLowerCase()) {
    case 'pills':
      return '$dosage pill/s';
    case 'syrup':
      return '$dosage ml';
    case 'injection':
      return '$dosage mg';
    default:
      return dosage; // Fallback if type is unknown
  }
}

// Helper function to format the timestamp
String formatTimestamp(DateTime timestamp) {
  return DateFormat('h:mm a').format(timestamp);
}

// Helper function to style the status based on its value
Widget buildStatusWidget(String status) {
  switch (status.toLowerCase()) {
    case 'taken':
      return const Text(
        'Status: Taken',
        style: TextStyle(
          fontSize: 16,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );

    case 'skipped':
      return const Text(
        'Status: Skipped',
        style: TextStyle(
          fontSize: 16,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    default:
      return Text(
        'Status: $status',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      );
  }
}
