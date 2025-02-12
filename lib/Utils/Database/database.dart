// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../Local Notifications/NotificationScheduler.dart';
// import '../../Models/medicine.dart';
// import '../../Models/user.dart';

// class DatabaseHelper {
//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initiDb();
//     return _database!;
//   }

//   Future<Database> _initiDb() async {
//     String Databasepath = await getDatabasesPath();
//     String path = join(Databasepath, 'medicine.db');
//     Database medicineDb = await openDatabase(path,
//         version: 2, // Increment version
//         onCreate: _onCreate,
//         onUpgrade: _onUpgrade);
//     return medicineDb;
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     // Create the reminders table
//     await db.execute('''
//       CREATE TABLE reminders(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT,
//         type TEXT,
//         dosage TEXT,
//         time TEXT,
//         frequency TEXT,
//         startDate TEXT,
//         endDate TEXT,
//         notes TEXT,
//         image BLOB
//       )
//     ''');

//     // Create the users table
//     await db.execute('''
//       CREATE TABLE users(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         username TEXT UNIQUE,
//         password TEXT,
//         name TEXT,
//         email TEXT, -- New field
//         phoneNumber TEXT, -- New field
//         photo TEXT
//       )
//     ''');

//     print('Database Created');
//   }

//   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     if (oldVersion < 2) {
//       // Step 1: Drop the old reminders table (if needed)
//       await db.execute('DROP TABLE IF EXISTS reminders');

//       // Step 2: Create a new reminders table with the updated schema
//       await db.execute('''
//       CREATE TABLE reminders(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT,
//         dosage TEXT,
//         time TEXT,
//         frequency TEXT,
//         startDate TEXT,
//         endDate TEXT,
//         notes TEXT,
//         type TEXT,
//         image BLOB
//       )
//       ''');

//       // Step 3: Create the users table with the new schema
//       await db.execute('''
//       CREATE TABLE IF NOT EXISTS users(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         username TEXT UNIQUE,
//         password TEXT,
//         name TEXT,
//         email TEXT, -- New field
//         phoneNumber TEXT, -- New field
//         photo TEXT
//       )
//       ''');
//     }
//   }

//   // Methods for reminders table
//   Future<List<Medicine>> getMedicines() async {
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db.query('reminders');
//     List<Medicine> medicines = List.generate(maps.length, (i) {
//       return Medicine.fromMap(maps[i]);
//     });
//     return medicines;
//   }

//   Future<List<Medicine>> getMedicinesByType(Medicine medicine) async {
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db
//         .query('reminders', where: 'type=?', whereArgs: [medicine.type]);
//     List<Medicine> medicines = List.generate(maps.length, (i) {
//       return Medicine.fromMap(maps[i]);
//     });
//     return medicines;
//   }

//   Future<int> insertMedicine(Medicine medicine) async {
//     Database db = await database;
//     int medicineId = await db.insert('reminders', medicine.toMap());
//     print("$medicineId Added");

//     // Create a new Medicine object with the updated ID
//     final updatedMedicine = Medicine(
//       id: medicineId,
//       name: medicine.name,
//       type: medicine.type,
//       dosage: medicine.dosage,
//       time: medicine.time,
//       frequency: medicine.frequency,
//       startDate: medicine.startDate,
//       endDate: medicine.endDate,
//       notes: medicine.notes,
//     );
//     // Schedule a notification for the new medicine
//     await NotificationScheduler.scheduleNotificationForMedicine(
//         updatedMedicine);

//     return medicineId;
//   }

//   Future<int> updateMedicine(Medicine medicine) async {
//     Database db = await database;
//     int medicineId = await db.update('reminders', medicine.toMap(),
//         where: 'id=?', whereArgs: [medicine.id]);
//     print("$medicineId Updated");
//     await NotificationScheduler.scheduleNotificationForMedicine(medicine);

//     return medicineId;
//   }

//   Future<int> deleteMedicine(int id) async {
//     Database db = await database;
//     int medicineId = await db.delete(
//       'reminders',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     print("Medicine Deleted");
//     return medicineId;
//   }

//   // Methods for users table
//   Future<int> insertUser(User user) async {
//     Database db = await database;
//     int userId = await db.insert('users', user.toMap());
//     print("User $userId Added");
//     return userId;
//   }

//   Future<User?> getUser(String username) async {
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db.query(
//       'users',
//       where: 'username = ?',
//       whereArgs: [username],
//     );
//     if (maps.isNotEmpty) {
//       return User.fromMap(maps.first);
//     }
//     return null;
//   }

//   Future<int> updateUser(User user) async {
//     Database db = await database;
//     int userId = await db
//         .update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
//     print("User $userId Updated");
//     return userId;
//   }

//   Future<int> deleteUser(int id) async {
//     Database db = await database;
//     int userId = await db.delete(
//       'users',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     print("User Deleted");
//     return userId;
//   }
// }
