import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinicapp/Controllers/medicineController.dart';
import 'package:clinicapp/Models/medicine.dart';
import '../Utils/Custom Widgets/customInputText.dart';
import '../Utils/Helpers/medicineFormHelper.dart';

class AddMedicinePage extends ConsumerStatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends ConsumerState<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Image Picker
                GestureDetector(
                  onTap: () async {
                    final imageBytes =
                        await MedicineFormHelper.pickImage(context);
                    if (imageBytes != null) {
                      setState(() {
                        _image = imageBytes;
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _image != null ? MemoryImage(_image!) : null,
                    child: _image == null
                        ? const Icon(Icons.add_a_photo, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Medicine Name
                CustomTextInput(
                  controller: _nameController,
                  labelText: 'Name',
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
                CustomTextInput(
                  controller: _dosageController,
                  labelText: _selectedType == 'Pills'
                      ? 'Number of Capsules'
                      : _selectedType == 'Syrup'
                          ? 'Amount in ml'
                          : 'Dosage Quantity',
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
                  decoration:
                      const InputDecoration(labelText: 'Frequency Type'),
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
                    decoration:
                        const InputDecoration(labelText: 'Day of the Week'),
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
                CustomTextInput(
                  controller: TextEditingController(
                    text: _numberOfTimes.toString(),
                  ),
                  labelText: 'Number of Times',
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
                      final pickedTime =
                          await MedicineFormHelper.selectTime(context, time);
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
                    _selectedStartDate == null
                        ? 'Select Start Date'
                        : 'Selected Start Date: ${_selectedStartDate!.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final pickedDate =
                        await MedicineFormHelper.selectStartDate(context);
                    if (pickedDate != null) {
                      setState(() {
                        _selectedStartDate = pickedDate;
                        if (_selectedEndDate != null &&
                            _selectedEndDate!.isBefore(pickedDate)) {
                          _selectedEndDate = null;
                        }
                      });
                    }
                  },
                ),

                // End Date Picker
                ListTile(
                  title: Text(
                    _selectedEndDate == null
                        ? 'Select End Date'
                        : 'Selected End Date: ${_selectedEndDate!.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final pickedDate = await MedicineFormHelper.selectEndDate(
                        context, _selectedStartDate!);
                    if (pickedDate != null) {
                      setState(() {
                        _selectedEndDate = pickedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Notes Input
                CustomTextInput(
                  controller: _notesController,
                  labelText: 'Notes',
                ),
                const SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedTimes.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please generate and select times'),
                          ),
                        );
                        return;
                      }
                      if (_selectedStartDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a start date'),
                          ),
                        );
                        return;
                      }
                      if (_selectedEndDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an end date'),
                          ),
                        );
                        return;
                      }

                      final medicine = Medicine(
                        name: _nameController.text,
                        type: _selectedType,
                        dosage: _dosageController.text,
                        time: _selectedTimes
                            .map((time) => time.format(context))
                            .join(', '),
                        frequency: _selectedFrequencyType == 'Weekly'
                            ? 'Every $_selectedDayOfWeek'
                            : '$_numberOfTimes times a day',
                        startDate: _selectedStartDate!
                            .toLocal()
                            .toString()
                            .split(' ')[0],
                        endDate: _selectedEndDate!
                            .toLocal()
                            .toString()
                            .split(' ')[0],
                        notes: _notesController.text,
                        image: _image,
                      );

                      await ref
                          .read(medicineControllerProvider.notifier)
                          .addMedicine(medicine);

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
