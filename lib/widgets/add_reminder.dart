import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Utils/utils.dart';
import 'package:material_symbols_icons/symbols.dart';
// Assuming this is your custom date time picker widget

class AddReminderBottomSheet extends StatefulWidget {
  const AddReminderBottomSheet({super.key});

  @override
  _AddReminderBottomSheetState createState() => _AddReminderBottomSheetState();
}

class _AddReminderBottomSheetState extends State<AddReminderBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();
  String selectedFrequency = 'Daily';
  int numberOfTimePickers = 1;
  List<TimeOfDay> selectedTimes = [
    TimeOfDay.now()
  ]; // Initialize with a default value

  final TimeOfDay _selectedTime = TimeOfDay.now();
  MedicineType selectedMedicineType = MedicineType.Tablet;
  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTimes[index],
    );

    if (pickedTime != null) {
      setState(() {
        selectedTimes[index] = pickedTime;
      });
    }
  }

  final _nameController = TextEditingController();

  Widget _buildMedicineTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () => setState(
            () {
              selectedMedicineType = MedicineType.Tablet;
            },
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Restrict widget height
            children: [
              Icon(
                Symbols.medication_rounded,
                color: selectedMedicineType == MedicineType.Tablet
                    ? Colors.green
                    : Colors.grey,
              ),
              const SizedBox(height: 5.0),
              Text(
                'Tablet',
                style: TextStyle(
                  color: selectedMedicineType == MedicineType.Tablet
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        //Capsule
        InkWell(
          onTap: () => setState(
            () {
              selectedMedicineType = MedicineType.Capsule;
            },
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Restrict widget height
            children: [
              Icon(
                Icons.medical_services_outlined,
                color: selectedMedicineType == MedicineType.Capsule
                    ? Colors.green
                    : Colors.grey,
              ),
              const SizedBox(height: 5.0),
              Text(
                'Capsule',
                style: TextStyle(
                  color: selectedMedicineType == MedicineType.Capsule
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        //Syrup
        InkWell(
          onTap: () => setState(
            () {
              selectedMedicineType = MedicineType.Syrup;
            },
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Restrict widget height
            children: [
              Icon(
                Icons.local_drink_rounded,
                color: selectedMedicineType == MedicineType.Syrup
                    ? Colors.green
                    : Colors.grey,
              ),
              const SizedBox(height: 5.0),
              Text(
                'Syrup',
                style: TextStyle(
                  color: selectedMedicineType == MedicineType.Syrup
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        //injection
        InkWell(
          onTap: () => setState(
            () {
              selectedMedicineType = MedicineType.Injection;
            },
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Restrict widget height
            children: [
              Icon(
                Symbols.syringe_rounded,
                color: selectedMedicineType == MedicineType.Injection
                    ? Colors.green
                    : Colors.grey,
              ),
              const SizedBox(height: 5.0),
              Text(
                'Injection',
                style: TextStyle(
                  color: selectedMedicineType == MedicineType.Injection
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Ensures content stays within safe area
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Restrict content size
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Medicine Name'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Start Date'),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        DateFormat('d MMM y')
                            .format(DateTime.now()), // Format the date
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('End Date'),
                    TextButton(
                      onPressed: () async {
                        var selectedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 30),
                          ),
                        );
                        setState(() {
                          // Update the text based on selectedDate
                          _selectedDate = selectedDate!;
                        });
                      },
                      child: Text(
                        DateFormat('d MMM y')
                            .format(_selectedDate), // Format the date
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Doses'),
                    CustomizableCounter(
                      borderRadius: 20,
                      backgroundColor: Colors.transparent,
                      textColor: Colors.grey,
                      textSize: 22,
                      count: 1,
                      step: 1,
                      borderColor: Colors.grey,
                      minCount: 0,
                      maxCount: 3,
                      incrementIcon: const Icon(
                        Icons.add,
                        color: Colors.grey,
                      ),
                      decrementIcon: const Icon(
                        Icons.remove,
                        color: Colors.grey,
                      ),
                      onCountChange: (dosesNum) {
                        setState(() {
                          numberOfTimePickers = dosesNum.toInt();
                          selectedTimes = List.filled(
                            numberOfTimePickers,
                            TimeOfDay.now(),
                          );
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                _buildMedicineTypeSelection(),
                const SizedBox(height: 15.0),
                DropdownButtonFormField<String>(
                  value: selectedFrequency,
                  items: ['Daily', 'Weekly', 'Monthly']
                      .map((frequency) => DropdownMenuItem(
                            value: frequency,
                            child: Text(frequency),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(
                      () {
                        selectedFrequency = value!;
                      },
                    );
                  },
                  decoration: const InputDecoration(labelText: 'Frequency'),
                ),
                const SizedBox(height: 15.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: numberOfTimePickers,
                  itemBuilder: (context, index) {
                    DateTime formattedTime = DateTime.now().copyWith(
                      hour: selectedTimes[index].hour,
                      minute: selectedTimes[index].minute,
                    );

                    String formattedTimeString =
                        DateFormat('hh:mm a').format(formattedTime.toLocal());
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () =>
                              _selectTime(context, index), // Pass index
                          child: Text('Select Dose Number ${index + 1}'),
                        ),
                        Text(
                          formattedTimeString,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 15.0),
                ElevatedButton(
                  onPressed: () async {
                    // Get time based on selected time picker
                    DateTime dateTime = DateTime.now().copyWith(
                      hour: _selectedTime.hour,
                      minute: _selectedTime.minute,
                    );

                    // Handle empty selectedTimes list
                    if (selectedTimes.isEmpty) {
                      print('Please select at least one dosage time.');
                      return; // Exit the function if no times are selected
                    }

                    // Convert selected times to Timestamp list with null safety
                    List<Timestamp?> timestamps = selectedTimes.map((time) {
                      DateTime combinedDateTime = dateTime.copyWith(
                        hour: time.hour,
                        minute: time.minute,
                      );
                      return Timestamp.fromDate(combinedDateTime);
                    }).toList();

                    try {
                      // Add medicine reminder to Firebase
                      await FirebaseFirestore.instance
                          .collection('medicine')
                          .add(
                        {
                          'name': capitalizeFirstLetters(_nameController.text),
                          'dosage': numberOfTimePickers,
                          'frequency': selectedFrequency,
                          'start_date': FieldValue.serverTimestamp(),
                          'end_date': Timestamp.fromDate(_selectedDate),
                          'times': timestamps
                              .where((t) => t != null)
                              .toList(), // Filter out null timestamps
                          'medicineType': selectedMedicineType.toString(),
                        },
                      );

                      // Show success dialog
                      // Show success dialog

                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.all(20.0),
                          title: const Row(
                            children: [
                              Icon(
                                Icons.done_rounded,
                                color: Colors.green,
                                size: 30.0,
                              ),
                              SizedBox(width: 10.0),
                              Text('Success!'),
                            ],
                          ),
                          content: const Text(
                            'Medicine reminder added successfully.',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Pop until the main page

                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green,
                              ),
                              child: const Text('Okay'),
                            ),
                          ],
                        ),
                      );
                    } catch (error) {
                      // Handle errors here (e.g., show an error message)
                      print('Error adding medicine reminder: $error');
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String capitalizeFirstLetters(String input) {
    List<String> words = input.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1);
    }).toList();
    return capitalizedWords.join(' ');
  }
}
