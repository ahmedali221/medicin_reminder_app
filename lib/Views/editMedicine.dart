import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Controllers/medicineController.dart'; // Import the MedicineController
import '../Models/medicine.dart';
import '../Utils/Helpers/medicineFormHelper.dart';

class EditMedicinePage extends StatefulWidget {
  final Medicine medicine;
  final MedicineNotifier
      medicineController; // Use MedicineController instead of DatabaseHelper

  const EditMedicinePage({
    Key? key,
    required this.medicine,
    required this.medicineController, // Pass the MedicineController
  }) : super(key: key);

  @override
  _EditMedicinePageState createState() => _EditMedicinePageState();
}

class _EditMedicinePageState extends State<EditMedicinePage> {
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _notesController;

  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;
  Uint8List? _image;
  int _numberOfTimes = 1; // Number of times to take the medicine
  List<TimeOfDay> _selectedTimes = []; // List to store selected times

  // Dropdown options for medicine type
  final List<String> _medicineTypes = ['Pills', 'Injection', 'Syrup'];
  String _selectedType = 'Pills'; // Default selected type

  // Frequency options
  final List<String> _frequencyTypes = ['Daily', 'Weekly'];
  String _selectedFrequencyType = 'Daily'; // Default frequency type

  // Day of the week options (for weekly frequency)
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  String? _selectedDayOfWeek; // Selected day for weekly frequency

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine.name);
    _dosageController = TextEditingController(text: widget.medicine.dosage);
    _notesController = TextEditingController(text: widget.medicine.notes);

    _selectedStartDate = DateTime.parse(widget.medicine.startDate);
    _selectedEndDate = DateTime.parse(widget.medicine.endDate);

    // Parse frequency and times
    if (widget.medicine.frequency.contains('Weekly')) {
      _selectedFrequencyType = 'Weekly';
      _selectedDayOfWeek = widget.medicine.frequency.replaceAll('Every ', '');
    } else {
      _selectedFrequencyType = 'Daily';
      _numberOfTimes =
          int.tryParse(widget.medicine.frequency.split(' ')[0]) ?? 1;
    }

    // Parse times
    _selectedTimes = widget.medicine.time.split(', ').map((time) {
      try {
        // Remove any non-numeric characters (e.g., AM/PM)
        final cleanedTime = time.replaceAll(RegExp(r'[^0-9:]'), '');

        // Split the cleaned time into hours and minutes
        final parts = cleanedTime.split(':');
        if (parts.length == 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          return TimeOfDay(hour: hour, minute: minute);
        } else {
          // If the format is invalid, return the current time as a fallback
          return TimeOfDay.now();
        }
      } catch (e) {
        // If parsing fails, return the current time as a fallback
        return TimeOfDay.now();
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Medicine'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image Picker
            GestureDetector(
              onTap: () async {
                final imageBytes = await MedicineFormHelper.pickImage(context);
                if (imageBytes != null) {
                  setState(() {
                    _image = imageBytes;
                  });
                }
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? MemoryImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.add_a_photo, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Medicine Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Medicine Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Type'),
              items: _medicineTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Dosage Input
            TextFormField(
              controller: _dosageController,
              decoration: InputDecoration(
                labelText: _selectedType == 'Pills'
                    ? 'Number of Capsules'
                    : _selectedType == 'Syrup'
                        ? 'Amount in ml'
                        : 'Dosage Quantity',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a dosage';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Frequency Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedFrequencyType,
              decoration: const InputDecoration(labelText: 'Frequency Type'),
              items: _frequencyTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFrequencyType = value!;
                  _selectedDayOfWeek = null; // Reset day of the week
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a frequency type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Day of the Week Dropdown (for Weekly Frequency)
            if (_selectedFrequencyType == 'Weekly')
              DropdownButtonFormField<String>(
                value: _selectedDayOfWeek,
                decoration: const InputDecoration(labelText: 'Day of the Week'),
                items: _daysOfWeek.map((day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDayOfWeek = value!;
                  });
                },
                validator: (value) {
                  if (_selectedFrequencyType == 'Weekly' &&
                      (value == null || value.isEmpty)) {
                    return 'Please select a day';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 16),

            // Number of Times Input
            TextFormField(
              controller: TextEditingController(
                text: _numberOfTimes.toString(),
              ),
              decoration: const InputDecoration(labelText: 'Number of Times'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _numberOfTimes = int.tryParse(value) ?? 1;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of times';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Generate Times Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedTimes = List.generate(
                    _numberOfTimes,
                    (index) => TimeOfDay.now(),
                  );
                });
              },
              child: const Text('Generate Times'),
            ),
            const SizedBox(height: 16),

            // Selected Times List
            ..._selectedTimes.asMap().entries.map((entry) {
              final index = entry.key;
              final time = entry.value;
              return ListTile(
                title: Text(
                  'Time ${index + 1}: ${time.format(context)}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _selectedTimes[index] = pickedTime;
                    });
                  }
                },
              );
            }).toList(),

            // Start Date Picker
            ListTile(
              title: Text(
                'Start Date: ${DateFormat('yyyy-MM-dd').format(_selectedStartDate)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedStartDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedStartDate = pickedDate;
                  });
                }
              },
            ),

            // End Date Picker
            ListTile(
              title: Text(
                'End Date: ${DateFormat('yyyy-MM-dd').format(_selectedEndDate)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedEndDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedEndDate = pickedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Notes Input
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: () async {
                if (_selectedTimes.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please generate and select times'),
                    ),
                  );
                  return;
                }

                final updatedMedicine = Medicine(
                  id: widget.medicine.id,
                  name: _nameController.text,
                  type: _selectedType,
                  dosage: _dosageController.text,
                  time: _selectedTimes
                      .map((time) => time.format(context))
                      .join(', '),
                  frequency: _selectedFrequencyType == 'Weekly'
                      ? 'Every $_selectedDayOfWeek'
                      : '$_numberOfTimes times a day',
                  startDate:
                      DateFormat('yyyy-MM-dd').format(_selectedStartDate),
                  endDate: DateFormat('yyyy-MM-dd').format(_selectedEndDate),
                  notes: _notesController.text,
                  image: _image ?? widget.medicine.image,
                );

                await widget.medicineController.updateMedicine(updatedMedicine);
                Navigator.pop(context, updatedMedicine);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
