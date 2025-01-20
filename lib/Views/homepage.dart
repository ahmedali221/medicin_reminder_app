import 'package:clinicapp/Views/medicalTips.dart';
import 'package:clinicapp/Views/UserPages/userProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:clinicapp/Controllers/medicineController.dart';
import 'package:clinicapp/Models/medicine.dart';
import 'package:clinicapp/Views/addMedicinePage.dart';
import '../Controllers/userController.dart';
import '../Utils/Custom Widgets/buttomAppBar.dart';
import '../Utils/Custom Widgets/dateSliderWidget.dart';
import '../Utils/Custom Widgets/detailRow.dart';
import '../Utils/Custom Widgets/searcBar.dart';
import '../Utils/Custom Widgets/userDetailsBar.dart';
import '../Utils/icons.dart';
import 'medicineDetails.dart';

class ReminderListScreen extends ConsumerStatefulWidget {
  @override
  _ReminderListScreenState createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends ConsumerState<ReminderListScreen> {
  // Variable to store the selected date
  DateTime? _selectedDate;

  // Function to filter medicines based on the selected date
  List<Medicine> _filterMedicinesByDate(List<Medicine> medicines) {
    if (_selectedDate == null) {
      return medicines; // Return all medicines if no date is selected
    }

    return medicines.where((medicine) {
      final medicineStartDate = DateTime.parse(medicine.startDate);
      return medicineStartDate.year == _selectedDate!.year &&
          medicineStartDate.month == _selectedDate!.month &&
          medicineStartDate.day == _selectedDate!.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final medicines = ref.watch(medicineControllerProvider);
    final filteredMedicines = _filterMedicinesByDate(medicines);
    final screenWidth = MediaQuery.of(context).size.width;
    final user = ref.watch(userProvider); // Access user data from provider

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // User details Sliver
          SliverToBoxAdapter(
            child: UserDetailsBar(
              userName: user?.name ?? "Guest", // Use user name from provider
              userPhotoUrl: user?.photo ?? "", // Use photo URL from provider
              onSearchPressed: () {
                showSearch(
                    context: context, delegate: CustomSearchDelegate(ref));
              },
            ),
          ),
          // Date slider Sliver
          SliverToBoxAdapter(
            child: DateSlider(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          // "To Take" heading Sliver
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'To Take',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: screenWidth * 0.06, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
              ),
            ),
          ),
          // Medicine list Sliver
          filteredMedicines.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Text(
                      _selectedDate == null
                          ? "No medicines added yet!"
                          : "No medicines found for the selected date.",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Responsive font size
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final medicine = filteredMedicines[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Card(
                          color: Colors.white,
                          elevation: 6,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicineDetailsPage(
                                    medicine: medicine,
                                    medicineController: ref.read(
                                        medicineControllerProvider.notifier),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                spacing: 15,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image or Icon on the left
                                  Container(
                                    width:
                                        screenWidth * 0.3, // Responsive width
                                    height:
                                        screenWidth * 0.2, // Responsive height
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[200],
                                    ),
                                    child: medicine.image != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.memory(
                                              medicine.image!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.medication,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  // Medicine details on the right
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Medicine Name
                                        Text(
                                          medicine.name,
                                          style: TextStyle(
                                            fontSize: screenWidth *
                                                0.045, // Responsive font size
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[900],
                                          ),
                                        ),
                                        // Dosage
                                        buildDetailRow(
                                            'Dosage', medicine.dosage),
                                        // Type (Icon-based)
                                        Row(
                                          children: [
                                            Icon(
                                              medicineTypeIcons[
                                                      medicine.type] ??
                                                  Icons.medication,
                                              size: 20,
                                              color: Colors.blue[900],
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              medicine.type,
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.04,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Time
                                        buildDetailRow('Time', medicine.time),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: filteredMedicines.length,
                  ),
                ),
        ],
      ),
      // Bottom Navigation Bar with Add Button and Medical Tips
      bottomNavigationBar: CustomBottomAppBar(
        onMedicalTipsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicalTipsPage(),
            ),
          );
        },
        onAddMedicinePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMedicinePage(),
            ),
          );
        },
        onProfilePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(),
            ),
          );
        },
      ),
    );
  }
}
