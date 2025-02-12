import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Utils/Database/database.dart'; // Import the shared DatabaseInstance
import '../Models/medicine.dart';
import '../Utils/Database/databaseHelper.dart';
import '../Utils/Database/medicineDatabaseHelper.dart';

// Step 1: Create a Provider for DatabaseInstance
final databaseInstanceProvider = Provider<DatabaseInstance>((ref) {
  return DatabaseInstance.instance;
});

// Step 2: Create a Provider for MedicineDatabaseHelper
final medicineDatabaseHelperProvider = Provider<MedicineDatabaseHelper>((ref) {
  final databaseInstance = ref.watch(databaseInstanceProvider);
  return MedicineDatabaseHelper(databaseInstance);
});

class MedicineNotifier extends StateNotifier<List<Medicine>> {
  final MedicineDatabaseHelper _medicineDbHelper;

  MedicineNotifier(this._medicineDbHelper) : super([]) {
    fetchMedicines(); // Load medicines when the provider is created
  }

  Future<void> fetchMedicines() async {
    final medicines = await _medicineDbHelper.getMedicines();
    state = medicines;
  }

  Future<void> addMedicine(Medicine medicine) async {
    await _medicineDbHelper.insertMedicine(medicine);
    await fetchMedicines(); // Refresh the list
  }

  Future<void> updateMedicine(Medicine medicine) async {
    await _medicineDbHelper.updateMedicine(medicine);
    await fetchMedicines(); // Refresh the list
  }

  Future<void> deleteMedicine(int id) async {
    await _medicineDbHelper.deleteMedicine(id);
    await fetchMedicines(); // Refresh the list
  }
}

// Step 3: Create a Provider for MedicineNotifier
final medicineControllerProvider =
    StateNotifierProvider<MedicineNotifier, List<Medicine>>((ref) {
  final medicineDbHelper = ref.watch(medicineDatabaseHelperProvider);
  return MedicineNotifier(medicineDbHelper)..fetchMedicines();
});
