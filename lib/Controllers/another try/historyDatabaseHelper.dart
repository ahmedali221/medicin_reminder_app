// import 'package:sqflite/sqflite.dart';
// import '../../Models/medicineHistory.dart';
// import 'databaseHelper.dart'; // Import the shared DatabaseInstance

// class HistoryDatabaseHelper {
//   final DatabaseInstance _databaseInstance;

//   // Constructor to accept the shared database instance
//   HistoryDatabaseHelper(this._databaseInstance);

//   // Getter to access the database
//   Future<Database> get database async => await _databaseInstance.database;

//   // Insert a new history entry
//   Future<int> insertMedicineHistory(MedicineHistory history) async {
//     try {
//       Database db = await database;
//       int historyId = await db.insert(
//         'medicine_history',
//         history.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//       print("History Entry Added with ID: $historyId");
//       return historyId;
//     } catch (e) {
//       print("Error inserting history: $e");
//       rethrow;
//     }
//   }

//   // Fetch all history entries
//   Future<List<MedicineHistory>> getAllMedicineHistory() async {
//     try {
//       Database db = await database;
//       List<Map<String, dynamic>> maps = await db.query('medicine_history');
//       return List.generate(
//           maps.length, (i) => MedicineHistory.fromMap(maps[i]));
//     } catch (e) {
//       print("Error fetching history: $e");
//       rethrow;
//     }
//   }

//   // Fetch history entries for a specific medicine
//   Future<List<MedicineHistory>> getHistoryForMedicine(int medicineId) async {
//     try {
//       Database db = await database;
//       List<Map<String, dynamic>> maps = await db.query(
//         'medicine_history',
//         where: 'medicineId = ?',
//         whereArgs: [medicineId],
//       );
//       return List.generate(
//           maps.length, (i) => MedicineHistory.fromMap(maps[i]));
//     } catch (e) {
//       print("Error fetching history for medicine: $e");
//       rethrow;
//     }
//   }

//   // Update a history entry
//   Future<int> updateMedicineHistory(MedicineHistory history) async {
//     try {
//       Database db = await database;
//       int historyId = await db.update(
//         'medicine_history',
//         history.toMap(),
//         where: 'id = ?',
//         whereArgs: [history.id],
//       );
//       print("History Entry Updated with ID: $historyId");
//       return historyId;
//     } catch (e) {
//       print("Error updating history: $e");
//       rethrow;
//     }
//   }

//   // Delete a history entry by ID
//   Future<int> deleteMedicineHistory(int id) async {
//     try {
//       Database db = await database;
//       int historyId = await db.delete(
//         'medicine_history',
//         where: 'id = ?',
//         whereArgs: [id],
//       );
//       print("History Entry Deleted with ID: $historyId");
//       return historyId;
//     } catch (e) {
//       print("Error deleting history: $e");
//       rethrow;
//     }
//   }

//   // Clear all history entries
//   Future<void> clearMedicineHistory() async {
//     try {
//       Database db = await database;
//       await db.delete('medicine_history');
//       print("All History Entries Cleared");
//     } catch (e) {
//       print("Error clearing history: $e");
//       rethrow;
//     }
//   }
// }
