import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../Controllers/medicineController.dart';
import '../Models/medicine.dart';
import '../Utils/Custom Widgets/customInputText.dart';
import '../Utils/Custom Widgets/customDropdownButtonFormField.dart';
import '../Utils/Custom Widgets/customDatePicker.dart';
import '../Utils/Custom Widgets/customTimePicker.dart';
import '../Utils/Helpers/medicineFormHelper.dart';

class EditMedicinePage extends ConsumerStatefulWidget {
  final Medicine medicine;

  const EditMedicinePage({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  @override
  _EditMedicinePageState createState() => _EditMedicinePageState();
}

class _EditMedicinePageState extends ConsumerState<EditMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _notesController;

  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;
  Uint8List? _image;
  int _numberOfTimes = 1;
  List<TimeOfDay> _selectedTimes = [];

  final List<String> _medicineTypes = ['Pills', 'Injection', 'Syrup'];
  String _selectedType = 'Pills';

  final List<String> _frequencyTypes = ['Daily', 'Weekly'];
  String _selectedFrequencyType = 'Daily';

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  String? _selectedDayOfWeek;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine.name);
    _dosageController = TextEditingController(text: widget.medicine.dosage);
    _notesController = TextEditingController(text: widget.medicine.notes);

    _selectedStartDate = DateTime.parse(widget.medicine.startDate);
    _selectedEndDate = DateTime.parse(widget.medicine.endDate);

    if (widget.medicine.frequency.contains('Weekly')) {
      _selectedFrequencyType = 'Weekly';
      _selectedDayOfWeek = widget.medicine.frequency.replaceAll('Every ', '');
    } else {
      _selectedFrequencyType = 'Daily';
      _numberOfTimes =
          int.tryParse(widget.medicine.frequency.split(' ')[0]) ?? 1;
    }

    // Parse the times from the Medicine object
    _selectedTimes = widget.medicine.times.map((time) {
      try {
        final cleanedTime = time.replaceAll(RegExp(r'[^0-9:]'), '');
        final parts = cleanedTime.split(':');
        if (parts.length == 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          return TimeOfDay(hour: hour, minute: minute);
        } else {
          return TimeOfDay.now();
        }
      } catch (e) {
        return TimeOfDay.now();
      }
    }).toList();

    _image = widget.medicine.image;
  }

  Future<void> _updateMedicine(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTimes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please pick and select times'),
          ),
        );
        return;
      }

      if (_selectedEndDate.isBefore(_selectedStartDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End date must be after the start date'),
          ),
        );
        return;
      }

      if (_selectedFrequencyType == 'Weekly' && _selectedDayOfWeek == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Please select a day of the week for weekly frequency'),
          ),
        );
        return;
      }

      // Convert TimeOfDay to String (e.g., "08:00 AM")
      final times = _selectedTimes.map((time) {
        final hour = time.hourOfPeriod;
        final minute = time.minute.toString().padLeft(2, '0');
        final period = time.period == DayPeriod.am ? 'AM' : 'PM';
        return '$hour:$minute $period';
      }).toList();

      // Create the updated Medicine object
      final updatedMedicine = Medicine(
        id: widget.medicine.id,
        name: _nameController.text,
        type: _selectedType,
        dosage: _dosageController.text,
        times: times, // Pass the list of times
        frequency: _selectedFrequencyType == 'Weekly'
            ? 'Every $_selectedDayOfWeek'
            : '$_numberOfTimes times a day',
        startDate: DateFormat('yyyy-MM-dd').format(_selectedStartDate),
        endDate: DateFormat('yyyy-MM-dd').format(_selectedEndDate),
        notes: _notesController.text,
        image: _image,
      );

      try {
        await ref
            .read(medicineControllerProvider.notifier)
            .updateMedicine(updatedMedicine);

        showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            icon:
                const Icon(Icons.verified, color: Color(0xFF1565C0), size: 40),
            title: const Text('Success'),
            content: const Text('Medicine updated successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, updatedMedicine);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update medicine: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Medicine'),
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
                    backgroundImage:
                        _image != null ? MemoryImage(_image!) : null,
                    child: _image == null
                        ? const Icon(Icons.add_a_photo, size: 40)
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
                    if (_selectedType == 'Pills' &&
                        int.tryParse(value) == null) {
                      return 'Please enter a valid number of capsules';
                    }
                    if (_selectedType == 'Syrup' &&
                        double.tryParse(value) == null) {
                      return 'Please enter a valid amount in ml';
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
                      _selectedDayOfWeek = null;
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
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Please enter a valid number of times';
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
                    await _updateMedicine(context, ref);
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
