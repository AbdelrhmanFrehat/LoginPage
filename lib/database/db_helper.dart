import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:teacher_portal/database/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._();
  static Database? _database;
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

  DBHelper._();

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'local_users.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users(
        id INTEGER PRIMARY KEY,
        fullname TEXT,
        email TEXT,
        username TEXT,
        password TEXT,
        phoneNumber TEXT
      )
    ''');
  }

  Future<int> addUser(Users user) async {
    final db = await database;
    final ref = firebaseDatabase.ref('users/${user.id}');
    await ref.set({
      "fullname": user.fullname,
      "phoneNumber": user.phoneNumber,
      "email": user.email,
      "username": user.username,
    });
    return await db.insert('Users', user.toMap());
  }

  Future<Users?> getUserByUsername(String username) async {
    final db = await database;
    final result = await db.query(
      'Users',
      where: 'username=?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? Users.fromMap(result.first) : null;
  }

  Future<bool> checkUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'Users',
      where: 'username=? AND password=?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  Future<List<Users>> getUsers() async {
    final db = await database;
    final result = await db.query('Users');
    return result.map((e) => Users.fromMap(e)).toList();
  }

  Future<bool> isUsernameExists(String username) async {
    final db = await database;
    final result = await db.query(
      'Users',
      where: 'username=?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<Users?> getUserById(int userId) async {
    final snapshot = await firebaseDatabase.ref().child('users/$userId').get();
    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return Users.fromMap({
        'id': userId,
        'fullname': data['fullname'],
        'email': data['email'],
        'phoneNumber': data['phoneNumber'],
        'username': data['username'],
        'password': '', // يتم جلبها من التخزين المحلي لاحقًا
      });
    }
    return null;
  }
}
