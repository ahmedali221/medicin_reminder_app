import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/medicineHistory.dart';
import '../Models/medicine.dart';
import '../Utils/Database/historyDatabaseHelper.dart';
import 'medicineController.dart';

final historyDatabaseHelperProvider = Provider<HistoryDatabaseHelper>((ref) {
  final databaseInstance = ref.watch(databaseInstanceProvider);
  return HistoryDatabaseHelper(databaseInstance);
});

class MedicineHistoryNotifier extends StateNotifier<List<MedicineHistory>> {
  final HistoryDatabaseHelper _historyDbHelper;
  final List<Medicine> _medicines;

  MedicineHistoryNotifier(this._historyDbHelper, this._medicines) : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    final medicineHistory =
        await _historyDbHelper.getAllMedicineHistory(_medicines);
    state = medicineHistory;
  }

  Future<void> fetchMedicinesHistory() async {
    state = await _historyDbHelper.getAllMedicineHistory(_medicines);
  }

  Future<List<MedicineHistory>> getHistoryForMedicine(Medicine medicine) async {
    return await _historyDbHelper.getHistoryForMedicine(medicine);
  }

  Future<void> addMedicineHistory(MedicineHistory history) async {
    await _historyDbHelper.insertMedicineHistory(history);
    await fetchMedicinesHistory();
  }

  Future<void> updateMedicineHistory(MedicineHistory history) async {
    await _historyDbHelper.updateMedicineHistory(history);
    await fetchMedicinesHistory();
  }

  Future<void> deleteMedicineHistory(int id) async {
    await _historyDbHelper.deleteMedicineHistory(id);
    await fetchMedicinesHistory();
  }

  Future<void> clearMedicineHistory() async {
    await _historyDbHelper.clearMedicineHistory();
    await fetchMedicinesHistory();
  }
}

final medicineHistoryControllerProvider =
    StateNotifierProvider<MedicineHistoryNotifier, List<MedicineHistory>>(
        (ref) {
  final medicineHistoryDbHelper = ref.watch(historyDatabaseHelperProvider);
  final medicines = ref.watch(medicineControllerProvider);
  return MedicineHistoryNotifier(medicineHistoryDbHelper, medicines)
    .._initialize();
});
