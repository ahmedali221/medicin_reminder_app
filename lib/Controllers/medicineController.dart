import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Utils/Database/database.dart';
import '../Models/medicine.dart';

// Step 1: Create a Provider for DatabaseHelper
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

class MedicineNotifier extends StateNotifier<List<Medicine>> {
  final DatabaseHelper _dbHelper;

  MedicineNotifier(this._dbHelper) : super([]) {
    fetchMedicines(); // Load medicines when the provider is created
  }

  Future<void> fetchMedicines() async {
    final medicines = await _dbHelper.getMedicines();
    state = medicines;
  }

  Future<void> addMedicine(Medicine medicine) async {
    await _dbHelper.insertMedicine(medicine);
    await fetchMedicines(); // Refresh the list
  }

  Future<void> updateMedicine(Medicine medicine) async {
    await _dbHelper.updateMedicine(medicine);
    await fetchMedicines(); // Refresh the list
  }

  Future<void> deleteMedicine(int id) async {
    await _dbHelper.deleteMedicine(id);
    await fetchMedicines(); // Refresh the list
  }
}

// Step 3: Create a Provider for MedicineNotifier
final medicineControllerProvider =
    StateNotifierProvider<MedicineNotifier, List<Medicine>>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return MedicineNotifier(dbHelper)..fetchMedicines();
});
