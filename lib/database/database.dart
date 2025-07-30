import 'package:sqflite/sqflite.dart';
import '../authentication/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseHelper {
  DatabaseHelper._privteConstractor();
  static final DatabaseHelper instance = DatabaseHelper._privteConstractor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    String path = '$databasePath/login.db';
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Users(
    id INTEGER  PRIMARY KEY,
    fullname TEXT,
    email TEXT,
    username Text,
    password Text,
    phoneNumber Text
    )

    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      db.execute("ALTER TABLE Users ADD COLUMN phoneNumber TEXT");
    }
  }

  Future<List<Users>> getUsers() async {
    Database db = await instance.database;
    var groceries = await db.query('Users');
    List<Users> usersList = groceries.isNotEmpty
        ? groceries.map((e) => Users.fromMap(e)).toList()
        : [];
    return usersList;
  }

  Future<int> addUser(Users user) async {
    Database db = await instance.database;
    final userId = user.id;
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$userId");

    await ref.set({
      "fullname": user.fullname,
      "phoneNumber": user.phoneNumber,
      "email": user.email,
      "username": user.username,
    });
    return await db.insert('Users', user.toMap());
  }

  Future<bool> checkUser(String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM Users WHERE username = ? AND password = ?',
      [username, password],
    );
    return result.isNotEmpty;
  }

  Future<bool> isUsernameExit(String username) async {
    final db = await database;
    final result = await db.query(
      'Users',
      where: 'username=?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<Users?> getUserByUsername(String username) async {
    final db = await database;
    final result = await db.query(
      'Users',
      where: 'username=?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return Users.fromMap(result.first);
    } else {
      return null;
    }
  }

 Future<Users?> getUserById(int userId) async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('users/$userId').get();

  if (snapshot.exists && snapshot.value != null) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return Users.fromMap(data);
  } else {
    print('No data available.');
    return null;
  }
}

}
