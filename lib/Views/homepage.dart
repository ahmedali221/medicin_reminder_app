import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../Controllers/medicineController.dart';
import '../Controllers/medicineHistoryController.dart';
import '../Controllers/userController.dart';
import '../Models/medicine.dart';
import '../Models/medicineHistory.dart';
import '../Utils/Api/View/topicsListPage.dart';
import '../Utils/Custom Widgets/buttomAppBar.dart';
import '../Utils/Custom Widgets/custom_Drawer.dart';
import '../Utils/Custom Widgets/dateSliderWidget.dart';
import '../Utils/Custom Widgets/searcBar.dart';
import '../Utils/Custom Widgets/userDetailsBar.dart';
import '../Utils/Helper Functions/functions.dart';
import '../Utils/icons.dart';
import 'UserPages/userProfilePage.dart';
import 'addMedicinePage.dart';
import 'medicineDetails.dart';
import 'medicineHistoryPage.dart';

class ReminderListScreen extends ConsumerStatefulWidget {
  @override
  _ReminderListScreenState createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends ConsumerState<ReminderListScreen> {
  DateTime? _selectedDate;

  List<Medicine> _filterMedicinesByDate(List<Medicine> medicines) {
    if (_selectedDate == null) {
      return medicines;
    }

    return medicines.where((medicine) {
      final medicineStartDate = DateTime.parse(medicine.startDate);
      return medicineStartDate.year == _selectedDate!.year &&
          medicineStartDate.month == _selectedDate!.month &&
          medicineStartDate.day == _selectedDate!.day;
    }).toList();
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  Future<void> _addHistoryEntry(Medicine medicine, String status) async {
    // Check if daily dosage limit is exceeded
    final medicineHistories = ref.read(medicineHistoryControllerProvider);
    final takenToday = medicineHistories
        .where((history) =>
            history.medicine.id == medicine.id &&
            history.status == "Taken" &&
            history.timestamp
                .isAfter(DateTime.now().subtract(const Duration(days: 1))))
        .length;

    if (takenToday >= int.parse(medicine.dosage)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum daily dosage for ${medicine.name} reached'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    MedicineHistory history = MedicineHistory(
      medicine: medicine,
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

  Future<void> _confirmDelete(Medicine medicine) async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Delete Medicine'),
        content: const Text('Are you sure you want to delete this medicine?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await ref
          .read(medicineControllerProvider.notifier)
          .deleteMedicine(medicine.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medicine deleted successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicines = ref.watch(medicineControllerProvider);
    final filteredMedicines = _filterMedicinesByDate(medicines);
    final screenWidth = MediaQuery.of(context).size.width;
    final user = ref.watch(userProvider);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: CustomDrawer(
          onHomePressed: () {
            Navigator.pop(context);
          },
          onHistoryPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MedicineHistoryPage(),
              ),
            );
          },
          onTipsPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TopicsListPage(),
              ),
            );
          },
          onSettingsPressed: () {
            Navigator.pop(context);
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
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: UserDetailsBar(
                  context: context,
                  userName: user?.name ?? "Guest",
                  userPhotoUrl: user?.photo ?? "",
                  onSearchPressed: () {
                    showSearch(
                        context: context, delegate: CustomSearchDelegate(ref));
                  },
                ),
              ),
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
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'To Take',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1565C0),
                        ),
                  ),
                ),
              ),
              filteredMedicines.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          _selectedDate == null
                              ? "No medicines added yet!"
                              : "No medicines found for the selected date.",
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final medicine = filteredMedicines[index];

                          return Dismissible(
                            key: Key(
                              medicine.id.toString(),
                            ),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.white,
                              child: const Icon(
                                Icons.delete,
                                size: 50,
                                color: Colors.red,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              await _confirmDelete(medicine);
                            },
                            child: Padding(
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
                                        builder: (context) =>
                                            MedicineDetailsPage(
                                          medicine: medicine,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      spacing: 15,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: screenWidth * 0.25,
                                          height: screenWidth * 0.2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.grey[200],
                                          ),
                                          child: medicine.image != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.memory(
                                                    medicine.image!,
                                                    fit: BoxFit.contain,
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.medication,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                medicine.name,
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.045,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0xFF1565C0),
                                                ),
                                              ),
                                              Text(
                                                "${medicine.dosage}\t${medicine.type}",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Wrap(
                                                    spacing: 8.0,
                                                    children: medicine.times
                                                        .map((time) {
                                                      return Text(
                                                        time,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const HugeIcon(
                                            icon:
                                                HugeIcons.strokeRoundedGivePill,
                                            color: Color(0xFF1565C0),
                                            size: 30.0,
                                          ),
                                          onPressed: () {
                                            _addHistoryEntry(medicine, "Taken");
                                          },
                                        ),
                                      ],
                                    ),
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
        ),
        bottomNavigationBar: CustomBottomAppBar(
          onAddMedicinePressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMedicinePage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
