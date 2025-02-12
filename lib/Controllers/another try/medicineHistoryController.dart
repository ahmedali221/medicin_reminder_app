// import 'package:MedTime/Models/medicine.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../Models/medicineHistory.dart';
// import '../Utils/Database/historyDatabaseHelper.dart';
// import 'medicineController.dart';

// final historyDatabaseHelperProvider = Provider<HistoryDatabaseHelper>((ref) {
//   final databaseInstance = ref.watch(databaseInstanceProvider);
//   return HistoryDatabaseHelper(databaseInstance);
// });

// // MedicineHistoryNotifier class
// class MedicineHistoryNotifier extends StateNotifier<List<MedicineHistory>> {
//   late final HistoryDatabaseHelper _historyDbHelper;

//   MedicineHistoryNotifier(this._historyDbHelper) : super([]) {
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     final medicineHistory = await _historyDbHelper.getAllMedicineHistory();
//     state = medicineHistory;
//   }

//   // Fetch all history entries
//   Future<void> fetchMedicinesHistory() async {
//     final history = await _historyDbHelper.getAllMedicineHistory();
//     state = history;
//   }

//   Future<List<MedicineHistory>> getHistoryForMedicine(int medicineId) async {
//     return await _historyDbHelper.getHistoryForMedicine(medicineId);
//   }

//   Future<void> addMedicineHistory(MedicineHistory history) async {
//     await _historyDbHelper.insertMedicineHistory(history);
//     await fetchMedicinesHistory(); // Refresh the list
//   }

//   // Update a history entry
//   Future<void> updateMedicineHistory(MedicineHistory history) async {
//     await _historyDbHelper.updateMedicineHistory(history);
//     await fetchMedicinesHistory(); // Refresh the list
//   }

//   // Delete a history entry by ID
//   Future<void> deleteMedicineHistory(int id) async {
//     await _historyDbHelper.deleteMedicineHistory(id);
//     await fetchMedicinesHistory(); // Refresh the list
//   }

//   // Clear all history entries
//   Future<void> clearMedicineHistory() async {
//     await _historyDbHelper.clearMedicineHistory();
//     await fetchMedicinesHistory(); // Refresh the list
//   }
// }

// // Step 3: Create a Provider for MedicineNotifier
// final medicineHistoryControllerProvider =
//     StateNotifierProvider<MedicineHistoryNotifier, List<MedicineHistory>>(
//         (ref) {
//   final medicineHistoryDbHelper = ref.watch(historyDatabaseHelperProvider);
//   return MedicineHistoryNotifier(medicineHistoryDbHelper).._initialize();
// });
