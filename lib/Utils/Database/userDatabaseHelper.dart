import 'package:MedTime/Utils/Database/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import '../../Models/user.dart';

class UserDatabaseHelper {
  final DatabaseInstance _databaseInstance;

  // Constructor to accept the shared database instance
  UserDatabaseHelper(this._databaseInstance);

  Future<Database> get database async => await _databaseInstance.database;

  Future<int> insertUser(User user) async {
    Database db = await database;
    int userId = await db.insert('users', user.toMap());
    print("User $userId Added");
    return userId;
  }

  Future<User?> getUser(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    Database db = await database;
    int userId = await db
        .update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
    print("User $userId Updated");
    return userId;
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    int userId = await db.delete('users', where: 'id = ?', whereArgs: [id]);
    print("User Deleted");
    return userId;
  }
}
