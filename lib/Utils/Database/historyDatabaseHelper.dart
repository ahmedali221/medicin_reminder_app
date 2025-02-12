import 'package:MedTime/Utils/Database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

import '../../Models/medicine.dart';
import '../../Models/medicineHistory.dart';

class HistoryDatabaseHelper {
  final DatabaseInstance _databaseInstance;

  HistoryDatabaseHelper(this._databaseInstance);

  Future<Database> get database async => await _databaseInstance.database;

  Future<int> insertMedicineHistory(MedicineHistory history) async {
    try {
      Database db = await database;
      Map<String, dynamic> historyMap = {
        'id': history.id,
        'medicineId': history.medicine.id,
        'status': history.status,
        'timestamp': history.timestamp.toIso8601String(),
      };

      return await db.insert(
        'medicine_history',
        historyMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting history: $e");
      rethrow;
    }
  }

  Future<List<MedicineHistory>> getAllMedicineHistory(
      List<Medicine> medicines) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> maps = await db.query('medicine_history');
      return maps.map((map) {
        Medicine medicine =
            medicines.firstWhere((m) => m.id == map['medicineId']);
        return MedicineHistory.fromMap(map, medicine);
      }).toList();
    } catch (e) {
      print("Error fetching history: $e");
      rethrow;
    }
  }

  Future<List<MedicineHistory>> getHistoryForMedicine(Medicine medicine) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> maps = await db.query(
        'medicine_history',
        where: 'medicineId = ?',
        whereArgs: [medicine.id],
      );
      return maps.map((map) => MedicineHistory.fromMap(map, medicine)).toList();
    } catch (e) {
      print("Error fetching history for medicine: $e");
      rethrow;
    }
  }

  Future<int> updateMedicineHistory(MedicineHistory history) async {
    try {
      Database db = await database;
      Map<String, dynamic> historyMap = {
        'medicineId': history.medicine.id,
        'status': history.status,
        'timestamp': history.timestamp.toIso8601String(),
      };

      return await db.update(
        'medicine_history',
        historyMap,
        where: 'id = ?',
        whereArgs: [history.id],
      );
    } catch (e) {
      print("Error updating history: $e");
      rethrow;
    }
  }

  Future<int> deleteMedicineHistory(int id) async {
    try {
      return await database.then((db) => db.delete(
            'medicine_history',
            where: 'id = ?',
            whereArgs: [id],
          ));
    } catch (e) {
      print("Error deleting history: $e");
      rethrow;
    }
  }

  Future<void> clearMedicineHistory() async {
    try {
      await database.then((db) => db.delete('medicine_history'));
    } catch (e) {
      print("Error clearing history: $e");
      rethrow;
    }
  }
}
