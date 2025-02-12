import 'package:sqflite/sqflite.dart';

import '../../Models/medicine.dart';
import '../Local Notifications/NotificationScheduler.dart';
import 'databaseHelper.dart';

class MedicineDatabaseHelper {
  final DatabaseInstance _databaseInstance;

  // Constructor to accept the shared database instance
  MedicineDatabaseHelper(this._databaseInstance);

  Future<Database> get database async => await _databaseInstance.database;

  Future<List<Medicine>> getMedicines() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) => Medicine.fromMap(maps[i]));
  }

  Future<List<Medicine>> getMedicinesByType(Medicine medicine) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db
        .query('reminders', where: 'type=?', whereArgs: [medicine.type]);
    return List.generate(maps.length, (i) => Medicine.fromMap(maps[i]));
  }

  Future<int> insertMedicine(Medicine medicine) async {
    Database db = await database;
    int medicineId = await db.insert('reminders', medicine.toMap());
    print("$medicineId Added");
    medicine = medicine.copyWith(id: medicineId); // Use copyWith
    await NotificationScheduler.scheduleNotificationsForMedicine(medicine);
    return medicineId;
  }

  Future<int> updateMedicine(Medicine medicine) async {
    Database db = await database;
    int medicineId = await db.update('reminders', medicine.toMap(),
        where: 'id=?', whereArgs: [medicine.id]);
    print("$medicineId Updated");
    await NotificationScheduler.scheduleNotificationsForMedicine(medicine);
    return medicineId;
  }

  Future<int> deleteMedicine(int id) async {
    Database db = await database;
    int medicineId =
        await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
    print("Medicine Deleted");
    return medicineId;
  }
}
