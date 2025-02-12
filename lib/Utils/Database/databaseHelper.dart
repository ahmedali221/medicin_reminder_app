import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseInstance {
  static Database? _database;

  DatabaseInstance._privateConstructor();

  // Singleton instance
  static final DatabaseInstance instance =
      DatabaseInstance._privateConstructor();

  // Get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'medicine.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    print("Dataabse Created");
    return db;
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Create the reminders table
    await db.execute('''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT,
        dosage TEXT,
        times TEXT,
        frequency TEXT,
        startDate TEXT,
        endDate TEXT,
        notes TEXT,
        image BLOB
      )
    ''');

    // Create the users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        photo TEXT
      )
    ''');

    // Create the medicine_history table
    await db.execute('''
 CREATE TABLE medicine_history(
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 medicineId INTEGER,
 status TEXT,
 timestamp TEXT,
 FOREIGN KEY (medicineId) REFERENCES reminders(id)
)
''');

    print('Database and Tables Created');
  }

  // Upgrade the database
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS reminders');
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS medicine_history');
      await _onCreate(db, newVersion);
    }
  }
}
