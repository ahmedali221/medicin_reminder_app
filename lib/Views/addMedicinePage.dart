import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Controllers/medicineController.dart';
import '../Models/medicine.dart';
import '../Utils/Custom Widgets/customInputText.dart';
import '../Utils/Custom Widgets/customDropdownButtonFormField.dart';
import '../Utils/Custom Widgets/customDatePicker.dart';
import '../Utils/Custom Widgets/customTimePicker.dart';
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
  final _numberOfTimesController =
      TextEditingController(); // New controller for number of times

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
  void initState() {
    super.initState();
    // Initialize the controller with the default value
    _numberOfTimesController.text = _numberOfTimes.toString();
  }

  @override
  void dispose() {
    // Dispose the controllers to avoid memory leaks
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    _numberOfTimesController.dispose();
    super.dispose();
  }

  Future<void> _addMedicine(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      // Validate selected times
      if (_selectedTimes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please pick and select times'),
          ),
        );
        return;
      }

      // Validate start date
      if (_selectedStartDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a start date'),
          ),
        );
        return;
      }

      // Validate end date
      if (_selectedEndDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an end date'),
          ),
        );
        return;
      }

      // Create the Medicine object
      final medicine = Medicine(
        name: _nameController.text,
        type: _selectedType,
        dosage: _dosageController.text,
        time: _selectedTimes.map((time) => time.format(context)).join(', '),
        frequency: _selectedFrequencyType == 'Weekly'
            ? 'Every $_selectedDayOfWeek'
            : '$_numberOfTimes times a day',
        startDate: _selectedStartDate!.toLocal().toString().split(' ')[0],
        endDate: _selectedEndDate!.toLocal().toString().split(' ')[0],
        notes: _notesController.text,
        image: _image,
      );

      try {
        // Add the medicine using the provider
        await ref
            .read(medicineControllerProvider.notifier)
            .addMedicine(medicine);

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            icon:
                const Icon(Icons.verified, color: Color(0xFF1565C0), size: 40),
            title: const Text('Success'),
            content: const Text('Medicine added successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add medicine: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Medicine',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
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
                    backgroundColor: Colors.white,
                    backgroundImage:
                        _image != null ? MemoryImage(_image!) : null,
                    child: _image == null
                        ? const Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: const Color(0xFF1565C0),
                          )
                        : null,
                  ),
                ),

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

                // Medicine Type Dropdown
                CustomDropdownButtonFormField<String>(
                  value: _selectedType,
                  labelText: 'Type',
                  items: _medicineTypes,
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

                // Frequency Type Dropdown
                CustomDropdownButtonFormField<String>(
                  value: _selectedFrequencyType,
                  labelText: 'Frequency Type',
                  items: _frequencyTypes,
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

                // Day of the Week Dropdown (for Weekly Frequency)
                if (_selectedFrequencyType == 'Weekly')
                  CustomDropdownButtonFormField<String>(
                    value: _selectedDayOfWeek,
                    labelText: 'Day of the Week',
                    items: _daysOfWeek,
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

                // Number of Times Input
                CustomTextInput(
                  controller: _numberOfTimesController,
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
                  child: const Text('Pick Times'),
                ),

                // Selected Times List
                ..._selectedTimes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final time = entry.value;
                  return CustomTimePicker(
                    labelText: 'Time ${index + 1}',
                    selectedTime: time,
                    onTimeSelected: (pickedTime) {
                      setState(() {
                        _selectedTimes[index] = pickedTime;
                      });
                    },
                  );
                }).toList(),

                // Start Date Picker
                CustomDatePicker(
                  labelText: 'Start Date',
                  selectedDate: _selectedStartDate,
                  onDateSelected: (pickedDate) {
                    setState(() {
                      _selectedStartDate = pickedDate;
                    });
                  },
                ),

                // End Date Picker
                CustomDatePicker(
                  labelText: 'End Date',
                  selectedDate: _selectedEndDate,
                  onDateSelected: (pickedDate) {
                    setState(() {
                      _selectedEndDate = pickedDate;
                    });
                  },
                ),

                // Notes Input
                CustomTextInput(
                  controller: _notesController,
                  labelText: 'Notes',
                ),

                // Save Button
                ElevatedButton(
                  onPressed: () async {
                    await _addMedicine(context, ref);
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
